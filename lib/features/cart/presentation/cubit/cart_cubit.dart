// features/cart/presentation/cubit/cart_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:ecommerce_el7out/core/service/analytics_servic.dart';
import 'package:ecommerce_el7out/features/cart/data/models/cart_item_model.dart';
import 'package:ecommerce_el7out/features/cart/domain/repository/cart_repository.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../../product/domain/entities/product_entity.dart';
import 'cart_state.dart';

@lazySingleton
class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;
  final AnalyticsService _analytics;

  CartCubit(this._repository, this._analytics)
    : super(const CartState.initial());

  Future<void> loadCart() async {
    emit(const CartState.loading());
    final result = await _repository.getCart();
    result.fold(
      (f) => emit(CartState.error(f.message)),
      (items) => emit(CartState.loaded(items)),
    );
  }

  Future<void> addProduct(
    ProductEntity product, {
    required String size,
    required String color,
    int quantity = 1,
  }) async {
    final item = CartItemModel.create(
      productId: product.id,
      name: product.name,
      brand: product.brand,
      price: product.price,
      imageUrl: product.imagesForColor(color).isNotEmpty
          ? product.imagesForColor(color).first
          : null,
      selectedSize: size,
      selectedColor: color,
    );
    await _repository.addItem(item..quantity = quantity);
    _analytics.logAddToCart(product.id, product.name, product.price, quantity);
    await loadCart();
  }

  Future<void> updateQuantity(String itemId, int qty) async {
    await _repository.updateQuantity(itemId, qty);
    await loadCart();
  }

  Future<void> removeItem(String itemId) async {
    await _repository.removeItem(itemId);
    await loadCart();
  }

  Future<void> clearCart() async {
    await _repository.clearCart();
    await loadCart();
  }

  Future<void> mergeGuestCart() async {
    final current = state.maybeWhen(
      loaded: (items) => items,
      orElse: () => <CartItemEntity>[],
    );
    await _repository.mergeGuestCart(current);
  }
}

// Import statement needed
