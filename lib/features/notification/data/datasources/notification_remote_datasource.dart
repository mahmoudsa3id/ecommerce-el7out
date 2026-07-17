// features/notifications/data/datasources/notification_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_el7out/features/notification/data/model/notification_model.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(String userId);
  Future<void> markAsRead(String userId, String notificationId);
}

@LazySingleton(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;
  NotificationRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      final snap = await firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();
      return snap.docs
          .map((d) => NotificationModel.fromFirestore(d.data(), d.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to load notifications: $e');
    }
  }

  @override
  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      throw ServerException('Failed to mark notification as read: $e');
    }
  }
}
