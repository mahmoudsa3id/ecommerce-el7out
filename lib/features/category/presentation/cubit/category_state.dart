// features/category/presentation/cubit/category_state.dart
import 'package:ecommerce_el7out/features/category/domain/entity/category_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_state.freezed.dart';

@freezed
class CategoryState with _$CategoryState {
  const factory CategoryState.initial() = CategoryInitial;
  const factory CategoryState.loading() = CategoryLoading;
  const factory CategoryState.loaded(List<CategoryEntity> categories) =
      CategoryLoaded;
  const factory CategoryState.error(String message) = CategoryError;
}
