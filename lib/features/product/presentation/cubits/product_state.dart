// features/product/presentation/cubit/product_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_entity.dart';

part 'product_state.freezed.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState.initial() = ProductInitial;
  const factory ProductState.loading() = ProductLoading;
  const factory ProductState.loaded(List<ProductEntity> products) =
      ProductLoaded;
  const factory ProductState.error(String message) = ProductError;
}
