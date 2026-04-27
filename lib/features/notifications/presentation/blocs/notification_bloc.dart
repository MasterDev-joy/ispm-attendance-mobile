// lib/features/notifications/presentation/blocs/notification_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/app_notification.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc
    extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoad);
    on<MarkAsReadEvent>(_onMarkRead);
    on<MarkAllReadEvent>(_onMarkAllRead);
    on<DismissNotificationEvent>(_onDismiss);
  }

  Future<void> _onLoad(
      LoadNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      // TODO: Remplacer par → GET /api/notifications (endpoint à créer)
      // Chaque notification correspond à un événement Attendance :
      //   - scan enregistré → scanConfirmed
      //   - cours passé sans scan → sessionMissed
      //   - cours dans 15 min → courseReminder
      await Future.delayed(const Duration(milliseconds: 400));
      emit(NotificationLoaded(_mockNotifications()));
    } catch (e) {
      emit(NotificationError('Impossible de charger les notifications : $e'));
    }
  }

  Future<void> _onMarkRead(
      MarkAsReadEvent event, Emitter<NotificationState> emit) async {
    final current = state;
    if (current is! NotificationLoaded) return;
    final updated = current.notifications.map((n) {
      return n.id == event.notificationId
          ? n.copyWith(status: NotificationStatus.read)
          : n;
    }).toList();
    emit(NotificationLoaded(updated));
  }

  Future<void> _onMarkAllRead(
      MarkAllReadEvent event, Emitter<NotificationState> emit) async {
    final current = state;
    if (current is! NotificationLoaded) return;
    final updated = current.notifications
        .map((n) => n.copyWith(status: NotificationStatus.read))
        .toList();
    emit(NotificationLoaded(updated));
  }

  Future<void> _onDismiss(
      DismissNotificationEvent event, Emitter<NotificationState> emit) async {
    final current = state;
    if (current is! NotificationLoaded) return;
    final updated = current.notifications
        .where((n) => n.id != event.notificationId)
        .toList();
    emit(NotificationLoaded(updated));
  }

  List<AppNotification> _mockNotifications() {
    final now = DateTime.now();
    return [
      // Scan confirmé aujourd'hui — non lu
      AppNotification(
        id: 'n1',
        type: NotificationType.scanConfirmed,
        status: NotificationStatus.unread,
        title: 'Présence confirmée',
        body: 'Votre présence au cours d\'Algorithmique a été validée.',
        courseTitle: 'Algorithmique',
        courseId: '1',
        createdAt: now.subtract(const Duration(minutes: 20)),
        invigilatorName: 'Jean Rakoto',
        scanTime: now.subtract(const Duration(minutes: 22)),
      ),
      // Rappel cours — non lu
      AppNotification(
        id: 'n2',
        type: NotificationType.courseReminder,
        status: NotificationStatus.unread,
        title: 'Cours dans 15 minutes',
        body: 'Base de données commence à 14h00. N\'oubliez pas votre QR code.',
        courseTitle: 'Base de données',
        courseId: '2',
        createdAt: now.subtract(const Duration(minutes: 15)),
      ),
      // Séance manquée — non lu
      AppNotification(
        id: 'n3',
        type: NotificationType.sessionMissed,
        status: NotificationStatus.unread,
        title: 'Absence enregistrée',
        body: 'Aucun scan n\'a été enregistré pour le cours de Réseaux du '
            '${_formatDate(now.subtract(const Duration(days: 1)))}.',
        courseTitle: 'Réseaux',
        courseId: '3',
        createdAt: now.subtract(const Duration(hours: 18)),
      ),
      // Historique lu
      AppNotification(
        id: 'n4',
        type: NotificationType.scanConfirmed,
        status: NotificationStatus.read,
        title: 'Présence confirmée',
        body: 'Votre présence au cours de Mathématiques a été validée.',
        courseTitle: 'Mathématiques',
        courseId: '4',
        createdAt: now.subtract(const Duration(days: 2)),
        invigilatorName: 'Marie Rasolofo',
        scanTime: now.subtract(const Duration(days: 2, hours: 1)),
      ),
      AppNotification(
        id: 'n5',
        type: NotificationType.qrExpired,
        status: NotificationStatus.read,
        title: 'QR expiré sans scan',
        body: 'Le QR code du cours d\'Algorithmique du '
            '${_formatDate(now.subtract(const Duration(days: 3)))} a expiré sans validation.',
        courseTitle: 'Algorithmique',
        courseId: '1',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }

  String _formatDate(DateTime d) {
    const months = [
      '', 'jan', 'fév', 'mar', 'avr', 'mai', 'jun',
      'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'
    ];
    return '${d.day} ${months[d.month]}';
  }
}
