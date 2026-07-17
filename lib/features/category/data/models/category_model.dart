// features/category/data/models/category_model.dart

import 'package:ecommerce_el7out/features/category/domain/entity/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.slug,
    required super.name,
    super.imageUrl,
    super.productCount,
    super.description,
    super.order,
  });

  Map<String, dynamic> toFirestore() => {
    'slug': slug,
    'name': name,
    'imageUrl': imageUrl,
    'productCount': productCount,
    'description': description,
    'order': order,
  };

  factory CategoryModel.fromFirestore(Map<String, dynamic> json, String id) =>
      CategoryModel(
        id: id,
        slug: json['slug'] as String? ?? id,
        name: json['name'] as String? ?? '',
        imageUrl: json['imageUrl'] as String?,
        productCount: json['productCount'] as int? ?? 0,
        description: json['description'] as String?,
        order: json['order'] as int? ?? 0,
      );
}
