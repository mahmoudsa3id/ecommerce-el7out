// ============================================================
// features/order/data/model/order_model.dart  (UPDATED)
// Backward-compatible: paymentType defaults to 'partial' when absent
// ============================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.customer,
    required super.items,
    required super.pricing,
    required super.status,
    required super.payment,
    required super.shippingAddress,
    required super.createdAt,
    super.updatedAt,
    super.notes,
    super.statusHistory,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> j, String id) {
    final payMap = j['payment'] as Map<String, dynamic>? ?? {};
    final custMap = j['customer'] as Map<String, dynamic>? ?? {};
    final addrMap = j['shippingAddress'] as Map<String, dynamic>? ?? {};
    final pricMap = j['pricing'] as Map<String, dynamic>? ?? {};

    return OrderModel(
      id: id,
      userId: j['userId'] as String? ?? '',
      customer: CustomerInfoEntity(
        fullName: custMap['fullName'] as String? ?? '',
        email: custMap['email'] as String? ?? '',
        phoneNumber: custMap['phoneNumber'] as String? ?? '',
      ),
      items: ((j['items'] as List?) ?? []).map((e) {
        final m = e as Map<String, dynamic>;
        return OrderItemEntity(
          productId: m['productId'] as String? ?? '',
          productName: m['productName'] as String? ?? '',
          brand: m['brand'] as String? ?? '',
          productImageUrl: m['productImageUrl'] as String?,
          selectedColor: m['selectedColor'] as String? ?? '',
          selectedSize: m['selectedSize'] as String? ?? '',
          quantity: m['quantity'] as int? ?? 1,
          unitPrice: (m['unitPrice'] as num?)?.toDouble() ?? 0,
          totalPrice: (m['totalPrice'] as num?)?.toDouble() ?? 0,
        );
      }).toList(),
      pricing: OrderPricingEntity(
        subtotal: (pricMap['subtotal'] as num?)?.toDouble() ?? 0,
        discount: (pricMap['discount'] as num?)?.toDouble() ?? 0,
        shipping: (pricMap['shipping'] as num?)?.toDouble() ?? 0,
        taxes: (pricMap['taxes'] as num?)?.toDouble() ?? 0,
        total: (pricMap['total'] as num?)?.toDouble() ?? 0,
      ),
      status: _statusFromString(j['status'] as String?),
      payment: PaymentInfoEntity(
        method: payMap['method'] as String? ?? 'cashTransfer',
        // Backward-compatible: old orders had no paymentType → default partial
        paymentType: _payTypeFromString(payMap['paymentType'] as String?),
        status: _payStatusFromString(payMap['status'] as String?),
        totalAmount: (payMap['totalAmount'] as num?)?.toDouble() ?? 0,
        paidAmount: (payMap['paidAmount'] as num?)?.toDouble() ?? 0,
        pendingAmount: (payMap['pendingAmount'] as num?)?.toDouble() ?? 0,
        transactionId: payMap['transactionId'] as String?,
        proofImageUrl: payMap['proofImageUrl'] as String?,
        proofImageStoragePath: payMap['proofImageStoragePath'] as String?,
        paidAt: (payMap['paidAt'] as Timestamp?)?.toDate(),
        adminNote: payMap['adminNote'] as String?,
      ),
      shippingAddress: AddressEntity(
        fullName: addrMap['fullName'] as String? ?? '',
        addressLine1: addrMap['addressLine1'] as String? ?? '',
        addressLine2: addrMap['addressLine2'] as String?,
        city: addrMap['city'] as String? ?? '',
        state: addrMap['state'] as String? ?? '',
        country: addrMap['country'] as String? ?? '',
        phoneNumber: addrMap['phoneNumber'] as String? ?? '',
      ),
      createdAt: (j['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (j['updatedAt'] as Timestamp?)?.toDate(),
      notes: j['notes'] as String?,
      statusHistory: ((j['statusHistory'] as List?) ?? []).map((e) {
        final h = e as Map<String, dynamic>;
        return OrderStatusHistoryEntity(
          status: _statusFromString(h['status'] as String?),
          timestamp: (h['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          note: h['note'] as String?,
        );
      }).toList(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'customer': {
      'fullName': customer.fullName,
      'email': customer.email,
      'phoneNumber': customer.phoneNumber,
    },
    'items': items
        .map(
          (i) => {
            'productId': i.productId,
            'productName': i.productName,
            'brand': i.brand,
            'productImageUrl': i.productImageUrl,
            'selectedColor': i.selectedColor,
            'selectedSize': i.selectedSize,
            'quantity': i.quantity,
            'unitPrice': i.unitPrice,
            'totalPrice': i.totalPrice,
          },
        )
        .toList(),
    'pricing': {
      'subtotal': pricing.subtotal,
      'discount': pricing.discount,
      'shipping': pricing.shipping,
      'taxes': pricing.taxes,
      'total': pricing.total,
    },
    'status': status.name,
    'payment': {
      'method': payment.method,
      'paymentType': payment.paymentType.name,
      'status': payment.status.name,
      'totalAmount': payment.totalAmount,
      'paidAmount': payment.paidAmount,
      'pendingAmount': payment.pendingAmount,
      'transactionId': payment.transactionId,
      'proofImageUrl': payment.proofImageUrl,
      'proofImageStoragePath': payment.proofImageStoragePath,
      'paidAt': payment.paidAt != null
          ? Timestamp.fromDate(payment.paidAt!)
          : null,
      'adminNote': payment.adminNote,
    },
    'shippingAddress': {
      'fullName': shippingAddress.fullName,
      'addressLine1': shippingAddress.addressLine1,
      'addressLine2': shippingAddress.addressLine2,
      'city': shippingAddress.city,
      'state': shippingAddress.state,
      'country': shippingAddress.country,
      'phoneNumber': shippingAddress.phoneNumber,
    },
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    'notes': notes,
    'statusHistory': statusHistory
        .map(
          (h) => {
            'status': h.status.name,
            'timestamp': Timestamp.fromDate(h.timestamp),
            'note': h.note,
          },
        )
        .toList(),
  };

  static OrderStatus _statusFromString(String? s) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == s,
      orElse: () => OrderStatus.pending,
    );
  }

  static PaymentStatus _payStatusFromString(String? s) {
    return PaymentStatus.values.firstWhere(
      (e) => e.name == s,
      orElse: () => PaymentStatus.pending,
    );
  }

  static PaymentType _payTypeFromString(String? s) {
    if (s == 'full') return PaymentType.full;
    return PaymentType.partial; // default for old orders
  }
}
