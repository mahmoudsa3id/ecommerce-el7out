// features/cart/domain/repositories/cart_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCart();
  Future<Either<Failure, void>> addItem(CartItemEntity item);
  Future<Either<Failure, void>> updateQuantity(String itemId, int quantity);
  Future<Either<Failure, void>> removeItem(String itemId);
  Future<Either<Failure, void>> clearCart();
  Future<Either<Failure, void>> mergeGuestCart(List<CartItemEntity> guestItems);
}
