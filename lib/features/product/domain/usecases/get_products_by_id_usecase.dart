// ============================================================
// features/product/presentation/pages/product_details_page.dart
// GetProductByIdUseCase  (add this file so detail can fetch independently)
// features/product/domain/usecases/get_product_by_id_usecase.dart
// ============================================================
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

@injectable
class GetProductByIdUseCase
    implements UseCase<ProductEntity, GetProductByIdParams> {
  final ProductRepository repository;
  const GetProductByIdUseCase(this.repository);

  @override
  Future<Either<Failure, ProductEntity>> call(GetProductByIdParams params) =>
      repository.getProductById(params.id);
}

class GetProductByIdParams extends Equatable {
  final String id;
  const GetProductByIdParams(this.id);

  @override
  List<Object?> get props => [id];
}
