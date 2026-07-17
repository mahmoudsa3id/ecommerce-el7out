// ============================================================
// features/payment/data/repositories/payment_repository_impl.dart
// ============================================================
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';
import 'package:ecommerce_el7out/features/payment/domain/repository/payment_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/payment_entity.dart';
import '../datasources/payment_remote_datasource.dart';

@LazySingleton(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource _remote;
  final NetworkInfo _network;

  PaymentRepositoryImpl(this._remote, this._network);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() fn) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await fn());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> createCashTransferPayment({
    required String orderId,
    required String userId,
    required double totalAmount,
    required Uint8List proofImageBytes,
    required String proofImageExt,
  }) => _guard(
    () => _remote.createCashTransferPayment(
      orderId: orderId,
      userId: userId,
      totalAmount: totalAmount,
      proofImageBytes: proofImageBytes,
      proofImageExt: proofImageExt,
    ),
  );

  @override
  Future<Either<Failure, String>> getPayMobPaymentKey({
    required String orderId,
    required double amount,
    required AddressEntity billingAddress,
    required PaymentMethodType method,
    required int integrationId,
  }) => _guard(
    () => _remote.getPayMobPaymentKey(
      orderId: orderId,
      amount: amount,
      billingAddress: billingAddress,
      method: method,
      integrationId: integrationId,
    ),
  );

  @override
  Future<Either<Failure, PaymentEntity>> verifyPayMobTransaction({
    required String orderId,
    required String userId,
    required String transactionId,
    required double amount,
    required PaymentMethodType method,
  }) => _guard(
    () => _remote.verifyPayMobTransaction(
      orderId: orderId,
      userId: userId,
      transactionId: transactionId,
      amount: amount,
      method: method,
    ),
  );

  @override
  Future<Either<Failure, PaymentEntity?>> getPaymentByOrderId(String orderId) =>
      _guard(() => _remote.getPaymentByOrderId(orderId));

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByUser(
    String userId,
  ) => _guard(() => _remote.getPaymentsByUser(userId));
}
