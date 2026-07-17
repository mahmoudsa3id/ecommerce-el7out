import 'package:ecommerce_el7out/features/product/domain/entities/product_entity.dart';

class AdminProductState {
  final bool loading;
  final bool actionInProgress;
  final String? error;
  final List<ProductEntity> products;

  const AdminProductState({
    this.loading = false,
    this.actionInProgress = false,
    this.error,
    this.products = const [],
  });

  AdminProductState copyWith({
    bool? loading,
    bool? actionInProgress,
    String? error,
    List<ProductEntity>? products,
  }) {
    return AdminProductState(
      loading: loading ?? this.loading,
      actionInProgress: actionInProgress ?? this.actionInProgress,
      error: error,
      products: products ?? this.products,
    );
  }
}
