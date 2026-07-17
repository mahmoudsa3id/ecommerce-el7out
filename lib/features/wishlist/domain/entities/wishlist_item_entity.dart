// features/wishlist/domain/entities/wishlist_item_entity.dart
import 'package:equatable/equatable.dart';

class WishlistItemEntity extends Equatable {
  final String productId;
  final String name;
  final String brand;
  final double price;
  final String? imageUrl;
  final DateTime addedAt;

  const WishlistItemEntity({
    required this.productId,
    required this.name,
    required this.brand,
    required this.price,
    this.imageUrl,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [productId, name, brand, price, imageUrl, addedAt];
}
