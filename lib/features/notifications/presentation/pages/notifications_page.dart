// lib/features/notifications/presentation/pages/notifications_page.dart
//
// ══════════════════════════════════════════════════════════════════════════════
//  Page Notifications — refonte dark complète
// ══════════════════════════════════════════════════════════════════════════════
//
// • Fond noir + blobs + mesh — cohérent avec HomePage
// • Suppression dépendance intl → formatage manuel
// • Animation staggerée à l'entrée
// • Swipe-to-dismiss avec fond rouge animé
// • Accent color adapté au rôle (vert/bleu/amber)
// • Bouton "Tout lire" dans l'AppBar avec badge unread
// • 4 types : scanConfirmed · sessionMissed · courseReminder · qrExpired
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_state.dart';
import '../../../home/presentation/widgets/shared/home_app_bar.dart';
import '../blocs/notification_bloc.dart';
import '../blocs/notification_event.dart';
import '../blocs/notification_state.dart';
import '../../domain/entities/app_notification.dart';

const _kBlue  = Color(0xFF378ADD);
const _kAmber = Color(0xFFBA7517);

// ─────────────────────────────────────────────────────────────────────────────

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 650),
    )..forward();
    context.read<NotificationBloc>().add(LoadNotificationsEvent());
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Résolution rôle ───────────────────────────────────────────────────────

  UserRole _resolveRole(String raw) {
    switch (raw.toLowerCase().trim()) {
      case 'supervisor': case 'superviseur': return UserRole.supervisor;
      case 'admin': case 'administrator':    return UserRole.admin;
      default:                               return UserRole.professor;
    }
  }

  Color _accentFor(UserRole r) => switch (r) {
    UserRole.professor  => ISPMColors.green,
    UserRole.supervisor => _kBlue,
    UserRole.admin      => _kAmber,
  };

  // ── Animation staggerée ───────────────────────────────────────────────────

  Widget _stagger(int i, Widget child) {
    final start = (0.08 * i).clamp(0.0, 0.75);
    return FadeTransition(
      opacity: CurvedAnimation(parent: _animCtrl,
          curve: Interval(start, 1.0, curve: Curves.easeOut)),
      child: SlideTransition(
        position: Tween<Offset>(
            begin: const Offset(0, 0.08), end: Offset.zero)
            .animate(CurvedAnimation(parent: _animCtrl,
            curve: Interval(start, 1.0, curve: Curves.easeOutCubic))),
        child: child,
      ),
    );
  }

  // ── Formatage date sans intl ───────────────────────────────────────────────

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  String _formatLabel(DateTime dt) {
    final now  = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1)  return 'À l\'instant';
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    if (diff.inHours   < 24) return 'il y a ${diff.inHours}h';
    if (diff.inDays    == 1) return 'Hier · ${_formatTime(dt)}';

    const months = ['jan','fév','mar','avr','mai','jun',
      'jul','aoû','sep','oct','nov','déc'];
    return '${dt.day} ${months[dt.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final role = authState is AuthAuthenticated
            ? _resolveRole(authState.user.role) : UserRole.professor;
        final accent = _accentFor(role);

        return Scaffold(
          backgroundColor: ISPMColors.black,
          body: Stack(
            children: [
              // Background
              Positioned(top: -80, left: -60,
                  child: IspmGlowBlob.circle(radius: 200,
                      primaryColor: accent.withOpacity(0.09),
                      secondaryColor: Colors.transparent)),
              Positioned(bottom: -60, right: -40,
                  child: IspmGlowBlob.circle(radius: 150,
                      primaryColor: accent.withOpacity(0.06),
                      secondaryColor: Colors.transparent)),
              const Positioned.fill(child: IspmMeshGrid()),

              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // AppBar
                    _NotifAppBar(
                      accent: accent,
                      onBack: () => Navigator.pop(context),
                    ),

                    // Corps
                    Expanded(
                      child: BlocBuilder<NotificationBloc, NotificationState>(
                        builder: (ctx, state) {
                          if (state is NotificationLoading ||
                              state is NotificationInitial) {
                            return Center(child: CircularProgressIndicator(
                                color: accent, strokeWidth: 2.5));
                          }

                          if (state is NotificationError) {
                            return _ErrorState(
                              message: state.message,
                              accent: accent,
                              onRetry: () => ctx
                                  .read<NotificationBloc>()
                                  .add(LoadNotificationsEvent()),
                            );
                          }

                          if (state is NotificationLoaded) {
                            if (state.notifications.isEmpty) {
                              return _EmptyState(accent: accent);
                            }

                            return _NotifList(
                              state:         state,
                              accent:        accent,
                              formatLabel:   _formatLabel,
                              formatTime:    _formatTime,
                              stagger:       _stagger,
                              animCtrl:      _animCtrl,
                              onMarkRead:    (id) => ctx
                                  .read<NotificationBloc>()
                                  .add(MarkAsReadEvent(id)),
                              onMarkAll:     () => ctx
                                  .read<NotificationBloc>()
                                  .add(MarkAllReadEvent()),
                              onDismiss:     (id) => ctx
                                  .read<NotificationBloc>()
                                  .add(DismissNotificationEvent(id)),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  AppBar
// ─────────────────────────────────────────────────────────────────────────────

class _NotifAppBar extends StatelessWidget {
  final Color accent;
  final VoidCallback onBack;
  const _NotifAppBar({required this.accent, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(children: [
        GestureDetector(
          onTap: onBack,
          child: Container(width: 40, height: 40,
              decoration: BoxDecoration(
                  color: ISPMColors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ISPMColors.white.withOpacity(0.09))),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 15, color: ISPMColors.white)),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notifications',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 17,
                        fontWeight: FontWeight.w700, color: ISPMColors.white)),
                Text('Vos alertes & rappels',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 11,
                        color: Color(0x66FFFFFF))),
              ]),
        ),

        // Bouton "Tout lire"
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (ctx, state) {
            if (state is NotificationLoaded && state.unreadCount > 0) {
              return GestureDetector(
                onTap: () {
                  ctx.read<NotificationBloc>().add(MarkAllReadEvent());
                  HapticFeedback.selectionClick();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                      color: accent.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: accent.withOpacity(0.30))),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.done_all_rounded, size: 14, color: accent),
                    const SizedBox(width: 5),
                    Text('Tout lire',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 12,
                            fontWeight: FontWeight.w600, color: accent)),
                  ]),
                ),
              );
            }
            return const SizedBox(width: 40);
          },
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Liste principale
// ─────────────────────────────────────────────────────────────────────────────

