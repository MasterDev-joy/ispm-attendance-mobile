// lib/features/notifications/domain/entities/app_notification.dart

enum NotificationType {
  scanConfirmed,   // QR scanné avec succès par un surveillant
  sessionMissed,   // Cours passé sans scan enregistré
  courseReminder,  // Rappel avant un cours (15 min avant)
  qrExpired,       // QR expiré sans scan
}

enum NotificationStatus { unread, read, archived }

class AppNotification {
  final String id;
  final NotificationType type;
  final NotificationStatus status;
  final String title;
  final String body;
  final String courseTitle;
  final String? courseId;
  final DateTime createdAt;

  /// Pour scanConfirmed : nom du surveillant
  final String? invigilatorName;

  /// Pour scanConfirmed : heure du scan
  final DateTime? scanTime;

  const AppNotification({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.body,
    required this.courseTitle,
    required this.createdAt,
    this.courseId,
    this.invigilatorName,
    this.scanTime,
  });

  AppNotification copyWith({NotificationStatus? status}) {
    return AppNotification(
      id: id,
      type: type,
      status: status ?? this.status,
      title: title,
      body: body,
      courseTitle: courseTitle,
      createdAt: createdAt,
      courseId: courseId,
      invigilatorName: invigilatorName,
      scanTime: scanTime,
    );
  }
}
