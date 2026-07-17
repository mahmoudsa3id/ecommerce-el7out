// features/wishlist/data/datasources/wishlist_local_datasource.dart
import 'dart:convert';
import 'package:ecommerce_el7out/features/wishlist/data/model/wishlist_item_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';

abstract class WishlistLocalDataSource {
  Future<List<WishlistItemModel>> getWishlist();
  Future<void> saveWishlist(List<WishlistItemModel> items);
}

@LazySingleton(as: WishlistLocalDataSource)
class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  final SharedPreferences prefs;
  WishlistLocalDataSourceImpl(this.prefs);

  @override
  Future<List<WishlistItemModel>> getWishlist() async {
    try {
      final raw = prefs.getString(AppConstants.prefGuestWishlist);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => WishlistItemModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveWishlist(List<WishlistItemModel> items) async {
    try {
      final encoded = jsonEncode(items.map((i) => i.toMap()).toList());
      await prefs.setString(AppConstants.prefGuestWishlist, encoded);
    } catch (e) {
      throw CacheException('Failed to save wishlist: $e');
    }
  }
}