class _NotifList extends StatelessWidget {
  final NotificationLoaded state;
  final Color accent;
  final String Function(DateTime) formatLabel;
  final String Function(DateTime) formatTime;
  final Widget Function(int, Widget) stagger;
  final AnimationController animCtrl;
  final void Function(String) onMarkRead;
  final VoidCallback onMarkAll;
  final void Function(String) onDismiss;

  const _NotifList({
    required this.state, required this.accent,
    required this.formatLabel, required this.formatTime,
    required this.stagger, required this.animCtrl,
    required this.onMarkRead, required this.onMarkAll,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    int itemIndex = 0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
      physics: const BouncingScrollPhysics(),
      children: [

        // ── Section non lues ───────────────────────────────────────
        if (state.unread.isNotEmpty) ...[
          stagger(itemIndex++, _SectionHeader(
            label: 'Nouvelles',
            badge: state.unreadCount,
            accent: accent,
          )),
          const SizedBox(height: 10),
          ...state.unread.asMap().entries.map((e) =>
              stagger(itemIndex++, _NotifCard(
                notification: e.value,
                accent:       accent,
                formatLabel:  formatLabel,
                formatTime:   formatTime,
                onTap: () {
                  onMarkRead(e.value.id);
                  HapticFeedback.selectionClick();
                },
                onDismiss: () => onDismiss(e.value.id),
              )),
          ),
          const SizedBox(height: 20),
        ],

        // ── Section historique ─────────────────────────────────────
        if (state.readOrArchived.isNotEmpty) ...[
          stagger(itemIndex++, _SectionHeader(
            label: 'Historique',
            accent: accent,
          )),
          const SizedBox(height: 10),
          ...state.readOrArchived.asMap().entries.map((e) =>
              stagger(itemIndex++, _NotifCard(
                notification: e.value,
                accent:       accent,
                formatLabel:  formatLabel,
                formatTime:   formatTime,
                onTap:        null,
                onDismiss:    () => onDismiss(e.value.id),
              )),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Carte notification
// ─────────────────────────────────────────────────────────────────────────────

class _NotifCard extends StatelessWidget {
  final AppNotification notification;
  final Color           accent;
  final String Function(DateTime) formatLabel;
  final String Function(DateTime) formatTime;
  final VoidCallback?   onTap;
  final VoidCallback    onDismiss;

  const _NotifCard({
    required this.notification, required this.accent,
    required this.formatLabel,  required this.formatTime,
    required this.onTap,        required this.onDismiss,
  });

  bool get _isUnread => notification.status == NotificationStatus.unread;

  Color get _typeColor => switch (notification.type) {
    NotificationType.scanConfirmed  => ISPMColors.green,
    NotificationType.sessionMissed  => ISPMColors.error,
    NotificationType.courseReminder => const Color(0xFFF57C00),
    NotificationType.qrExpired      => ISPMColors.grey400,
  };

  IconData get _typeIcon => switch (notification.type) {
    NotificationType.scanConfirmed  => Icons.check_circle_rounded,
    NotificationType.sessionMissed  => Icons.event_busy_rounded,
    NotificationType.courseReminder => Icons.alarm_rounded,
    NotificationType.qrExpired      => Icons.qr_code_2_rounded,
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
            border: Border.all(color: ISPMColors.error.withOpacity(0.30))),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded,
                color: ISPMColors.error, size: 20),
            SizedBox(width: 6),
            Text('Supprimer',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 12,
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
            color: _isUnread
                ? color.withOpacity(0.07)
                : ISPMColors.grey900,
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
              // ── Icône type ───────────────────────────────────────
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.25))),
                child: Icon(_typeIcon, color: color, size: 19),
              ),

              const SizedBox(width: 12),

              // ── Contenu ──────────────────────────────────────────
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre + heure
                  Row(children: [
                    Expanded(child: Text(notification.title,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: _isUnread
                              ? FontWeight.w700 : FontWeight.w500,
                          color: ISPMColors.white.withOpacity(
                              _isUnread ? 1.0 : 0.65),
                        ))),
                    Text(formatLabel(notification.createdAt),
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
                            color: ISPMColors.white.withOpacity(0.30))),
                  ]),

