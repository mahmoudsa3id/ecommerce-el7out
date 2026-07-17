// ============================================================
// features/order/data/datasources/order_remote_datasource.dart
// FIXED: createOrder now receives FULL data including payment proof
// ============================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_el7out/core/constants/app_constants.dart';
import 'package:ecommerce_el7out/core/error/exceptions.dart';
import 'package:ecommerce_el7out/core/service/admin_notification_service.dart';
import 'package:ecommerce_el7out/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_el7out/features/order/data/model/order_model.dart';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';
import 'package:ecommerce_el7out/features/payment/domain/entities/pending_order_draft.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders(String userId);
  Future<OrderModel> getOrderById(String orderId);

  // Legacy/compat: used by OrderRepositoryImpl.placeOrder
  Future<OrderModel> placeOrder({
    required String userId,
    required List<CartItemEntity> items,
    required AddressEntity address,
    required String paymentMethod,
  });

  /// Called ONLY after payment is confirmed/uploaded.
  Future<OrderModel> createOrderAfterPayment({
    required PendingOrderDraft draft,
    required PaymentInfoEntity paymentInfo,
  });

  Future<void> updateOrderStatus(String orderId, OrderStatus status);
}

@LazySingleton(as: OrderRemoteDataSource)
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore _firestore;
  final AdminNotificationService _adminNotify;

  OrderRemoteDataSourceImpl(this._firestore, this._adminNotify);

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(AppConstants.firestoreOrders);

  @override
  Future<List<OrderModel>> getOrders(String userId) async {
    try {
      final snap = await _col
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snap.docs
          .map((d) => OrderModel.fromFirestore(d.data(), d.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to load orders: $e');
    }
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final doc = await _col.doc(orderId).get();
      if (!doc.exists) throw const ServerException('Order not found.');
      return OrderModel.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      throw ServerException('Failed to load order: $e');
    }
  }

  @override
  Future<OrderModel> placeOrder({
    required String userId,
    required List<CartItemEntity> items,
    required AddressEntity address,
    required String paymentMethod,
  }) async {
    // NOTE: This is a simplified fallback to satisfy compilation.
    // Payment confirmation should use createOrderAfterPayment.
    final draft = PendingOrderDraft(
      userId: userId,
      userEmail: '',
      cartItems: items,
      shippingAddress: address,
      subtotal: items.fold(0.0, (a, e) => a + e.subtotal),
      shipping: 0.0,
      total: items.fold(0.0, (a, e) => a + e.subtotal),
    );

    final paymentInfo = PaymentInfoEntity(
      method: paymentMethod,
      status: PaymentStatus.pending,
      totalAmount: draft.total,
      paidAmount: 0,
      pendingAmount: draft.total,
    );

    return createOrderAfterPayment(draft: draft, paymentInfo: paymentInfo);
  }

  @override
  Future<OrderModel> createOrderAfterPayment({
    required PendingOrderDraft draft,
    required PaymentInfoEntity paymentInfo,
  }) async {
    try {
      final id = const Uuid().v4();
      final now = DateTime.now();

      final items = draft.cartItems
          .map(
            (c) => OrderItemEntity(
              productId: c.productId,
              productName: c.name,
              brand: c.brand,
              productImageUrl: c.imageUrl,
              selectedColor: c.selectedColor,
              selectedSize: c.selectedSize,
              quantity: c.quantity,
              unitPrice: c.price,
              totalPrice: c.subtotal,
            ),
          )
          .toList();

      final model = OrderModel(
        id: id,
        userId: draft.userId,
        customer: CustomerInfoEntity(
          fullName: draft.shippingAddress.fullName,
          email: draft.userEmail,
          phoneNumber: draft.shippingAddress.phoneNumber,
        ),
        items: items,
        pricing: draft.pricing,
        status: OrderStatus.pending,
        payment: paymentInfo,
        shippingAddress: draft.shippingAddress,
        createdAt: now,
        updatedAt: now,
        statusHistory: [
          OrderStatusHistoryEntity(
            status: OrderStatus.pending,
            timestamp: now,
            note: 'Order created after ${paymentInfo.method} payment',
          ),
        ],
      );

      await _col.doc(id).set(model.toFirestore());

      // Notify admin ONLY after order is safely saved
      await _adminNotify.notifyNewOrder(
        orderId: id,
        customerName: draft.shippingAddress.fullName,
        total: draft.total,
        paymentMethod: paymentInfo.method,
        paymentStatus: paymentInfo.status.name,
        proofImageUrl: paymentInfo.proofImageUrl,
        itemCount: items.length,
      );

      return model;
    } catch (e) {
      throw ServerException('Failed to create order: $e');
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _col.doc(orderId).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
        'statusHistory': FieldValue.arrayUnion([
          {
            'status': status.name,
            'timestamp': Timestamp.fromDate(DateTime.now()),
          },
        ]),
      });
    } catch (e) {
      throw ServerException('Failed to update order status: $e');
    }
  }
}
