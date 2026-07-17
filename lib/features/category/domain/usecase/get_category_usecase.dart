// features/category/domain/usecases/get_categories_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:ecommerce_el7out/features/category/domain/entity/category_entity.dart';
import 'package:ecommerce_el7out/features/category/domain/repository/category_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

@injectable
class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  final CategoryRepository repository;
  const GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) =>
      repository.getCategories();
}
