// ============================================================
// features/payment/domain/entities/pending_order_draft.dart
// ============================================================
import 'package:ecommerce_el7out/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';

class PendingOrderDraft {
  final String userId;
  final String userEmail;
  final List<CartItemEntity> cartItems;
  final AddressEntity shippingAddress;
  final double subtotal;
  final double shipping;
  final double total;
  final PaymentType paymentType; // ← NEW

  const PendingOrderDraft({
    required this.userId,
    required this.userEmail,
    required this.cartItems,
    required this.shippingAddress,
    required this.subtotal,
    required this.shipping,
    required this.total,
    this.paymentType = PaymentType.partial,
  });

  double get upfrontAmount =>
      paymentType == PaymentType.full ? total : total * 0.30;

  double get pendingAmount =>
      paymentType == PaymentType.full ? 0 : total * 0.70;

  OrderPricingEntity get pricing =>
      OrderPricingEntity(subtotal: subtotal, shipping: shipping, total: total);
}
