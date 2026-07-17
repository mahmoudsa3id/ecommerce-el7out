// ============================================================
// features/order/domain/entities/order_entity.dart  (EXTENDED)
// Add paymentType field – backward compatible
// ============================================================
import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

enum PaymentStatus {
  pending,
  waitingVerification,
  verified,
  paid,
  partiallyPaid,
  failed,
  refunded,
  approved,
  rejected,
}

enum PaymentType { partial, full }

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final CustomerInfoEntity customer;
  final List<OrderItemEntity> items;
  final OrderPricingEntity pricing;
  final OrderStatus status;
  final PaymentInfoEntity payment;
  final AddressEntity shippingAddress;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;
  final List<OrderStatusHistoryEntity> statusHistory;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.customer,
    required this.items,
    required this.pricing,
    required this.status,
    required this.payment,
    required this.shippingAddress,
    required this.createdAt,
    this.updatedAt,
    this.notes,
    this.statusHistory = const [],
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  List<Object?> get props => [id, userId, items, status, payment, createdAt];
}

class CustomerInfoEntity extends Equatable {
  final String fullName;
  final String email;
  final String phoneNumber;
  const CustomerInfoEntity({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });
  @override
  List<Object?> get props => [fullName, email, phoneNumber];
}

class OrderItemEntity extends Equatable {
  final String productId;
  final String productName;
  final String brand;
  final String? productImageUrl;
  final String selectedColor;
  final String selectedSize;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  const OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.brand,
    this.productImageUrl,
    required this.selectedColor,
    required this.selectedSize,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });
  @override
  List<Object?> get props => [productId, selectedColor, selectedSize, quantity];
}

class OrderPricingEntity extends Equatable {
  final double subtotal;
  final double discount;
  final double shipping;
  final double taxes;
  final double total;
  const OrderPricingEntity({
    required this.subtotal,
    this.discount = 0,
    required this.shipping,
    this.taxes = 0,
    required this.total,
  });
  @override
  List<Object?> get props => [subtotal, discount, shipping, taxes, total];
}

class PaymentInfoEntity extends Equatable {
  final String method;
  final PaymentType paymentType; // ← NEW
  final PaymentStatus status;
  final double totalAmount;
  final double paidAmount;
  final double pendingAmount;
  final String? transactionId;
  final String? proofImageUrl;
  final String? proofImageStoragePath;
  final DateTime? paidAt;
  final String? adminNote; // ← NEW (approve/reject note)

  const PaymentInfoEntity({
    required this.method,
    this.paymentType = PaymentType.partial,
    required this.status,
    required this.totalAmount,
    required this.paidAmount,
    this.pendingAmount = 0,
    this.transactionId,
    this.proofImageUrl,
    this.proofImageStoragePath,
    this.paidAt,
    this.adminNote,
  });

  bool get isVerified =>
      status == PaymentStatus.verified ||
      status == PaymentStatus.paid ||
      status == PaymentStatus.partiallyPaid ||
      status == PaymentStatus.approved;

  bool get isPartial => paymentType == PaymentType.partial;
  bool get isFull => paymentType == PaymentType.full;

  String get paymentTypeLabel =>
      paymentType == PaymentType.partial ? 'Partial (30%)' : 'Full (100%)';

  String get statusLabel {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.waitingVerification:
        return 'Awaiting Verification';
      case PaymentStatus.verified:
        return 'Verified';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.partiallyPaid:
        return 'Partially Paid';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.approved:
        return 'Approved ✓';
      case PaymentStatus.rejected:
        return 'Rejected ✗';
    }
  }

  @override
  List<Object?> get props => [
    method,
    paymentType,
    status,
    totalAmount,
    paidAmount,
    proofImageUrl,
  ];
}

class AddressEntity extends Equatable {
  final String fullName;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String country;
  final String phoneNumber;
  const AddressEntity({
    required this.fullName,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.country,
    required this.phoneNumber,
  });
  String get formatted =>
      '$addressLine1${addressLine2 != null ? ', $addressLine2' : ''}, '
      '$city, $state , $country';
  @override
  List<Object?> get props => [
    fullName,
    addressLine1,
    city,
    state,
    country,
    phoneNumber,
  ];
}

class OrderStatusHistoryEntity extends Equatable {
  final OrderStatus status;
  final DateTime timestamp;
  final String? note;
  const OrderStatusHistoryEntity({
    required this.status,
    required this.timestamp,
    this.note,
  });
  @override
  List<Object?> get props => [status, timestamp];
}
