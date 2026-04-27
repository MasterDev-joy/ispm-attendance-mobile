// lib/features/notifications/presentation/blocs/notification_event.dart
import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {}

class MarkAsReadEvent extends NotificationEvent {
  final String notificationId;
  const MarkAsReadEvent(this.notificationId);
  @override
  List<Object?> get props => [notificationId];
}

class MarkAllReadEvent extends NotificationEvent {}

class DismissNotificationEvent extends NotificationEvent {
  final String notificationId;
  const DismissNotificationEvent(this.notificationId);
  @override
  List<Object?> get props => [notificationId];
}
