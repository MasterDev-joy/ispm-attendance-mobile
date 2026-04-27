// lib/features/notifications/presentation/pages/notifications_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../blocs/notification_bloc.dart';
import '../blocs/notification_event.dart';
import '../blocs/notification_state.dart';
import '../../domain/entities/app_notification.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationBloc()..add(LoadNotificationsEvent()),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F6),
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: ISPMColors.white,
        foregroundColor: ISPMColors.black,
        elevation: 0,
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (ctx, state) {
              if (state is NotificationLoaded && state.unreadCount > 0) {
                return TextButton(
                  onPressed: () =>
                      ctx.read<NotificationBloc>().add(MarkAllReadEvent()),
                  child: const Text(
                    'Tout lire',
                    style: TextStyle(
                        color: ISPMColors.green, fontWeight: FontWeight.w600),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (ctx, state) {
          if (state is NotificationLoading || state is NotificationInitial) {
            return const Center(
                child: CircularProgressIndicator(color: ISPMColors.green));
          }
          if (state is NotificationError) {
            return Center(
              child: Text(state.message,
                  style: const TextStyle(color: ISPMColors.error)),
            );
          }
          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const _EmptyState();
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Non lues ──────────────────────────────────────
                if (state.unread.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Nouvelles',
                    badge: state.unreadCount,
                  ),
                  const SizedBox(height: 8),
                  ...state.unread.map((n) => _NotifCard(
                        notification: n,
                        onTap: () => ctx
                            .read<NotificationBloc>()
                            .add(MarkAsReadEvent(n.id)),
                        onDismiss: () => ctx
                            .read<NotificationBloc>()
                            .add(DismissNotificationEvent(n.id)),
                      )),
                  const SizedBox(height: 16),
                ],

                // ── Historique ─────────────────────────────────────
                if (state.readOrArchived.isNotEmpty) ...[
                  const _SectionHeader(title: 'Historique'),
                  const SizedBox(height: 8),
                  ...state.readOrArchived.map((n) => _NotifCard(
                        notification: n,
                        onTap: null,
                        onDismiss: () => ctx
                            .read<NotificationBloc>()
                            .add(DismissNotificationEvent(n.id)),
                      )),
                ],
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

// ── Carte notification ─────────────────────────────────────────────────────

class _NotifCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  const _NotifCard({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.scanConfirmed:
        return Icons.check_circle_rounded;
      case NotificationType.sessionMissed:
        return Icons.event_busy_rounded;
      case NotificationType.courseReminder:
        return Icons.alarm_rounded;
      case NotificationType.qrExpired:
        return Icons.qr_code_rounded;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case NotificationType.scanConfirmed:
        return ISPMColors.success;
      case NotificationType.sessionMissed:
        return ISPMColors.error;
      case NotificationType.courseReminder:
        return ISPMColors.warning;
      case NotificationType.qrExpired:
        return ISPMColors.grey600;
    }
  }

  Color get _iconBg => _iconColor.withOpacity(0.12);

  @override
  Widget build(BuildContext context) {
    final isUnread = notification.status == NotificationStatus.unread;
    final timeFmt = DateFormat('HH:mm');
    final dateFmt = DateFormat('dd/MM');

    final now = DateTime.now();
    final isToday = notification.createdAt.day == now.day &&
        notification.createdAt.month == now.month;
    final timeLabel = isToday
        ? timeFmt.format(notification.createdAt)
        : dateFmt.format(notification.createdAt);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: ISPMColors.error,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: ISPMColors.white,
            borderRadius: BorderRadius.circular(14),
            border: isUnread
                ? Border.all(
                    color: ISPMColors.green.withOpacity(0.3), width: 1.5)
                : null,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, color: _iconColor, size: 20),
              ),
              const SizedBox(width: 12),

              // Contenu
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: isUnread
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              fontSize: 14,
                              color: ISPMColors.black,
                            ),
                          ),
                        ),
                        Text(
                          timeLabel,
                          style: const TextStyle(
                              color: ISPMColors.grey400, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: const TextStyle(
                          color: ISPMColors.grey600,
                          fontSize: 12,
                          height: 1.4),
                    ),

                    // Détails scan si disponible
                    if (notification.invigilatorName != null) ...[
                      const SizedBox(height: 8),
                      _ScanDetail(
                        invigilator: notification.invigilatorName!,
                        scanTime: notification.scanTime,
                      ),
                    ],
                  ],
                ),
              ),

              // Point non lu
              if (isUnread) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: ISPMColors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Détail scan ────────────────────────────────────────────────────────────

class _ScanDetail extends StatelessWidget {
  final String invigilator;
  final DateTime? scanTime;

  const _ScanDetail({required this.invigilator, this.scanTime});

  @override
  Widget build(BuildContext context) {
    final timeFmt = DateFormat('HH:mm');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ISPMColors.greenSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_pin_rounded,
              size: 13, color: ISPMColors.green),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              invigilator,
              style: const TextStyle(
                  color: ISPMColors.greenDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
          ),
          if (scanTime != null) ...[
            const Icon(Icons.access_time_rounded,
                size: 13, color: ISPMColors.green),
            const SizedBox(width: 4),
            Text(
              timeFmt.format(scanTime!),
              style: const TextStyle(
                  color: ISPMColors.greenDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}

// ── En-tête section ────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final int? badge;

  const _SectionHeader({required this.title, this.badge});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: ISPMColors.black)),
        if (badge != null && badge! > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: ISPMColors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$badge',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ],
    );
  }
}

// ── État vide ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: ISPMColors.greenSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none_rounded,
                size: 40, color: ISPMColors.green),
          ),
          const SizedBox(height: 16),
          const Text('Tout est à jour',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: ISPMColors.black)),
          const SizedBox(height: 6),
          const Text('Aucune notification pour le moment.',
              style: TextStyle(color: ISPMColors.grey400, fontSize: 14)),
        ],
      ),
    );
  }
}
