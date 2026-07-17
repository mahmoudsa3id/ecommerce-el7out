// features/cart/domain/entities/cart_item_entity.dart
import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String id;
  final String productId;
  final String name;
  final String brand;
  final double price;
  final String? imageUrl;
  final String selectedSize;
  final String selectedColor;
  int quantity;

  CartItemEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.brand,
    required this.price,
    this.imageUrl,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });

  double get subtotal => price * quantity;

  CartItemEntity copyWith({int? quantity}) => CartItemEntity(
    id: id,
    productId: productId,
    name: name,
    brand: brand,
    price: price,
    imageUrl: imageUrl,
    selectedSize: selectedSize,
    selectedColor: selectedColor,
    quantity: quantity ?? this.quantity,
  );

  @override
  List<Object?> get props => [
    id,
    productId,
    name,
    brand,
    price,
    selectedSize,
    selectedColor,
    quantity,
  ];
}
