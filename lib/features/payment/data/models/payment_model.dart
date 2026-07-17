// ============================================================
// features/payment/data/models/payment_model.dart
// ============================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.orderId,
    required super.userId,
    required super.method,
    required super.status,
    required super.totalAmount,
    required super.paidAmount,
    required super.pendingAmount,
    super.proofImageUrl,
    super.paymobTransactionId,
    super.paymobOrderId,
    super.cardLastFour,
    required super.createdAt,
    super.verifiedAt,
  });

  factory PaymentModel.fromFirestore(Map<String, dynamic> j, String id) =>
      PaymentModel(
        id: id,
        orderId: j['orderId'] as String? ?? '',
        userId: j['userId'] as String? ?? '',
        method: _methodFromString(j['method'] as String?),
        status: _statusFromString(j['status'] as String?),
        totalAmount: (j['totalAmount'] as num?)?.toDouble() ?? 0,
        paidAmount: (j['paidAmount'] as num?)?.toDouble() ?? 0,
        pendingAmount: (j['pendingAmount'] as num?)?.toDouble() ?? 0,
        proofImageUrl: j['proofImageUrl'] as String?,
        paymobTransactionId: j['paymobTransactionId'] as String?,
        paymobOrderId: j['paymobOrderId'] as String?,
        cardLastFour: j['cardLastFour'] as String?,
        createdAt: (j['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        verifiedAt: (j['verifiedAt'] as Timestamp?)?.toDate(),
      );

  Map<String, dynamic> toFirestore() => {
    'orderId': orderId,
    'userId': userId,
    'method': method.name,
    'status': status.name,
    'totalAmount': totalAmount,
    'paidAmount': paidAmount,
    'pendingAmount': pendingAmount,
    'proofImageUrl': proofImageUrl,
    'paymobTransactionId': paymobTransactionId,
    'paymobOrderId': paymobOrderId,
    'cardLastFour': cardLastFour,
    'createdAt': Timestamp.fromDate(createdAt),
    'verifiedAt': verifiedAt != null ? Timestamp.fromDate(verifiedAt!) : null,
  };

  static PaymentMethodType _methodFromString(String? s) {
    switch (s) {
      case 'paymobWallet':
        return PaymentMethodType.paymobWallet;
      case 'card':
        return PaymentMethodType.card;
      default:
        return PaymentMethodType.cashTransfer;
    }
  }

  static PaymentStatus _statusFromString(String? s) {
    switch (s) {
      case 'pendingProof':
        return PaymentStatus.pendingProof;
      case 'proofUploaded':
        return PaymentStatus.proofUploaded;
      case 'processing':
        return PaymentStatus.processing;
      case 'paid':
        return PaymentStatus.paid;
      case 'partiallyPaid':
        return PaymentStatus.partiallyPaid;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }
}
