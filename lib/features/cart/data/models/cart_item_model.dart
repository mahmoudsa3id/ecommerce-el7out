// features/cart/data/models/cart_item_model.dart
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  CartItemModel({
    required super.id,
    required super.productId,
    required super.name,
    required super.brand,
    required super.price,
    super.imageUrl,
    required super.selectedSize,
    required super.selectedColor,
    super.quantity,
  });

  factory CartItemModel.fromEntity(CartItemEntity e) => CartItemModel(
    id: e.id,
    productId: e.productId,
    name: e.name,
    brand: e.brand,
    price: e.price,
    imageUrl: e.imageUrl,
    selectedSize: e.selectedSize,
    selectedColor: e.selectedColor,
    quantity: e.quantity,
  );

  factory CartItemModel.create({
    required String productId,
    required String name,
    required String brand,
    required double price,
    String? imageUrl,
    required String selectedSize,
    required String selectedColor,
  }) => CartItemModel(
    id: const Uuid().v4(),
    productId: productId,
    name: name,
    brand: brand,
    price: price,
    imageUrl: imageUrl,
    selectedSize: selectedSize,
    selectedColor: selectedColor,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'productId': productId,
    'name': name,
    'brand': brand,
    'price': price,
    'imageUrl': imageUrl,
    'selectedSize': selectedSize,
    'selectedColor': selectedColor,
    'quantity': quantity,
  };

  factory CartItemModel.fromMap(Map<String, dynamic> m) => CartItemModel(
    id: m['id'] as String? ?? const Uuid().v4(),
    productId: m['productId'] as String,
    name: m['name'] as String? ?? '',
    brand: m['brand'] as String? ?? '',
    price: (m['price'] as num?)?.toDouble() ?? 0,
    imageUrl: m['imageUrl'] as String?,
    selectedSize: m['selectedSize'] as String? ?? '',
    selectedColor: m['selectedColor'] as String? ?? '',
    quantity: m['quantity'] as int? ?? 1,
  );
}
