// features/orders/data/repositories/order_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:ecommerce_el7out/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_el7out/features/order/data/datasource/order_remote_datasource.dart';
import 'package:ecommerce_el7out/features/order/domain/repository/order_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/order_entity.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remote;
  final NetworkInfo networkInfo;
  OrderRepositoryImpl(this.remote, this.networkInfo);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await action());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders(String userId) =>
      _guard(() => remote.getOrders(userId));

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) =>
      _guard(() => remote.getOrderById(orderId));

  @override
  Future<Either<Failure, OrderEntity>> placeOrder({
    required String userId,
    required List<dynamic> items,
    required AddressEntity address,
    required String paymentMethod,
  }) => _guard(
    () => remote.placeOrder(
      userId: userId,
      items: items.cast<CartItemEntity>(),
      address: address,
      paymentMethod: paymentMethod,
    ),
  );
}
