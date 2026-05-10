// lib/features/notifications/presentation/bloc/notification_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ispm_attendance/core/error/failures.dart';

import '../../domain/entities/app_notification.dart';
import '../../domain/usecases/delete_notification.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_all_notifications_read.dart';
import '../../domain/usecases/mark_notification_as_read.dart';

part 'notification_bloc.freezed.dart';
part 'notification_event.dart';
part 'notification_state.dart';

/// BLoC Notifications — respecte les règles Clean Architecture :
/// - Appelle les UseCases, jamais le Repository directement.
/// - Injecté via get_it (@injectable).
/// - Aucune logique d'affichage.
@injectable
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotifications _getNotifications;
  final MarkNotificationAsRead _markAsRead;
  final MarkAllNotificationsRead _markAllRead;
  final DeleteNotification _deleteNotification;

  NotificationBloc(
    this._getNotifications,
    this._markAsRead,
    this._markAllRead,
    this._deleteNotification,
  ) : super(const NotificationState.initial()) {
    on<_LoadNotifications>(_onLoad);
    on<_MarkAsRead>(_onMarkRead);
    on<_MarkAllRead>(_onMarkAllRead);
    on<_DismissNotification>(_onDismiss);
  }

  // ── Chargement depuis l'API ───────────────────────────────────────────────

  Future<void> _onLoad(
    _LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationState.loading());
    final result = await _getNotifications();
    result.fold(
      (failure) => emit(
        NotificationState.error(
          failure.when(
            server: (msg) => msg,
            network: () => 'Erreur réseau — vérifiez votre connexion.',
            cache: (msg) => msg,
            unauthorized: () => 'Session expirée — reconnectez-vous.',
            forbidden: () => 'Accès refusé.',
            unknown: (msg) => msg,
          ),
        ),
      ),
      (notifications) => emit(NotificationState.loaded(notifications)),
    );
  }

  // ── Marquer une notif lue (optimiste + appel UseCase) ────────────────────

  Future<void> _onMarkRead(
    _MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final current = state;
    final currentNotifs = current.maybeWhen(
      loaded: (n) => n,
      orElse: () => null,
    );
    if (currentNotifs == null) return;

    // 1. Mise à jour optimiste immédiate
    final updated = currentNotifs
        .map(
          (n) => n.id == event.notificationId
              ? n.copyWith(status: NotificationStatus.read)
              : n,
        )
        .toList();
    emit(NotificationState.loaded(updated));

    // 2. Persistance via UseCase (silencieux si erreur réseau)
    await _markAsRead(event.notificationId);
  }

  // ── Tout marquer comme lu ─────────────────────────────────────────────────

  Future<void> _onMarkAllRead(
    _MarkAllRead event,
    Emitter<NotificationState> emit,
  ) async {
    final currentNotifs = state.maybeWhen(loaded: (n) => n, orElse: () => null);
    if (currentNotifs == null) return;

    // 1. Mise à jour optimiste
    final updated = currentNotifs
        .map((n) => n.copyWith(status: NotificationStatus.read))
        .toList();
    emit(NotificationState.loaded(updated));

    // 2. Persistance via UseCase
    await _markAllRead();
  }

  // ── Supprimer une notification (swipe) ────────────────────────────────────

  Future<void> _onDismiss(
    _DismissNotification event,
    Emitter<NotificationState> emit,
  ) async {
    final currentNotifs = state.maybeWhen(loaded: (n) => n, orElse: () => null);
    if (currentNotifs == null) return;

    // 1. Suppression optimiste locale
    final updated = currentNotifs
        .where((n) => n.id != event.notificationId)
        .toList();
    emit(NotificationState.loaded(updated));

    // 2. Suppression serveur via UseCase
    await _deleteNotification(event.notificationId);
  }
}
