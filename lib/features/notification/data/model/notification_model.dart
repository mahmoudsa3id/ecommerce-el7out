// features/notifications/data/models/notification_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    super.isRead,
    required super.createdAt,
    super.actionPayload,
  });

  factory NotificationModel.fromFirestore(
    Map<String, dynamic> json,
    String id,
  ) {
    return NotificationModel(
      id: id,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: _typeFromString(json['type'] as String?),
      isRead: json['isRead'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      actionPayload: json['actionPayload'] as String?,
    );
  }

  static NotificationType _typeFromString(String? s) {
    switch (s) {
      case 'order':
        return NotificationType.order;
      case 'promotion':
        return NotificationType.promotion;
      default:
        return NotificationType.system;
    }
  }
}
