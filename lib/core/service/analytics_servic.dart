// core/services/analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AnalyticsService {
  final FirebaseAnalytics _analytics;
  AnalyticsService(this._analytics);

  Future<void> logViewProduct(String productId, String name, double price) =>
      _analytics.logViewItem(
        items: [
          AnalyticsEventItem(itemId: productId, itemName: name, price: price),
        ],
      );

  Future<void> logAddToCart(
    String productId,
    String name,
    double price,
    int quantity,
  ) => _analytics.logAddToCart(
    items: [
      AnalyticsEventItem(itemId: productId, itemName: name, price: price),
    ],
    value: price * quantity,
    currency: 'EGP',
  );

  Future<void> logAddToWishlist(String productId, String name, double price) =>
      _analytics.logAddToWishlist(
        items: [
          AnalyticsEventItem(itemId: productId, itemName: name, price: price),
        ],
      );

  Future<void> logSearch(String query) =>
      _analytics.logSearch(searchTerm: query);

  Future<void> logBeginCheckout(double totalValue) =>
      _analytics.logBeginCheckout(value: totalValue, currency: 'USD');

  Future<void> logPurchase({
    required String orderId,
    required double value,
    required List<Map<String, dynamic>> items,
  }) => _analytics.logPurchase(
    transactionId: orderId,
    value: value,
    currency: 'EGP',
    items: items
        .map(
          (i) => AnalyticsEventItem(
            itemId: i['id'] as String,
            itemName: i['name'] as String,
            price: (i['price'] as num).toDouble(),
            quantity: i['quantity'] as int,
          ),
        )
        .toList(),
  );

  Future<void> logScreenView(String name) =>
      _analytics.logScreenView(screenName: name);
}
