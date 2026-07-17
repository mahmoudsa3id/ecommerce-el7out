// features/cart/data/datasources/cart_local_datasource.dart
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCart();
  Future<void> saveCart(List<CartItemModel> items);
  Future<void> clearCart();
}

@LazySingleton(as: CartLocalDataSource)
class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences prefs;
  CartLocalDataSourceImpl(this.prefs);

  @override
  Future<List<CartItemModel>> getCart() async {
    try {
      final raw = prefs.getString(AppConstants.prefGuestCart);
      if (raw == null || raw.isEmpty) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => CartItemModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveCart(List<CartItemModel> items) async {
    try {
      await prefs.setString(
        AppConstants.prefGuestCart,
        jsonEncode(items.map((i) => i.toMap()).toList()),
      );
    } catch (e) {
      throw CacheException('Failed to save cart: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    await prefs.remove(AppConstants.prefGuestCart);
  }
}
