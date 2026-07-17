// features/wishlist/data/models/wishlist_item_model.dart
import 'dart:convert';
import '../../domain/entities/wishlist_item_entity.dart';

class WishlistItemModel extends WishlistItemEntity {
  const WishlistItemModel({
    required super.productId,
    required super.name,
    required super.brand,
    required super.price,
    super.imageUrl,
    required super.addedAt,
  });

  factory WishlistItemModel.fromEntity(WishlistItemEntity e) =>
      WishlistItemModel(
        productId: e.productId,
        name: e.name,
        brand: e.brand,
        price: e.price,
        imageUrl: e.imageUrl,
        addedAt: e.addedAt,
      );

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'name': name,
    'brand': brand,
    'price': price,
    'imageUrl': imageUrl,
    'addedAt': addedAt.millisecondsSinceEpoch,
  };

  factory WishlistItemModel.fromMap(Map<String, dynamic> m) =>
      WishlistItemModel(
        productId: m['productId'] as String,
        name: m['name'] as String? ?? '',
        brand: m['brand'] as String? ?? '',
        price: (m['price'] as num?)?.toDouble() ?? 0,
        imageUrl: m['imageUrl'] as String?,
        addedAt: m['addedAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(m['addedAt'] as int)
            : DateTime.now(),
      );

  String toJson() => jsonEncode(toMap());
  factory WishlistItemModel.fromJson(String source) =>
      WishlistItemModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
