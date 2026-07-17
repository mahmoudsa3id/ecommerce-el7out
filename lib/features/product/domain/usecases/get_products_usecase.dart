// features/product/domain/usecases/get_products_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

@injectable
class GetProductsUseCase
    implements UseCase<List<ProductEntity>, GetProductsParams> {
  final ProductRepository repository;
  const GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(GetProductsParams params) {
    return repository.getProducts(
      category: params.category,
    );
  }
}

class GetProductsParams extends Equatable {
  final String? category;
  const GetProductsParams({this.category});

  @override
  List<Object?> get props => [category];
}
