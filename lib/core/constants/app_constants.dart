// ============================================================
// FILE STRUCTURE – NEW FILES ADDED THIS RESPONSE
// ============================================================
// core/services/paymob_service.dart
// core/services/image_picker_service.dart
// features/payment/domain/entities/payment_entity.dart
// features/payment/domain/entities/payment_method_entity.dart
// features/payment/domain/repositories/payment_repository.dart
// features/payment/domain/usecases/initiate_paymob_usecase.dart
// features/payment/data/models/payment_model.dart
// features/payment/data/datasources/payment_remote_datasource.dart
// features/payment/data/repositories/payment_repository_impl.dart
// features/payment/presentation/cubit/payment_cubit.dart
// features/payment/presentation/cubit/payment_state.dart
// features/payment/presentation/pages/payment_selection_page.dart
// features/payment/presentation/pages/cash_transfer_page.dart
// features/payment/presentation/pages/card_payment_page.dart
// features/payment/presentation/pages/paymob_wallet_page.dart
// features/payment/presentation/widgets/payment_proof_uploader.dart
// features/checkout/presentation/pages/checkout_page.dart  [REPLACE]
// features/product/presentation/widgets/product_3d_viewer.dart
// features/product/presentation/pages/product_details_page.dart [REPLACE]
// features/home/presentation/pages/home_page.dart [REPLACE]
// features/admin/presentation/pages/admin_orders_page.dart
// core/services/admin_notification_service.dart
// ============================================================

// ============================================================
// core/constants/app_constants.dart  (EXTENDED)
// ============================================================
abstract class AppConstants {
  // App
  static const String appName = 'EL7OUT';

  // Supabase
  static const String supabaseBucketProducts = 'product-images';
  static const String supabaseBucketAvatars = 'avatars';
  static const String supabaseBucketPaymentProofs = 'payment-proofs';

  // Firestore
  static const String firestoreProducts = 'products';
  static const String firestoreUsers = 'users';
  static const String firestoreOrders = 'orders';
  static const String firestoreWishlist = 'wishlist';
  static const String firestoreCart = 'cart';
  static const String firestoreNotifications = 'notifications';
  static const String firestoreCategories = 'categories';
  static const String firestorePayments = 'payments';

  // SharedPreferences
  static const String prefSeenOnboarding = 'seen_onboarding';
  static const String prefGuestCart = 'guest_cart';
  static const String prefGuestWishlist = 'guest_wishlist';
  static const String prefThemeMode = 'theme_mode';
  static const String prefLanguage = 'language';
  static const String prefCurrency = 'currency';

  // Remote Config
  static const String remoteConfigSaleEnabled = 'sale_enabled';
  static const String remoteConfigFreeShippingThreshold =
      'free_shipping_threshold';
  static const String remoteConfigFeaturedCategory = 'featured_category';

  // PayMob
  static const String paymobBaseUrl = 'https://accept.paymob.com/api';
  static const String paymobApiKey = String.fromEnvironment(
    'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRFNU5UY3dNaXdpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS5MSmdIU1U0MzhvRXhva0ZWUnpIUGZEc0psYUxBQmxCaUE0VFhuc3JLSktOYk5EY0NkbXp2X2ZqLWphSTJfRVJ0c2NIU21ycXd1TnJzYjcwdFhrX2llQQ==',
  );
  static const int paymobCardIntegrationId = int.fromEnvironment(
    'PAYMOB_CARD_INTEGRATION_ID',
  );
  static const int paymobWalletIntegrationId = int.fromEnvironment(
    'PAYMOB_WALLET_INTEGRATION_ID',
  );
  static const int paymobIframeId = int.fromEnvironment('PAYMOB_IFRAME_ID');

  // Business – Cash Transfer
  static const String instapayNumber = String.fromEnvironment(
    'INSTAPAY_NUMBER',
    defaultValue: '01011443351',
  );
  static const String cashNumber = String.fromEnvironment(
    'CASH_NUMBER',
    defaultValue: '01288723293',
  );
  static const String bankAccountName = 'EL7OUT FASHION LLC';

  // Partial payment split ratio (30% upfront, 70% on delivery)
  static const double partialUpfrontRatio = 0.30;
  static const double partialOnDeliveryRatio = 0.70;

  // Analytics
  static const String analyticsAddToCart = 'add_to_cart';
  static const String analyticsViewProduct = 'view_item';
  static const String analyticsPurchase = 'purchase';
  static const String analyticsSearch = 'search';
  static const String analyticsAddToWishlist = 'add_to_wishlist';
  static const String analyticsBeginCheckout = 'begin_checkout';

  // Admin FCM topic
  static const String adminOrdersTopic = 'admin_orders';
}
