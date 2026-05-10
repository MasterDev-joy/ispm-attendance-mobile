// lib/features/notifications/presentation/bloc/notification_state.dart

part of 'notification_bloc.dart';

@freezed
class NotificationState with _$NotificationState {
  const NotificationState._();

  const factory NotificationState.initial() = _Initial;
  const factory NotificationState.loading() = _Loading;
  const factory NotificationState.loaded(
    List<AppNotification> notifications,
  ) = _Loaded;
  const factory NotificationState.error(String message) = _Error;

  // ── Helpers métier sur l'état loaded ──────────────────────────────────────

  List<AppNotification> get unread => maybeWhen(
        loaded: (notifs) =>
            notifs.where((n) => n.status == NotificationStatus.unread).toList(),
        orElse: () => [],
      );

  List<AppNotification> get readOrArchived => maybeWhen(
        loaded: (notifs) =>
            notifs.where((n) => n.status != NotificationStatus.unread).toList(),
        orElse: () => [],
      );

  int get unreadCount => unread.length;
}