                  const SizedBox(height: 4),

                  // Corps
                  Text(notification.body,
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 12,
                          color: ISPMColors.white.withOpacity(
                              _isUnread ? 0.55 : 0.38),
                          height: 1.45)),

                  // Course tag
                  const SizedBox(height: 8),
                  _CoursePill(
                      courseTitle: notification.courseTitle,
                      color: color),

                  // Détail scan si disponible
                  if (notification.invigilatorName != null) ...[
                    const SizedBox(height: 8),
                    _ScanDetail(
                      invigilator: notification.invigilatorName!,
                      scanTime:    notification.scanTime,
                      formatTime:  formatTime,
                    ),
                  ],
                ],
              )),

              const SizedBox(width: 8),

              // Point non lu
              if (_isUnread)
                Container(
                    width: 8, height: 8, margin: const EdgeInsets.only(top: 3),
                    decoration: BoxDecoration(
                        color: color, shape: BoxShape.circle)),
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
  final Color  color;
  const _CoursePill({required this.courseTitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.20))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.menu_book_rounded, size: 10, color: color),
        const SizedBox(width: 4),
        Flexible(child: Text(courseTitle,
            style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
                fontWeight: FontWeight.w500, color: color),
            overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}

// ── Détail scan ────────────────────────────────────────────────────────────────

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
          border: Border.all(color: ISPMColors.green.withOpacity(0.20))),
      child: Row(children: [
        const Icon(Icons.person_pin_rounded, size: 12, color: ISPMColors.green),
        const SizedBox(width: 5),
        Expanded(child: Text(invigilator,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 11,
                fontWeight: FontWeight.w600, color: ISPMColors.green))),
        if (scanTime != null) ...[
          const Icon(Icons.access_time_rounded, size: 12, color: ISPMColors.green),
          const SizedBox(width: 4),
          Text(formatTime(scanTime!),
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 11,
                  fontWeight: FontWeight.w600, color: ISPMColors.green)),
        ],
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  En-tête de section
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color  accent;
  final int?   badge;
  const _SectionHeader({required this.label, required this.accent, this.badge});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(label.toUpperCase(),
          style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
              fontWeight: FontWeight.w600, letterSpacing: 0.8,
              color: ISPMColors.white.withOpacity(0.38))),
      if (badge != null && badge! > 0) ...[
        const SizedBox(width: 8),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
                color: accent, borderRadius: BorderRadius.circular(20)),
            child: Text('$badge',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 10,
                    fontWeight: FontWeight.w700, color: ISPMColors.white))),
      ],
      const SizedBox(width: 10),
      Expanded(child: Divider(
          color: ISPMColors.white.withOpacity(0.07), thickness: 0.5)),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  État vide
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final Color accent;
  const _EmptyState({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 80, height: 80,
            decoration: BoxDecoration(
                color: accent.withOpacity(0.10),
                shape: BoxShape.circle,
                border: Border.all(color: accent.withOpacity(0.25))),
            child: Icon(Icons.notifications_none_rounded,
                size: 36, color: accent)),
        const SizedBox(height: 20),
        const Text('Tout est à jour',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18,
                fontWeight: FontWeight.w700, color: ISPMColors.white)),
        const SizedBox(height: 8),
        Text('Aucune notification pour le moment.',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 13,
                color: ISPMColors.white.withOpacity(0.40))),
      ],
    ));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  État erreur
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  final Color  accent;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.accent,
    required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 64, height: 64,
            decoration: BoxDecoration(
                color: ISPMColors.error.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ISPMColors.error.withOpacity(0.28))),
            child: const Icon(Icons.wifi_off_rounded,
                size: 28, color: ISPMColors.error)),
        const SizedBox(height: 18),
        const Text('Impossible de charger',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 16,
                fontWeight: FontWeight.w600, color: ISPMColors.white)),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Poppins', fontSize: 12,
                color: ISPMColors.white.withOpacity(0.38), height: 1.5)),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: onRetry,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
            decoration: BoxDecoration(
                color: accent.withOpacity(0.13),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accent.withOpacity(0.35))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.refresh_rounded, size: 15, color: accent),
              const SizedBox(width: 8),
              Text('Réessayer', style: TextStyle(fontFamily: 'Poppins',
                  fontSize: 13, fontWeight: FontWeight.w600, color: accent)),
            ]),
          ),
        ),
      ]),
    ));
  }
}