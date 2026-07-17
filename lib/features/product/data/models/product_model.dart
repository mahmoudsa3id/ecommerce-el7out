// features/product/data/models/product_model.dart
import '../../domain/entities/product_entity.dart';

class VariantSizeStockModel extends VariantSizeStockEntity {
  const VariantSizeStockModel({required super.size, required super.stock});

  factory VariantSizeStockModel.fromEntity(VariantSizeStockEntity entity) {
    return VariantSizeStockModel(size: entity.size, stock: entity.stock);
  }

  factory VariantSizeStockModel.fromFirestore(Map<String, dynamic> json) {
    return VariantSizeStockModel(
      size: json['size'] as String? ?? '',
      stock: (json['stock'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {'size': size, 'stock': stock};
}

class ProductVariantModel extends ProductVariantEntity {
  const ProductVariantModel({
    required super.colorName,
    required super.colorHex,
    required super.imageUrls,
    required super.sizes,
  });

  factory ProductVariantModel.fromEntity(ProductVariantEntity entity) {
    return ProductVariantModel(
      colorName: entity.colorName,
      colorHex: entity.colorHex,
      imageUrls: entity.imageUrls,
      sizes: entity.sizes
          .map(VariantSizeStockModel.fromEntity)
          .toList(growable: false),
    );
  }

  factory ProductVariantModel.fromFirestore(Map<String, dynamic> json) {
    return ProductVariantModel(
      colorName: json['colorName'] as String? ?? '',
      colorHex: json['colorHex'] as String? ?? '#000000',
      imageUrls: List<String>.from(json['imageUrls'] as List? ?? []),
      sizes: (json['sizes'] as List? ?? const [])
          .whereType<Map>()
          .map(
            (size) => VariantSizeStockModel.fromFirestore(
              Map<String, dynamic>.from(size),
            ),
          )
          .where((size) => size.size.isNotEmpty)
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'colorName': colorName,
    'colorHex': colorHex,
    'imageUrls': imageUrls,
    'sizes': sizes
        .map(VariantSizeStockModel.fromEntity)
        .map((size) => size.toFirestore())
        .toList(growable: false),
  };
}

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.brand,
    required super.price,
    super.compareAtPrice,
    required super.imageUrls,
    super.variants,
    required super.category,
    required super.sizes,
    required super.colors,
    required super.rating,
    required super.reviewCount,
    required super.description,
    super.isNew,
    super.inStock,
  });

  factory ProductModel.fromFirestore(Map<String, dynamic> json, String id) {
    final variants = (json['variants'] as List? ?? const [])
        .whereType<Map>()
        .map(
          (variant) => ProductVariantModel.fromFirestore(
            Map<String, dynamic>.from(variant),
          ),
        )
        .where((variant) => variant.colorName.isNotEmpty)
        .toList(growable: false);
    final imageUrls = List<String>.from(json['imageUrls'] as List? ?? []);
    final colors = List<String>.from(json['colors'] as List? ?? []);
    final sizes = List<String>.from(json['sizes'] as List? ?? []);

    return ProductModel(
      id: id,
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      compareAtPrice: (json['compareAtPrice'] as num?)?.toDouble(),
      imageUrls: imageUrls.isNotEmpty
          ? imageUrls
          : variants.expand((variant) => variant.imageUrls).toList(),
      variants: variants,
      category: json['category'] as String? ?? '',
      sizes: sizes.isNotEmpty
          ? sizes
          : variants
                .expand((variant) => variant.sizes.map((size) => size.size))
                .toSet()
                .toList(),
      colors: colors.isNotEmpty
          ? colors
          : variants.map((variant) => variant.colorName).toList(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      isNew: json['isNew'] as bool? ?? false,
      inStock: json['inStock'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'brand': brand,
    'price': price,
    'compareAtPrice': compareAtPrice,
    'imageUrls': imageUrls,
    'variants': variants
        .map(ProductVariantModel.fromEntity)
        .map((variant) => variant.toFirestore())
        .toList(growable: false),
    'category': category,
    'sizes': sizes,
    'colors': colors,
    'rating': rating,
    'reviewCount': reviewCount,
    'description': description,
    'isNew': isNew,
    'inStock': inStock,
  };
}
