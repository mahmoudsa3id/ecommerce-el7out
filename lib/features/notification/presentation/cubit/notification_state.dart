// features/notifications/presentation/cubit/notification_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_state.freezed.dart';

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState.initial() = NotificationInitial;
  const factory NotificationState.loading() = NotificationLoading;
  const factory NotificationState.loaded(
    List<NotificationEntity> notifications,
  ) = NotificationLoaded;
  const factory NotificationState.error(String message) = NotificationError;
}
