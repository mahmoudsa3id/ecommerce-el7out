// features/category/domain/repositories/category_repository.dart
import 'package:dartz/dartz.dart';
import 'package:ecommerce_el7out/features/category/domain/entity/category_entity.dart';
import '../../../../core/error/failures.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id);
  Future<Either<Failure, CategoryEntity>> addCategory(CategoryEntity category);
  Future<Either<Failure, CategoryEntity>> updateCategory(
    CategoryEntity category,
  );
  Future<Either<Failure, void>> deleteCategory(String id);
}
