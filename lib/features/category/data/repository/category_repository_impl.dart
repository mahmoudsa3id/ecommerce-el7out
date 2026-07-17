// features/category/data/repositories/category_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:ecommerce_el7out/features/category/data/datasources/category_remote_data_source.dart';
import 'package:ecommerce_el7out/features/category/data/models/category_model.dart';
import 'package:ecommerce_el7out/features/category/domain/entity/category_entity.dart';
import 'package:ecommerce_el7out/features/category/domain/repository/category_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remote;
  final NetworkInfo networkInfo;
  CategoryRepositoryImpl(this.remote, this.networkInfo);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await action());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async =>
      _guard(() => remote.getCategories());

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id) async =>
      _guard(() => remote.getCategoryById(id));

  @override
  Future<Either<Failure, CategoryEntity>> addCategory(
    CategoryEntity category,
  ) async => _guard(
    () => remote.addCategory(
      CategoryModel(
        id: category.id,
        slug: category.slug,
        name: category.name,
        imageUrl: category.imageUrl,
        productCount: category.productCount,
        description: category.description,
      ),
    ),
  );

  @override
  Future<Either<Failure, CategoryEntity>> updateCategory(
    CategoryEntity category,
  ) async => _guard(
    () => remote.updateCategory(
      CategoryModel(
        id: category.id,
        slug: category.slug,
        name: category.name,
        imageUrl: category.imageUrl,
        productCount: category.productCount,
        description: category.description,
      ),
    ),
  );

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async =>
      _guard(() => remote.deleteCategory(id));
}
