import 'package:ecommerce_el7out/features/category/domain/entity/category_entity.dart';

class AdminCategoryState {
  final bool loading;
  final bool actionInProgress;
  final String? error;
  final List<CategoryEntity> categories;

  const AdminCategoryState({
    this.loading = false,
    this.actionInProgress = false,
    this.error,
    this.categories = const [],
  });

  AdminCategoryState copyWith({
    bool? loading,
    bool? actionInProgress,
    String? error,
    List<CategoryEntity>? categories,
  }) {
    return AdminCategoryState(
      loading: loading ?? this.loading,
      actionInProgress: actionInProgress ?? this.actionInProgress,
      error: error,
      categories: categories ?? this.categories,
    );
  }
}
