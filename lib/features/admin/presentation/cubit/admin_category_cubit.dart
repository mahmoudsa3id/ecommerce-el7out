import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_el7out/core/di/injection.dart';
import 'package:ecommerce_el7out/features/category/domain/entity/category_entity.dart';
import 'package:ecommerce_el7out/features/category/domain/repository/category_repository.dart';
import 'package:ecommerce_el7out/features/admin/presentation/cubit/admin_category_state.dart';
import 'package:ecommerce_el7out/core/service/supabse_storage_service.dart';

class AdminCategoryCubit extends Cubit<AdminCategoryState> {
  final CategoryRepository _repository = getIt<CategoryRepository>();
  final SupabaseStorageService _storageService =
      getIt<SupabaseStorageService>();

  AdminCategoryCubit() : super(const AdminCategoryState());

  Future<void> loadCategories() async {
    emit(state.copyWith(loading: true, error: null));
    final result = await _repository.getCategories();
    result.fold(
      (failure) => emit(state.copyWith(loading: false, error: failure.message)),
      (categories) => emit(
        state.copyWith(loading: false, categories: categories, error: null),
      ),
    );
  }

  Future<void> addCategory(CategoryEntity category) async {
    emit(state.copyWith(actionInProgress: true, error: null));
    final result = await _repository.addCategory(category);
    result.fold(
      (failure) =>
          emit(state.copyWith(actionInProgress: false, error: failure.message)),
      (newCategory) => emit(
        state.copyWith(
          actionInProgress: false,
          categories: [...state.categories, newCategory],
          error: null,
        ),
      ),
    );
  }

  Future<void> updateCategory(CategoryEntity category) async {
    emit(state.copyWith(actionInProgress: true, error: null));
    final result = await _repository.updateCategory(category);
    result.fold(
      (failure) =>
          emit(state.copyWith(actionInProgress: false, error: failure.message)),
      (updatedCategory) {
        final updatedList = state.categories
            .map(
              (item) => item.id == updatedCategory.id ? updatedCategory : item,
            )
            .toList();
        emit(
          state.copyWith(
            actionInProgress: false,
            categories: updatedList,
            error: null,
          ),
        );
      },
    );
  }

  Future<void> deleteCategory(String id) async {
    emit(state.copyWith(actionInProgress: true, error: null));
    final result = await _repository.deleteCategory(id);
    result.fold(
      (failure) =>
          emit(state.copyWith(actionInProgress: false, error: failure.message)),
      (_) {
        final remaining = state.categories
            .where((item) => item.id != id)
            .toList();
        emit(
          state.copyWith(
            actionInProgress: false,
            categories: remaining,
            error: null,
          ),
        );
      },
    );
  }

  Future<String> uploadImage(String categoryId, List<int> bytes) async {
    final data = Uint8List.fromList(bytes);
    return _storageService.uploadProductImage(categoryId, data);
  }
}
