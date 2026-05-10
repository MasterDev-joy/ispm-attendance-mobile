// lib/features/notifications/presentation/widgets/notif_card.dart

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/app_notification.dart';

const _kBlue = Color(0xFF378ADD);

class NotifCard extends StatelessWidget {
  final AppNotification notification;
  final Color accent;
  final String Function(DateTime) formatLabel;
  final String Function(DateTime) formatTime;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  const NotifCard({
    super.key,
    required this.notification,
    required this.accent,
    required this.formatLabel,
    required this.formatTime,
    required this.onTap,
    required this.onDismiss,
  });

  bool get _isUnread => notification.status == NotificationStatus.unread;

  Color get _typeColor => switch (notification.type) {
    NotificationType.scanConfirmed  => ISPMColors.green,
    NotificationType.sessionMissed  => ISPMColors.error,
    NotificationType.courseReminder => const Color(0xFFF57C00),
    NotificationType.qrExpired      => ISPMColors.grey400,
    NotificationType.announcement   => _kBlue,
  };

  IconData get _typeIcon => switch (notification.type) {
    NotificationType.scanConfirmed  => Icons.check_circle_rounded,
    NotificationType.sessionMissed  => Icons.event_busy_rounded,
    NotificationType.courseReminder => Icons.alarm_rounded,
    NotificationType.qrExpired      => Icons.qr_code_2_rounded,
    NotificationType.announcement   => Icons.campaign_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final color = _typeColor;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: ISPMColors.error.withOpacity(0.20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ISPMColors.error.withOpacity(0.30)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded, color: ISPMColors.error, size: 20),
            SizedBox(width: 6),
            Text('Supprimer',
                style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 12,
                    fontWeight: FontWeight.w600, color: ISPMColors.error)),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _isUnread ? color.withOpacity(0.07) : ISPMColors.grey900,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isUnread
                  ? color.withOpacity(0.35)
                  : ISPMColors.white.withOpacity(0.06),
              width: _isUnread ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône type
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.25)),
                ),
                child: Icon(_typeIcon, color: color, size: 19),
              ),
              const SizedBox(width: 12),

              // Contenu
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Text(notification.title,
                        style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 13,
                          fontWeight: _isUnread
                              ? FontWeight.w700 : FontWeight.w500,
                          color: ISPMColors.white.withOpacity(
                              _isUnread ? 1.0 : 0.65),
                        ))),
                    Text(formatLabel(notification.createdAt),
                        style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 10,
                            color: ISPMColors.white.withOpacity(0.30))),
                  ]),
                  const SizedBox(height: 4),
                  Text(notification.body,
                      style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 12,
                          color: ISPMColors.white.withOpacity(
                              _isUnread ? 0.55 : 0.38),
                          height: 1.45)),
                  const SizedBox(height: 8),
                  _CoursePill(courseTitle: notification.courseTitle, color: color),
                  if (notification.invigilatorName != null) ...[
                    const SizedBox(height: 8),
                    _ScanDetail(
                      invigilator: notification.invigilatorName!,
                      scanTime: notification.scanTime,
                      formatTime: formatTime,
                    ),
                  ],
                ],
              )),
              const SizedBox(width: 8),

              // Point non lu
              if (_isUnread)
                Container(
                  width: 8, height: 8,
                  margin: const EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Pill cours ────────────────────────────────────────────────────────────────

class _CoursePill extends StatelessWidget {
  final String courseTitle;
  final Color color;
  const _CoursePill({required this.courseTitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.20)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.menu_book_rounded, size: 10, color: color),
        const SizedBox(width: 4),
        Flexible(child: Text(courseTitle,
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 10,
                fontWeight: FontWeight.w500, color: color),
            overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}

// ── Détail scan ───────────────────────────────────────────────────────────────

class _ScanDetail extends StatelessWidget {
  final String invigilator;
  final DateTime? scanTime;
  final String Function(DateTime) formatTime;

  const _ScanDetail({
    required this.invigilator,
    required this.formatTime,
    this.scanTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: ISPMColors.green.withOpacity(0.08),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: ISPMColors.green.withOpacity(0.20)),
      ),
      child: Row(children: [
        const Icon(Icons.person_pin_rounded, size: 12, color: ISPMColors.green),
        const SizedBox(width: 5),
        Expanded(child: Text(invigilator,
            style: const TextStyle(
                fontFamily: 'Poppins', fontSize: 11,
                fontWeight: FontWeight.w600, color: ISPMColors.green))),
        if (scanTime != null) ...[
          const Icon(Icons.access_time_rounded, size: 12, color: ISPMColors.green),
          const SizedBox(width: 4),
          Text(formatTime(scanTime!),
              style: const TextStyle(
                  fontFamily: 'Poppins', fontSize: 11,
                  fontWeight: FontWeight.w600, color: ISPMColors.green)),
        ],
      ]),
    );
  }
}
