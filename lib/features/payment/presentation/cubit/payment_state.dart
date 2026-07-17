// ============================================================
// features/payment/presentation/cubit/payment_state.dart
// ============================================================
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';
import 'package:ecommerce_el7out/features/payment/domain/entities/pending_order_draft.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_state.freezed.dart';

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState.initial() = PaymentInitial;
  const factory PaymentState.draftReady(PendingOrderDraft d) =
      PaymentDraftReady;
  const factory PaymentState.loadingKey() = PaymentLoadingKey;
  const factory PaymentState.keyReady(String paymentKey) = PaymentKeyReady;
  const factory PaymentState.uploadingProof() = PaymentUploadingProof;
  const factory PaymentState.creatingOrder() = PaymentCreatingOrder;
  const factory PaymentState.success(OrderEntity order) = PaymentSuccess;
  const factory PaymentState.paymentFailed() = PaymentFailed;
  const factory PaymentState.error(String message) = PaymentError;
}
