// features/wishlist/data/repositories/wishlist_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:ecommerce_el7out/features/wishlist/data/datasource/wishlist_local_datasource.dart';
import 'package:ecommerce_el7out/features/wishlist/data/model/wishlist_item_model.dart';
import 'package:ecommerce_el7out/features/wishlist/domain/repository/wishlist_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/wishlist_item_entity.dart';

@LazySingleton(as: WishlistRepository)
class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource local;
  WishlistRepositoryImpl(this.local);

  @override
  Future<Either<Failure, List<WishlistItemEntity>>> getWishlist() async {
    try {
      return Right(await local.getWishlist());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addToWishlist(WishlistItemEntity item) async {
    try {
      final current = await local.getWishlist();
      if (current.any((i) => i.productId == item.productId)) {
        return const Right(null);
      }
      current.add(WishlistItemModel.fromEntity(item));
      await local.saveWishlist(current);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(String productId) async {
    try {
      final current = await local.getWishlist();
      current.removeWhere((i) => i.productId == productId);
      await local.saveWishlist(current);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<bool> isInWishlist(String productId) async {
    final items = await local.getWishlist();
    return items.any((i) => i.productId == productId);
  }
}
