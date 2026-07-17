// features/wishlist/presentation/cubit/wishlist_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:ecommerce_el7out/core/service/analytics_servic.dart';
import 'package:ecommerce_el7out/features/wishlist/domain/repository/wishlist_repository.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/wishlist_item_entity.dart';
import 'wishlist_state.dart';

@injectable
class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository _repository;
  final AnalyticsService _analytics;

  WishlistCubit(this._repository, this._analytics)
    : super(const WishlistState.initial());

  Future<void> load() async {
    emit(const WishlistState.loading());
    final result = await _repository.getWishlist();
    result.fold(
      (f) => emit(WishlistState.error(f.message)),
      (items) => emit(WishlistState.loaded(items)),
    );
  }

  Future<void> toggle(WishlistItemEntity item) async {
    final inWishlist = await _repository.isInWishlist(item.productId);
    if (inWishlist) {
      await _repository.removeFromWishlist(item.productId);
      _analytics.logAddToWishlist(item.productId, item.name, item.price);
    } else {
      await _repository.addToWishlist(item);
    }
    await load();
  }

  Future<bool> isInWishlist(String productId) =>
      _repository.isInWishlist(productId);
}
