// features/cart/presentation/cubit/cart_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/cart_item_entity.dart';

part 'cart_state.freezed.dart';

@freezed
class CartState with _$CartState {
  const factory CartState.initial() = CartInitial;
  const factory CartState.loading() = CartLoading;
  const factory CartState.loaded(List<CartItemEntity> items) = CartLoaded;
  const factory CartState.error(String message) = CartError;
}

extension CartStateX on CartState {
  double get total => maybeWhen(
    loaded: (items) => items.fold(0.0, (s, i) => s + i.subtotal),
    orElse: () => 0.0,
  );

  int get itemCount => maybeWhen(
    loaded: (items) => items.fold(0, (s, i) => s + i.quantity),
    orElse: () => 0,
  );
}
