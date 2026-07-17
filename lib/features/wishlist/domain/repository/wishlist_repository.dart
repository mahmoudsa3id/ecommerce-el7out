// features/wishlist/domain/repositories/wishlist_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/wishlist_item_entity.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<WishlistItemEntity>>> getWishlist();
  Future<Either<Failure, void>> addToWishlist(WishlistItemEntity item);
  Future<Either<Failure, void>> removeFromWishlist(String productId);
  Future<bool> isInWishlist(String productId);
}
