import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_el7out/core/di/injection.dart';
import 'package:ecommerce_el7out/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_el7out/features/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_el7out/features/admin/presentation/cubit/admin_product_state.dart';
import 'package:ecommerce_el7out/core/service/supabse_storage_service.dart';

class AdminProductCubit extends Cubit<AdminProductState> {
  final ProductRepository _repository = getIt<ProductRepository>();
  final SupabaseStorageService _storageService =
      getIt<SupabaseStorageService>();

  AdminProductCubit() : super(const AdminProductState());

  Future<void> loadProducts() async {
    emit(state.copyWith(loading: true, error: null));
    final result = await _repository.getProducts();
    result.fold(
      (failure) => emit(state.copyWith(loading: false, error: failure.message)),
      (products) =>
          emit(state.copyWith(loading: false, products: products, error: null)),
    );
  }

  Future<void> addProduct(ProductEntity product) async {
    emit(state.copyWith(actionInProgress: true, error: null));
    final result = await _repository.addProduct(product);
    result.fold(
      (failure) =>
          emit(state.copyWith(actionInProgress: false, error: failure.message)),
      (added) => emit(
        state.copyWith(
          actionInProgress: false,
          products: [...state.products, added],
          error: null,
        ),
      ),
    );
  }

  Future<void> updateProduct(ProductEntity product) async {
    emit(state.copyWith(actionInProgress: true, error: null));
    final result = await _repository.updateProduct(product);
    result.fold(
      (failure) =>
          emit(state.copyWith(actionInProgress: false, error: failure.message)),
      (updated) {
        final updatedList = state.products
            .map((item) => item.id == updated.id ? updated : item)
            .toList();
        emit(
          state.copyWith(
            actionInProgress: false,
            products: updatedList,
            error: null,
          ),
        );
      },
    );
  }

  Future<void> deleteProduct(String id) async {
    emit(state.copyWith(actionInProgress: true, error: null));
    final result = await _repository.deleteProduct(id);
    result.fold(
      (failure) =>
          emit(state.copyWith(actionInProgress: false, error: failure.message)),
      (_) {
        final remaining = state.products
            .where((item) => item.id != id)
            .toList();
        emit(
          state.copyWith(
            actionInProgress: false,
            products: remaining,
            error: null,
          ),
        );
      },
    );
  }

  Future<String> uploadProductImage(String productId, List<int> bytes) async {
    final data = Uint8List.fromList(bytes);
    return _storageService.uploadProductImage(productId, data);
  }

  Future<String> uploadVariantImage(
    String productId,
    String colorName,
    List<int> bytes,
  ) async {
    final data = Uint8List.fromList(bytes);
    return _storageService.uploadProductImage(
      productId,
      data,
      variantName: colorName,
    );
  }

  Future<void> deleteProductImages(Iterable<String> urls) {
    return _storageService.deleteProductImagesByUrl(urls);
  }
}
