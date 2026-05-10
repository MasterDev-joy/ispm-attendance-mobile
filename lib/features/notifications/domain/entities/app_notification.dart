// lib/features/notifications/domain/entities/app_notification.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';

enum NotificationType {
  scanConfirmed, // QR scanné avec succès par un surveillant
  sessionMissed, // Cours passé sans scan enregistré
  courseReminder, // Rappel avant un cours (15 min avant)
  qrExpired, // QR expiré sans scan
  announcement, // Annonce admin
}

enum NotificationStatus { unread, read, archived }

/// Entité métier pure — aucun import Flutter, aucun package de sérialisation.
/// Contient uniquement la logique métier (copyWith via freezed).
@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required NotificationType type,
    required NotificationStatus status,
    required String title,
    required String body,
    required String courseTitle,
    required DateTime createdAt,
    String? courseId,

    /// Pour scanConfirmed : nom du surveillant
    String? invigilatorName,

    /// Pour scanConfirmed : heure du scan
    DateTime? scanTime,

    /// Pour announcement : ID de l'annonce
    String? announcementId,

    /// Pour announcement : date de la réunion
    DateTime? meetingDate,

    /// Pour announcement : lieu de la réunion
    String? meetingLocation,
  }) = _AppNotification;
}
