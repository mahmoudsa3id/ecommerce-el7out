// features/product/domain/entities/product_entity.dart
import 'package:equatable/equatable.dart';

class VariantSizeStockEntity extends Equatable {
  final String size;
  final int stock;

  const VariantSizeStockEntity({required this.size, required this.stock});

  bool get inStock => stock > 0;

  @override
  List<Object?> get props => [size, stock];
}

class ProductVariantEntity extends Equatable {
  final String colorName;
  final String colorHex;
  final List<String> imageUrls;
  final List<VariantSizeStockEntity> sizes;

  const ProductVariantEntity({
    required this.colorName,
    required this.colorHex,
    required this.imageUrls,
    required this.sizes,
  });

  bool get inStock => sizes.any((size) => size.inStock);

  @override
  List<Object?> get props => [colorName, colorHex, imageUrls, sizes];
}

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double? compareAtPrice;
  final List<String> imageUrls;
  final List<ProductVariantEntity> variants;
  final String category;
  final List<String> sizes;
  final List<String> colors;
  final double rating;
  final int reviewCount;
  final String description;
  final bool isNew;
  final bool inStock;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.compareAtPrice,
    required this.imageUrls,
    this.variants = const [],
    required this.category,
    required this.sizes,
    required this.colors,
    required this.rating,
    required this.reviewCount,
    required this.description,
    this.isNew = false,
    this.inStock = true,
  });

  bool get isOnSale => compareAtPrice != null && compareAtPrice! > price;

  double get discountPercent =>
      isOnSale ? (((compareAtPrice! - price) / compareAtPrice!) * 100) : 0;

  ProductVariantEntity? variantForColor(String? color) {
    if (color == null) return variants.isNotEmpty ? variants.first : null;
    for (final variant in variants) {
      if (variant.colorName == color) return variant;
    }
    return variants.isNotEmpty ? variants.first : null;
  }

  List<String> imagesForColor(String? color) {
    final variant = variantForColor(color);
    if (variant != null && variant.imageUrls.isNotEmpty) {
      return List<String>.of(variant.imageUrls);
    }
    return List<String>.of(imageUrls);
  }

  List<VariantSizeStockEntity> sizeStocksForColor(String? color) {
    final variant = variantForColor(color);
    if (variant != null) {
      return List<VariantSizeStockEntity>.of(variant.sizes);
    }
    return sizes
        .map(
          (size) => VariantSizeStockEntity(size: size, stock: inStock ? 1 : 0),
        )
        .toList();
  }

  @override
  List<Object?> get props => [
    id,
    name,
    brand,
    price,
    compareAtPrice,
    imageUrls,
    variants,
    category,
    sizes,
    colors,
    rating,
    reviewCount,
    description,
    isNew,
    inStock,
  ];
}
