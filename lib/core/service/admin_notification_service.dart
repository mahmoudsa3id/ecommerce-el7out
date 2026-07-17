// ============================================================
// core/service/admin_notification_service.dart
// ============================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AdminNotificationService {
  final FirebaseFirestore _firestore;
  AdminNotificationService(this._firestore);

  Future<void> notifyNewOrder({
    required String orderId,
    required String customerName,
    required double total,
    required String paymentMethod,
    required String paymentStatus,
    String? proofImageUrl,
    required int itemCount,
  }) async {
    try {
      await _firestore.collection('admin_notifications').add({
        'type': 'new_order',
        'orderId': orderId,
        'customerName': customerName,
        'total': total,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'proofImageUrl': proofImageUrl,
        'itemCount': itemCount,
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });
    } catch (_) {
      // Non-critical – log only
    }
  }

  Future<void> updateNotificationRead(String notifId) async {
    await _firestore.collection('admin_notifications').doc(notifId).update({
      'read': true,
    });
  }
}
