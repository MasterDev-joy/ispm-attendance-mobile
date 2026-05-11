// lib/features/notifications/presentation/pages/notifications_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../blocs/notification_bloc.dart';
import '../../domain/entities/app_notification.dart';
import '../widgets/notif_app_bar.dart';
import '../widgets/notif_card.dart';
import '../widgets/notif_empty_state.dart';
import '../widgets/notif_error_state.dart';
import '../widgets/notif_section_header.dart';

const _kBlue = Color(0xFF378ADD);
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
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();
    context.read<NotificationBloc>().add(
      const NotificationEvent.loadNotifications(),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Résolution accent depuis AuthState ────────────────────────────────────
  Color _accentFor(AuthState authState) {
    final user = authState.whenOrNull(authenticated: (u) => u);
    if (user == null) return ISPMColors.green;

    return switch (user.role.toString().toLowerCase()) {
      'supervisor' || 'superviseur' => _kBlue,
      'admin' || 'administrator' => _kAmber,
      _ => ISPMColors.green,
    };
  }
  // ── Animation staggerée ───────────────────────────────────────────────────

  Widget _stagger(int i, Widget child) {
    final start = (0.08 * i).clamp(0.0, 0.75);
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animCtrl,
        curve: Interval(start, 1.0, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animCtrl,
                curve: Interval(start, 1.0, curve: Curves.easeOutCubic),
              ),
            ),
        child: child,
      ),
    );
  }

  // ── Formatage date ────────────────────────────────────────────────────────

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  String _formatLabel(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'il y a ${diff.inHours}h';
    if (diff.inDays == 1) return 'Hier · ${_formatTime(dt)}';

    const months = [
      'jan',
      'fév',
      'mar',
      'avr',
      'mai',
      'jun',
      'jul',
      'aoû',
      'sep',
      'oct',
      'nov',
      'déc',
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final accent = _accentFor(authState);

        return Scaffold(
          backgroundColor: ISPMColors.black,
          body: Stack(
            children: [
              Positioned(
                top: -80,
                left: -60,
                child: IspmGlowBlob.circle(
                  radius: 200,
                  primaryColor: accent.withOpacity(0.09),
                  secondaryColor: Colors.transparent,
                ),
              ),
              Positioned(
                bottom: -60,
                right: -40,
                child: IspmGlowBlob.circle(
                  radius: 150,
                  primaryColor: accent.withOpacity(0.06),
                  secondaryColor: Colors.transparent,
                ),
              ),
              const Positioned.fill(child: IspmMeshGrid()),

              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    NotifAppBar(
                      accent: accent,
                      onBack: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: BlocBuilder<NotificationBloc, NotificationState>(
                        // Pattern .when() obligatoire (freezed)
                        builder: (ctx, state) => state.when(
                          initial: () => const SizedBox.shrink(),
                          loading: () => Center(
                            child: CircularProgressIndicator(
                              color: accent,
                              strokeWidth: 2.5,
                            ),
                          ),
                          error: (message) => NotifErrorState(
                            message: message,
                            accent: accent,
                            onRetry: () => ctx.read<NotificationBloc>().add(
                              const NotificationEvent.loadNotifications(),
                            ),
                          ),
                          loaded: (notifications) => notifications.isEmpty
                              ? NotifEmptyState(accent: accent)
                              : _NotifList(
                                  notifications: notifications,
                                  accent: accent,
                                  formatLabel: _formatLabel,
                                  formatTime: _formatTime,
                                  stagger: _stagger,
                                  onMarkRead: (id) {
                                    ctx.read<NotificationBloc>().add(
                                      NotificationEvent.markAsRead(id),
                                    );
                                    HapticFeedback.selectionClick();
                                  },
                                  onMarkAll: () =>
                                      ctx.read<NotificationBloc>().add(
                                        const NotificationEvent.markAllRead(),
                                      ),
                                  onDismiss: (id) =>
                                      ctx.read<NotificationBloc>().add(
                                        NotificationEvent.dismissNotification(
                                          id,
                                        ),
                                      ),
                                ),
                        ),
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
//  Widget liste interne à la page
// ─────────────────────────────────────────────────────────────────────────────

class _NotifList extends StatelessWidget {
  final List<AppNotification> notifications;
  final Color accent;
  final String Function(DateTime) formatLabel;
  final String Function(DateTime) formatTime;
  final Widget Function(int, Widget) stagger;
  final void Function(String) onMarkRead;
  final VoidCallback onMarkAll;
  final void Function(String) onDismiss;

  const _NotifList({
    required this.notifications,
    required this.accent,
    required this.formatLabel,
    required this.formatTime,
    required this.stagger,
    required this.onMarkRead,
    required this.onMarkAll,
    required this.onDismiss,
  });

  List<AppNotification> get _unread => notifications
      .where((n) => n.status == NotificationStatus.unread)
      .toList();

  List<AppNotification> get _readOrArchived => notifications
      .where((n) => n.status != NotificationStatus.unread)
      .toList();

  @override
  Widget build(BuildContext context) {
    int itemIndex = 0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
      physics: const BouncingScrollPhysics(),
      children: [
        // ── Section non lues ─────────────────────────────────────────────────
        if (_unread.isNotEmpty) ...[
          stagger(
            itemIndex++,
            NotifSectionHeader(
              label: 'Nouvelles',
              badge: _unread.length,
              accent: accent,
            ),
          ),
          const SizedBox(height: 10),
          ..._unread.asMap().entries.map(
            (e) => stagger(
              itemIndex++,
              NotifCard(
                notification: e.value,
                accent: accent,
                formatLabel: formatLabel,
                formatTime: formatTime,
                onTap: () => onMarkRead(e.value.id),
                onDismiss: () => onDismiss(e.value.id),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // ── Section historique ────────────────────────────────────────────────
        if (_readOrArchived.isNotEmpty) ...[
          stagger(
            itemIndex++,
            NotifSectionHeader(label: 'Historique', accent: accent),
          ),
          const SizedBox(height: 10),
          ..._readOrArchived.asMap().entries.map(
            (e) => stagger(
              itemIndex++,
              NotifCard(
                notification: e.value,
                accent: accent,
                formatLabel: formatLabel,
                formatTime: formatTime,
                onTap: null,
                onDismiss: () => onDismiss(e.value.id),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
