// features/product/data/datasources/product_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({String? category});
  Future<ProductModel> getProductById(String id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<ProductModel> addProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

@LazySingleton(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;
  ProductRemoteDataSourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _products =>
      firestore.collection('products');

  @override
  Future<List<ProductModel>> getProducts({String? category}) async {
    try {
      Query<Map<String, dynamic>> query = _products;
      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }
      final snapshot = await query.get();
      return snapshot.docs
          .map((d) => ProductModel.fromFirestore(d.data(), d.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to load products: $e');
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final doc = await _products.doc(id).get();
      if (!doc.exists) {
        throw const ServerException('Product not found.');
      }
      return ProductModel.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      throw ServerException('Failed to load product: $e');
    }
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    try {
      final ref = product.id.isEmpty
          ? _products.doc()
          : _products.doc(product.id);
      await ref.set(product.toFirestore());
      final snapshot = await ref.get();
      return ProductModel.fromFirestore(snapshot.data()!, snapshot.id);
    } catch (e) {
      throw ServerException('Failed to add product: $e');
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      if (product.id.isEmpty) {
        throw const ServerException('Product id is required for update.');
      }
      final ref = _products.doc(product.id);
      await ref.set(product.toFirestore());
      final snapshot = await ref.get();
      return ProductModel.fromFirestore(snapshot.data()!, snapshot.id);
    } catch (e) {
      throw ServerException('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _products.doc(id).delete();
    } catch (e) {
      throw ServerException('Failed to delete product: $e');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final lower = query.toLowerCase();
      final snapshot = await _products
          .orderBy('name')
          .startAt([lower])
          .endAt(['$lower\uf8ff'])
          .limit(30)
          .get();
      return snapshot.docs
          .map((d) => ProductModel.fromFirestore(d.data(), d.id))
          .toList();
    } catch (e) {
      throw ServerException('Search failed: $e');
    }
  }
}
