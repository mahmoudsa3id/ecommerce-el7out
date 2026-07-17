// features/cart/data/repositories/cart_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:ecommerce_el7out/features/cart/data/datasource/cart_local_datasource.dart';
import 'package:ecommerce_el7out/features/cart/domain/repository/cart_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../models/cart_item_model.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource local;
  CartRepositoryImpl(this.local);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCart() =>
      _guard(() => local.getCart());

  @override
  Future<Either<Failure, void>> addItem(CartItemEntity item) =>
      _guard(() async {
        final items = await local.getCart();
        final existing = items.indexWhere(
          (i) =>
              i.productId == item.productId &&
              i.selectedSize == item.selectedSize &&
              i.selectedColor == item.selectedColor,
        );
        if (existing >= 0) {
          items[existing] = CartItemModel.fromEntity(
            items[existing].copyWith(quantity: items[existing].quantity + 1),
          );
        } else {
          items.add(CartItemModel.fromEntity(item));
        }
        await local.saveCart(items);
      });

  @override
  Future<Either<Failure, void>> updateQuantity(String itemId, int quantity) =>
      _guard(() async {
        final items = await local.getCart();
        final idx = items.indexWhere((i) => i.id == itemId);
        if (idx >= 0) {
          if (quantity <= 0) {
            items.removeAt(idx);
          } else {
            items[idx] = CartItemModel.fromEntity(
              items[idx].copyWith(quantity: quantity),
            );
          }
          await local.saveCart(items);
        }
      });

  @override
  Future<Either<Failure, void>> removeItem(String itemId) => _guard(() async {
    final items = await local.getCart();
    items.removeWhere((i) => i.id == itemId);
    await local.saveCart(items);
  });

  @override
  Future<Either<Failure, void>> clearCart() => _guard(() => local.clearCart());

  @override
  Future<Either<Failure, void>> mergeGuestCart(
    List<CartItemEntity> guestItems,
  ) => _guard(() async {
    // Already stored locally; cloud sync would happen here
    // for authenticated users
  });
}
