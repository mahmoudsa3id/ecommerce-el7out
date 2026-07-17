// features/product/presentation/cubit/product_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'product_state.dart';

@injectable
class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase getProductsUseCase;
  ProductCubit(this.getProductsUseCase) : super(const ProductState.initial());

  Future<void> loadProducts({String? category}) async {
    emit(const ProductState.loading());
    final result = await getProductsUseCase(
      GetProductsParams(category: category),
    );
    result.fold(
      (failure) => emit(ProductState.error(failure.message)),
      (products) => emit(ProductState.loaded(products)),
    );
  }
}
