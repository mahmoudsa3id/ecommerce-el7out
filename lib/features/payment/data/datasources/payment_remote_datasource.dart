// ============================================================
// features/payment/data/datasources/payment_remote_datasource.dart
// ============================================================
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_el7out/core/service/paymob_service.dart';
import 'package:ecommerce_el7out/core/service/supabse_storage_service.dart';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart'
    hide PaymentStatus;
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/payment_entity.dart';
import '../models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> createCashTransferPayment({
    required String orderId,
    required String userId,
    required double totalAmount,
    required Uint8List proofImageBytes,
    required String proofImageExt,
  });

  Future<String> getPayMobPaymentKey({
    required String orderId,
    required double amount,
    required AddressEntity billingAddress,
    required PaymentMethodType method,
    required int integrationId,
  });

  Future<PaymentModel> verifyPayMobTransaction({
    required String orderId,
    required String userId,
    required String transactionId,
    required double amount,
    required PaymentMethodType method,
  });

  Future<PaymentModel?> getPaymentByOrderId(String orderId);
  Future<List<PaymentModel>> getPaymentsByUser(String userId);
}

@LazySingleton(as: PaymentRemoteDataSource)
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final FirebaseFirestore _firestore;
  final PayMobService _paymob;
  final SupabaseStorageService _storage;

  PaymentRemoteDataSourceImpl(this._firestore, this._paymob, this._storage);

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(AppConstants.firestorePayments);

  // ── Cash / InstaPay transfer ────────────────────────────────
  @override
  Future<PaymentModel> createCashTransferPayment({
    required String orderId,
    required String userId,
    required double totalAmount,
    required Uint8List proofImageBytes,
    required String proofImageExt,
  }) async {
    try {
      final upfrontAmount = totalAmount * AppConstants.partialUpfrontRatio;
      final remainingAmount = totalAmount * AppConstants.partialOnDeliveryRatio;

      // Upload proof to Supabase
      final proofUrl = await _storage.uploadPaymentProof(
        orderId: orderId,
        bytes: proofImageBytes,
        ext: proofImageExt,
      );

      final id = const Uuid().v4();
      final model = PaymentModel(
        id: id,
        orderId: orderId,
        userId: userId,
        method: PaymentMethodType.cashTransfer,
        status: PaymentStatus.proofUploaded,
        totalAmount: totalAmount,
        paidAmount: upfrontAmount,
        pendingAmount: remainingAmount,
        proofImageUrl: proofUrl,
        createdAt: DateTime.now(),
      );

      await _col.doc(id).set(model.toFirestore());

      // Update order status
      await _firestore
          .collection(AppConstants.firestoreOrders)
          .doc(orderId)
          .update({
            'paymentStatus': 'proofUploaded',
            'paymentMethod': 'cashTransfer',
            'paymentId': id,
          });

      return model;
    } catch (e) {
      throw ServerException('Cash payment failed: $e');
    }
  }

  // ── PayMob payment key ──────────────────────────────────────
  @override
  Future<String> getPayMobPaymentKey({
    required String orderId,
    required double amount,
    required AddressEntity billingAddress,
    required PaymentMethodType method,
    required int integrationId,
  }) async {
    try {
      return await _paymob.fullPaymentKeyFlow(
        amount: amount,
        billingAddress: billingAddress,
        items: [
          {
            'name': 'EL7OUT Order #${orderId.substring(0, 8)}',
            'amount_cents': (amount * 100).toInt(),
            'description': 'Fashion order',
            'quantity': 1,
          },
        ],
        integrationId: integrationId,
      );
    } catch (e) {
      throw ServerException('PayMob key failed: $e');
    }
  }

  // ── PayMob verify ───────────────────────────────────────────
  @override
  Future<PaymentModel> verifyPayMobTransaction({
    required String orderId,
    required String userId,
    required String transactionId,
    required double amount,
    required PaymentMethodType method,
  }) async {
    try {
      final id = const Uuid().v4();
      final model = PaymentModel(
        id: id,
        orderId: orderId,
        userId: userId,
        method: method,
        status: PaymentStatus.paid,
        totalAmount: amount,
        paidAmount: amount,
        pendingAmount: 0,
        paymobTransactionId: transactionId,
        createdAt: DateTime.now(),
        verifiedAt: DateTime.now(),
      );

      await _col.doc(id).set(model.toFirestore());
      await _firestore
          .collection(AppConstants.firestoreOrders)
          .doc(orderId)
          .update({
            'paymentStatus': 'paid',
            'paymentMethod': method.name,
            'paymentId': id,
            'paymobTransactionId': transactionId,
          });

      return model;
    } catch (e) {
      throw ServerException('PayMob verify failed: $e');
    }
  }

  @override
  Future<PaymentModel?> getPaymentByOrderId(String orderId) async {
    try {
      final snap = await _col
          .where('orderId', isEqualTo: orderId)
          .limit(1)
          .get();
      if (snap.docs.isEmpty) return null;
      return PaymentModel.fromFirestore(
        snap.docs.first.data(),
        snap.docs.first.id,
      );
    } catch (e) {
      throw ServerException('Fetch payment failed: $e');
    }
  }

  @override
  Future<List<PaymentModel>> getPaymentsByUser(String userId) async {
    try {
      final snap = await _col
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snap.docs
          .map((d) => PaymentModel.fromFirestore(d.data(), d.id))
          .toList();
    } catch (e) {
      throw ServerException('Fetch payments failed: $e');
    }
  }
}
