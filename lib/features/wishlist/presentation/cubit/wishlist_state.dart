// features/wishlist/presentation/cubit/wishlist_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/wishlist_item_entity.dart';

part 'wishlist_state.freezed.dart';

@freezed
class WishlistState with _$WishlistState {
  const factory WishlistState.initial() = WishlistInitial;
  const factory WishlistState.loading() = WishlistLoading;
  const factory WishlistState.loaded(List<WishlistItemEntity> items) =
      WishlistLoaded;
  const factory WishlistState.error(String message) = WishlistError;
}
