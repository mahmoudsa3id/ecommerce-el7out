// ============================================================
// features/payment/domain/repositories/payment_repository.dart
// ============================================================
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment_entity.dart';

abstract class PaymentRepository {
  /// Cash / InstaPay – create pending payment + upload proof
  Future<Either<Failure, PaymentEntity>> createCashTransferPayment({
    required String orderId,
    required String userId,
    required double totalAmount,
    required Uint8List proofImageBytes,
    required String proofImageExt,
  });

  /// PayMob – get payment key for iframe/SDK
  Future<Either<Failure, String>> getPayMobPaymentKey({
    required String orderId,
    required double amount,
    required AddressEntity billingAddress,
    required PaymentMethodType method,
    required int integrationId,
  });

  /// PayMob – verify transaction and update payment status
  Future<Either<Failure, PaymentEntity>> verifyPayMobTransaction({
    required String orderId,
    required String userId,
    required String transactionId,
    required double amount,
    required PaymentMethodType method,
  });

  Future<Either<Failure, PaymentEntity?>> getPaymentByOrderId(String orderId);
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByUser(String userId);
}
