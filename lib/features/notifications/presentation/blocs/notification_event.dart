// lib/features/notifications/presentation/bloc/notification_event.dart

part of 'notification_bloc.dart';

@freezed
class NotificationEvent with _$NotificationEvent {
  const factory NotificationEvent.loadNotifications() = _LoadNotifications;
  const factory NotificationEvent.markAsRead(String notificationId) = _MarkAsRead;
  const factory NotificationEvent.markAllRead() = _MarkAllRead;
  const factory NotificationEvent.dismissNotification(String notificationId) = _DismissNotification;
}
