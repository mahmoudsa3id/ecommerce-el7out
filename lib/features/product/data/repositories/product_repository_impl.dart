// features/product/data/repositories/product_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  ProductRepositoryImpl(this.remoteDataSource, this.networkInfo);

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
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? category,
  }) => _guard(() => remoteDataSource.getProducts(category: category));

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) =>
      _guard(() => remoteDataSource.getProductById(id));

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query) =>
      _guard(() => remoteDataSource.searchProducts(query));

  @override
  Future<Either<Failure, ProductEntity>> addProduct(ProductEntity product) =>
      _guard(
        () => remoteDataSource.addProduct(
          ProductModel(
            id: product.id,
            name: product.name,
            brand: product.brand,
            price: product.price,
            compareAtPrice: product.compareAtPrice,
            imageUrls: product.imageUrls,
            variants: product.variants,
            category: product.category,
            sizes: product.sizes,
            colors: product.colors,
            rating: product.rating,
            reviewCount: product.reviewCount,
            description: product.description,
            isNew: product.isNew,
            inStock: product.inStock,
          ),
        ),
      );

  @override
  Future<Either<Failure, ProductEntity>> updateProduct(ProductEntity product) =>
      _guard(
        () => remoteDataSource.updateProduct(
          ProductModel(
            id: product.id,
            name: product.name,
            brand: product.brand,
            price: product.price,
            compareAtPrice: product.compareAtPrice,
            imageUrls: product.imageUrls,
            variants: product.variants,
            category: product.category,
            sizes: product.sizes,
            colors: product.colors,
            rating: product.rating,
            reviewCount: product.reviewCount,
            description: product.description,
            isNew: product.isNew,
            inStock: product.inStock,
          ),
        ),
      );

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async =>
      _guard(() => remoteDataSource.deleteProduct(id));
}
