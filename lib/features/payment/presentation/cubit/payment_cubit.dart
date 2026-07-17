// ============================================================
// features/payment/presentation/cubit/payment_cubit.dart
// CRITICAL FIX: Order created ONLY after payment succeeds
// ============================================================
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_el7out/core/constants/app_constants.dart';
import 'package:ecommerce_el7out/core/service/analytics_servic.dart';
import 'package:ecommerce_el7out/core/service/paymob_service.dart';
import 'package:ecommerce_el7out/core/service/supabse_storage_service.dart';

import 'package:ecommerce_el7out/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ecommerce_el7out/features/auth/presentation/cubit/auth_state.dart';
import 'package:ecommerce_el7out/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_el7out/features/order/data/datasource/order_remote_datasource.dart';

import 'package:ecommerce_el7out/features/payment/domain/entities/pending_order_draft.dart';
import 'package:ecommerce_el7out/features/payment/domain/entities/payment_entity.dart'
    show PaymentMethodType;

import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart'
    as order_entities;

import 'package:injectable/injectable.dart';

import 'payment_state.dart';

@lazySingleton
class PaymentCubit extends Cubit<PaymentState> {
  final OrderRemoteDataSource _orderDataSource;
  final CartCubit _cartCubit;
  final AuthCubit _authCubit;
  final PayMobService _paymob;
  final SupabaseStorageService _storage;
  final AnalyticsService _analytics;

  // ---- Compatibility: some UI uses legacy verifyTransaction(...) ----

  /// Held in memory – never persisted until payment succeeds
  PendingOrderDraft? _draft;

  PaymentCubit(
    this._orderDataSource,
    this._cartCubit,
    this._authCubit,
    this._paymob,
    this._storage,
    this._analytics,
  ) : super(const PaymentState.initial());

  void setDraft(PendingOrderDraft draft) {
    _draft = draft;
    emit(PaymentState.draftReady(draft));
  }

  // ── FLOW 1: Cash / InstaPay ──────────────────────────────────
  // Step 1: Upload proof → Step 2: Create order → Step 3: Clear cart
  Future<void> submitCashProofAndCreateOrder({
    required Uint8List proofBytes,
    required String proofExt,
  }) async {
    final draft = _draft;
    final auth = _authCubit.state;

    if (draft == null) {
      emit(
        const PaymentState.error('Session expired. Please restart checkout.'),
      );
      return;
    }

    emit(const PaymentState.uploadingProof());

    try {
      // 1 – Upload proof image to Supabase
      final tempOrderId = 'pending-${DateTime.now().millisecondsSinceEpoch}';
      final proofPath = 'proofs/$tempOrderId.$proofExt';
      final proofUrl = await _storage.uploadPaymentProof(
        orderId: tempOrderId,
        bytes: proofBytes,
        ext: proofExt,
      );

      final upfront = draft.total * AppConstants.partialUpfrontRatio;
      final remaining = draft.total * AppConstants.partialOnDeliveryRatio;

      // 2 – Build payment info
      final paymentInfo = order_entities.PaymentInfoEntity(
        method: 'cashTransfer',
        status: order_entities.PaymentStatus.waitingVerification,
        totalAmount: draft.total,
        paidAmount: upfront,
        pendingAmount: remaining,
        proofImageUrl: proofUrl,
        proofImageStoragePath: proofPath,
        paidAt: DateTime.now(),
      );

      // 3 – Create order in Firestore (ONLY here, never before)
      emit(const PaymentState.creatingOrder());
      final order = await _orderDataSource.createOrderAfterPayment(
        draft: draft,
        paymentInfo: paymentInfo,
      );

      // 4 – Clear cart
      await _cartCubit.clearCart();

      // 5 – Analytics
      _analytics.logPurchase(
        orderId: order.id,
        value: upfront,
        items: draft.cartItems
            .map(
              (i) => {
                'id': i.productId,
                'name': i.name,
                'price': i.price,
                'quantity': i.quantity,
              },
            )
            .toList(),
      );

      _draft = null;
      emit(PaymentState.success(order));
    } catch (e) {
      emit(PaymentState.error('Payment submission failed: $e'));
    }
  }

