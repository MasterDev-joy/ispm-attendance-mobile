// lib/features/notifications/data/models/notification_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/app_notification.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// DTO (Data Transfer Object) — contient toute la logique de sérialisation JSON.
/// Séparé de l'entité pour respecter la règle domain/data.
@freezed
abstract class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    required String id,
    required String title,
    required String body,
    String? courseId,
    @JsonKey(defaultValue: 'Sans cours') required String courseTitle,
    required String createdAt,
    @JsonKey(name: 'isRead', defaultValue: false) required bool isRead,
    String? type,
    String? invigilatorName,
    String? scanTime,
    String? announcementId,
    @JsonKey(name: 'announcement') Map<String, dynamic>? announcementData,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  /// Convertit le DTO en entité métier pure.
  AppNotification toEntity() {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      courseId: courseId,
      courseTitle: courseTitle,
      createdAt: DateTime.parse(createdAt),
      status: isRead ? NotificationStatus.read : NotificationStatus.unread,
      type: _parseType(type),
      invigilatorName: invigilatorName,
      scanTime: scanTime != null ? DateTime.parse(scanTime!) : null,
      announcementId: announcementId,
      meetingDate: announcementData?['meetingDate'] != null
          ? DateTime.parse(announcementData!['meetingDate'] as String)
          : null,
      meetingLocation: announcementData?['meetingLocation'] as String?,
    );
  }

  static NotificationType _parseType(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'SCAN_CONFIRMED':
        return NotificationType.scanConfirmed;
      case 'SESSION_MISSED':
        return NotificationType.sessionMissed;
      case 'COURSE_REMINDER':
        return NotificationType.courseReminder;
      case 'QR_EXPIRED':
        return NotificationType.qrExpired;
      case 'ANNOUNCEMENT':
        return NotificationType.announcement;
      default:
        return NotificationType.scanConfirmed;
    }
  }
}
