// features/category/domain/entities/category_entity.dart
import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String slug;
  final String name;
  final String? imageUrl;
  final int productCount;
  final String? description;
  final int order;

  const CategoryEntity({
    required this.id,
    required this.slug,
    required this.name,
    this.imageUrl,
    this.productCount = 0,
    this.description,
    this.order = 0,
  });

  @override
  List<Object?> get props => [
    id,
    slug,
    name,
    imageUrl,
    productCount,
    description,
    order,
  ];
}
