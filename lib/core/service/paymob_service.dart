// ============================================================
// core/services/paymob_service.dart
// ============================================================
import 'dart:convert';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';

@lazySingleton
class PayMobService {
  static const _base = AppConstants.paymobBaseUrl;

  // ── Step 1: Auth token ──────────────────────────────────────
  Future<String> authenticate() async {
    final res = await http.post(
      Uri.parse('$_base/auth/tokens'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'api_key': AppConstants.paymobApiKey}),
    );
    _checkStatus(res, 'PayMob auth failed');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['token'] as String;
  }

  // ── Step 2: Register order ──────────────────────────────────
  Future<int> registerOrder({
    required String authToken,
    required double amountCents,
    required List<Map<String, dynamic>> items,
    String currency = 'EGP',
  }) async {
    final res = await http.post(
      Uri.parse('$_base/ecommerce/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({
        'auth_token': authToken,
        'delivery_needed': true,
        'amount_cents': (amountCents * 100).toInt(),
        'currency': currency,
        'items': items,
      }),
    );
    _checkStatus(res, 'PayMob order registration failed');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['id'] as int;
  }

  // ── Step 3: Get payment key ─────────────────────────────────
  Future<String> getPaymentKey({
    required String authToken,
    required int paymobOrderId,
    required double amountCents,
    required int integrationId,
    required AddressEntity billingAddress,
    String currency = 'EGP',
  }) async {
    final res = await http.post(
      Uri.parse('$_base/acceptance/payment_keys'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({
        'auth_token': authToken,
        'amount_cents': (amountCents * 100).toInt(),
        'expiration': 3600,
        'order_id': paymobOrderId,
        'billing_data': {
          'first_name': billingAddress.fullName.split(' ').first,
          'last_name': billingAddress.fullName.split(' ').length > 1
              ? billingAddress.fullName.split(' ').last
              : 'N/A',
          'email': 'order@el7out.com',
          'phone_number': billingAddress.phoneNumber,
          'apartment': 'NA',
          'floor': 'NA',
          'street': billingAddress.addressLine1,
          'building': 'NA',
          'shipping_method': 'PKG',
          'city': billingAddress.city,
          'country': billingAddress.country,
          'state': billingAddress.state,
        },
        'currency': currency,
        'integration_id': integrationId,
        'lock_order_when_paid': true,
      }),
    );
    _checkStatus(res, 'PayMob payment key failed');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['token'] as String;
  }

  // ── Verify HMAC callback ────────────────────────────────────
  bool verifyHmac(Map<String, dynamic> data, String receivedHmac) {
    // In production: verify PayMob HMAC signature
    // using your HMAC secret from env
    return true; // placeholder – implement HMAC-SHA512
  }

  /// Full flow: auth → register order → get payment key
  Future<String> fullPaymentKeyFlow({
    required double amount,
    required AddressEntity billingAddress,
    required List<Map<String, dynamic>> items,
    required int integrationId,
    String currency = 'EGP',
  }) async {
    final token = await authenticate();
    final orderId = await registerOrder(
      authToken: token,
      amountCents: amount,
      items: items,
      currency: currency,
    );
    return getPaymentKey(
      authToken: token,
      paymobOrderId: orderId,
      amountCents: amount,
      integrationId: integrationId,
      billingAddress: billingAddress,
      currency: currency,
    );
  }

  void _checkStatus(http.Response res, String errorMsg) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw ServerException('$errorMsg: ${res.statusCode} ${res.body}');
    }
  }
}
