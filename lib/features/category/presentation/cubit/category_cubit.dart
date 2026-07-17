// features/category/presentation/cubit/category_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:ecommerce_el7out/features/category/domain/usecase/get_category_usecase.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecase/usecase.dart';
import 'category_state.dart';

@injectable
class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUseCase _getCategories;
  CategoryCubit(this._getCategories) : super(const CategoryState.initial());

  Future<void> load() async {
    emit(const CategoryState.loading());
    final result = await _getCategories(const NoParams());
    result.fold(
      (f) => emit(CategoryState.error(f.message)),
      (cats) => emit(CategoryState.loaded(cats)),
    );
  }
}
