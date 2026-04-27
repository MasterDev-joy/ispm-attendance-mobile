// lib/features/notifications/presentation/blocs/notification_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/app_notification.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<AppNotification> notifications;

  const NotificationLoaded(this.notifications);

  List<AppNotification> get unread =>
      notifications.where((n) => n.status == NotificationStatus.unread).toList();

  List<AppNotification> get readOrArchived =>
      notifications.where((n) => n.status != NotificationStatus.unread).toList();

  int get unreadCount => unread.length;

  @override
  List<Object?> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
  @override
  List<Object?> get props => [message];
}
