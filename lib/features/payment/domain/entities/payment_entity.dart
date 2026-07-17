// ============================================================
// features/payment/domain/entities/payment_entity.dart
// ============================================================
import 'package:equatable/equatable.dart';

enum PaymentMethodType {
  cashTransfer, // Partial: 30% InstaPay/Cash up-front + proof image
  paymobWallet, // Full: PayMob mobile wallet (Vodafone Cash, etc.)
  card, // Full: Visa / Mastercard via PayMob
}

enum PaymentStatus {
  pending,
  pendingProof, // Cash transfer – waiting for admin to verify proof
  proofUploaded, // User uploaded screenshot
  processing,
  paid,
  partiallyPaid, // 30% paid, 70% on delivery
  failed,
  refunded,
}

class PaymentEntity extends Equatable {
  final String id;
  final String orderId;
  final String userId;
  final PaymentMethodType method;
  final PaymentStatus status;
  final double totalAmount;
  final double paidAmount;
  final double pendingAmount;
  final String? proofImageUrl; // for cash transfer
  final String? paymobTransactionId; // for PayMob
  final String? paymobOrderId;
  final String? cardLastFour;
  final DateTime createdAt;
  final DateTime? verifiedAt;

  const PaymentEntity({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.method,
    required this.status,
    required this.totalAmount,
    required this.paidAmount,
    required this.pendingAmount,
    this.proofImageUrl,
    this.paymobTransactionId,
    this.paymobOrderId,
    this.cardLastFour,
    required this.createdAt,
    this.verifiedAt,
  });

  bool get isVerified =>
      status == PaymentStatus.paid || status == PaymentStatus.partiallyPaid;

  @override
  List<Object?> get props => [
    id,
    orderId,
    userId,
    method,
    status,
    totalAmount,
    paidAmount,
    pendingAmount,
    proofImageUrl,
    paymobTransactionId,
    paymobOrderId,
    createdAt,
  ];
}

class PayMobAuthResponse {
  final String token;
  const PayMobAuthResponse(this.token);
}

class PayMobOrderResponse {
  final int id;
  const PayMobOrderResponse(this.id);
}

class PayMobPaymentKeyResponse {
  final String paymentKey;
  const PayMobPaymentKeyResponse(this.paymentKey);
}