  // ── FLOW 2: PayMob Card ──────────────────────────────────────
  Future<void> getCardPaymentKey() async {
    final draft = _draft;
    if (draft == null) {
      emit(
        const PaymentState.error('Session expired. Please restart checkout.'),
      );
      return;
    }
    emit(const PaymentState.loadingKey());
    try {
      final key = await _paymob.fullPaymentKeyFlow(
        amount: draft.total,
        billingAddress: draft.shippingAddress,
        items: draft.cartItems
            .map(
              (i) => {
                'name': i.name,
                'amount_cents': (i.price * 100).toInt(),
                'description': '${i.selectedColor} / ${i.selectedSize}',
                'quantity': i.quantity,
              },
            )
            .toList(),
        integrationId: AppConstants.paymobCardIntegrationId,
      );
      emit(PaymentState.keyReady(key));
    } catch (e) {
      emit(PaymentState.error('Could not connect to payment gateway: $e'));
    }
  }

  // ── FLOW 3: PayMob Wallet ────────────────────────────────────
  Future<void> getWalletPaymentKey() async {
    final draft = _draft;
    if (draft == null) {
      emit(
        const PaymentState.error('Session expired. Please restart checkout.'),
      );
      return;
    }
    emit(const PaymentState.loadingKey());
    try {
      final key = await _paymob.fullPaymentKeyFlow(
        amount: draft.total,
        billingAddress: draft.shippingAddress,
        items: draft.cartItems
            .map(
              (i) => {
                'name': i.name,
                'amount_cents': (i.price * 100).toInt(),
                'description': '${i.selectedColor} / ${i.selectedSize}',
                'quantity': i.quantity,
              },
            )
            .toList(),
        integrationId: AppConstants.paymobWalletIntegrationId,
      );
      emit(PaymentState.keyReady(key));
    } catch (e) {
      emit(PaymentState.error('Could not connect to payment gateway: $e'));
    }
  }

  /// Called from WebView callback when PayMob confirms payment
  Future<void> onPayMobSuccess({
    required String transactionId,
    required String methodName,
  }) async {
    final draft = _draft;
    final auth = _authCubit.state;
    if (draft == null || auth is! AuthAuthenticated) return;

    emit(const PaymentState.creatingOrder());
    try {
      final paymentInfo = order_entities.PaymentInfoEntity(
        method: methodName,
        status: order_entities.PaymentStatus.paid,
        totalAmount: draft.total,
        paidAmount: draft.total,
        pendingAmount: 0,
        transactionId: transactionId,
        paidAt: DateTime.now(),
      );

      final order = await _orderDataSource.createOrderAfterPayment(
        draft: draft,
        paymentInfo: paymentInfo,
      );

      await _cartCubit.clearCart();

      _analytics.logPurchase(
        orderId: order.id,
        value: draft.total,
        items: draft.cartItems
            .map(
              (i) => {
                'id': i.productId,
                'name': i.name,
                'price': i.price,
                'quantity': i.quantity,
              },
            )
            .toList(),
      );

      _draft = null;
      emit(PaymentState.success(order));
    } catch (e) {
      emit(
        PaymentState.error(
          'Order creation failed after payment. Contact support.',
        ),
      );
    }
  }

  /// Compatibility for UI pages (card/payment callbacks)
  /// These pages pass orderId/amount/billingAddress, but current implementation
  /// relies on in-memory PendingOrderDraft stored via setDraft().
  Future<void> verifyTransaction({
    required String orderId,
    required String transactionId,
    required double amount,
    required PaymentMethodType method,
  }) async {
    // Minimal validation
    final draft = _draft;
    if (draft == null) {
      emit(
        const PaymentState.error('Session expired. Please restart checkout.'),
      );
      return;
    }

    // Map UI method enum -> backend methodName
    final methodName = switch (method) {
      PaymentMethodType.card => 'card',
      PaymentMethodType.paymobWallet => 'paymobWallet',
      PaymentMethodType.cashTransfer => 'cashTransfer',
    };

    await onPayMobSuccess(transactionId: transactionId, methodName: methodName);
  }

  /// PayMob payment failed/cancelled – do NOT create order
  void onPayMobFailure() {
    emit(const PaymentState.paymentFailed());
  }
}
