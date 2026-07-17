// features/category/data/datasources/category_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> getCategoryById(String id);
  Future<CategoryModel> addCategory(CategoryModel category);
  Future<CategoryModel> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
}

@LazySingleton(as: CategoryRemoteDataSource)
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore firestore;
  CategoryRemoteDataSourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _categories =>
      firestore.collection('categories');

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snap = await _categories.orderBy('order').get();
      return snap.docs
          .map((d) => CategoryModel.fromFirestore(d.data(), d.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to load categories: $e');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final doc = await _categories.doc(id).get();
      if (!doc.exists) {
        throw const ServerException('Category not found.');
      }
      return CategoryModel.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      throw ServerException('Failed to load category: $e');
    }
  }

  @override
  Future<CategoryModel> addCategory(CategoryModel category) async {
    try {
      final ref = category.id.isEmpty
          ? _categories.doc()
          : _categories.doc(category.id);
      await ref.set(category.toFirestore());
      final snapshot = await ref.get();
      return CategoryModel.fromFirestore(snapshot.data()!, snapshot.id);
    } catch (e) {
      throw ServerException('Failed to add category: $e');
    }
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    try {
      if (category.id.isEmpty) {
        throw const ServerException('Category id is required for update.');
      }
      final ref = _categories.doc(category.id);
      await ref.set(category.toFirestore());
      final snapshot = await ref.get();
      return CategoryModel.fromFirestore(snapshot.data()!, snapshot.id);
    } catch (e) {
      throw ServerException('Failed to update category: $e');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _categories.doc(id).delete();
    } catch (e) {
      throw ServerException('Failed to delete category: $e');
    }
  }
}
