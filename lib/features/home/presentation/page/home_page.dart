// lib/features/home/presentation/pages/home_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_event.dart';
import '../../../auth/presentation/blocs/auth_state.dart';
import '../../../schedule/presentation/blocs/schedule_bloc.dart';
import '../../../schedule/presentation/blocs/schedule_event.dart';
import '../../../schedule/presentation/blocs/schedule_state.dart';
import '../../../schedule/domain/entities/course.dart';
import '../../../attendance/presentation/pages/qr_generator_page.dart';
import '../../../../core/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<ScheduleBloc>().add(LoadScheduleEvent());
    // Rafraîchit l'heure chaque seconde pour la barre de progression live
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────

  bool _isCurrent(Course c) =>
      _now.isAfter(c.startTime) && _now.isBefore(c.endTime);

  bool _isPast(Course c) => _now.isAfter(c.endTime);

  bool _isUpcoming(Course c) => _now.isBefore(c.startTime);

  Course? _currentCourse(List<Course> courses) {
    try {
      return courses.firstWhere(_isCurrent);
    } catch (_) {
      return null;
    }
  }

  Course? _nextCourse(List<Course> courses) {
    final upcoming = courses.where(_isUpcoming).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    return upcoming.isEmpty ? null : upcoming.first;
  }

  int _totalCourses(List<Course> courses) => courses.length;

  int _passedCourses(List<Course> courses) =>
      courses.where(_isPast).length;

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  String _formatDate() {
    const days = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi',
      'Vendredi', 'Samedi', 'Dimanche',
    ];
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
    ];
    return '${days[_now.weekday - 1]} ${_now.day} ${months[_now.month - 1]}';
  }

  /// Countdown lisible vers le prochain cours (ex. "dans 1h 20min")
  String _countdown(Course c) {
    final diff = c.startTime.difference(_now);
    if (diff.inMinutes < 1) return 'Imminent';
    if (diff.inHours >= 1) {
      final h = diff.inHours;
      final m = diff.inMinutes % 60;
      return m > 0 ? 'dans ${h}h ${m}min' : 'dans ${h}h';
    }
    return 'dans ${diff.inMinutes} min';
  }

  /// Progression d'un cours en cours (0.0 → 1.0)
  double _progress(Course c) {
    final total = c.endTime.difference(c.startTime).inSeconds;
    final elapsed = _now.difference(c.startTime).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Déconnexion',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Voulez-vous vraiment vous déconnecter ?',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Annuler',
              style: TextStyle(fontFamily: 'Poppins', color: ISPMColors.grey400),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(LogoutRequestedEvent());
              Navigator.of(context).pushReplacementNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ISPMColors.error,
              minimumSize: const Size(80, 38),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'Quitter',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final userName = authState is AuthAuthenticated
            ? authState.user.name
            : 'Professeur';
        final initial =
        userName.isNotEmpty ? userName[0].toUpperCase() : 'P';

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8F6),
          body: BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: (context, scheduleState) {
              final courses = scheduleState is ScheduleLoaded
                  ? scheduleState.courses
                  : <Course>[];

              final current = _currentCourse(courses);
              final next = _nextCourse(courses);
              final total = _totalCourses(courses);
              final passed = _passedCourses(courses);

              return CustomScrollView(
                slivers: [
                  // ── SliverAppBar ──────────────────────────────────────
                  SliverAppBar(
                    expandedHeight: 200,
                    pinned: true,
                    backgroundColor: ISPMColors.black,
                    surfaceTintColor: Colors.transparent,
                    actions: [
                      // Bouton notification (décoratif — à brancher plus tard)
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {Navigator.pushNamed(context, '/notifications');},
                            icon: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: ISPMColors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                size: 18,
                                color: ISPMColors.white,
                              ),
                            ),
                          ),
                          // Badge rouge si absences à traiter
                          if (current != null)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: ISPMColors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        onPressed: _logout,
                        icon: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: ISPMColors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            size: 18,
                            color: ISPMColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: ISPMColors.black,
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar + nom
                            Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: ISPMColors.green,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Text(
                                      initial,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: ISPMColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bonjour,',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        color: ISPMColors.white.withOpacity(0.5),
                                      ),
                                    ),
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: ISPMColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            // Date + pill statut
                            Row(
                              children: [
                                Text(
                                  _formatDate(),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: ISPMColors.white,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                if (current != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: ISPMColors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'COURS EN COURS',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: ISPMColors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Titre collé quand la bar est réduite
                      titlePadding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
                      title: Text(
                        _formatDate(),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: ISPMColors.white,
                        ),
                      ),
                    ),
                  ),

                  // ── Contenu ───────────────────────────────────────────
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([

                        // ── Grille de stats ────────────────────────────
                        _StatsGrid(
                          totalCourses: total,
                          passedCourses: passed,
                          hasCurrent: current != null,
                        ),

                        const SizedBox(height: 24),

                        // ── Cours en cours ─────────────────────────────
                        if (scheduleState is ScheduleLoading ||
                            scheduleState is ScheduleInitial)
                          const _LoadingCard()
                        else if (current != null) ...[
                          _SectionHeader(
                            label: 'Cours en cours',
                            icon: Icons.radio_button_checked_rounded,
                            iconColor: ISPMColors.green,
                          ),
                          const SizedBox(height: 10),
                          _CurrentCourseCard(
                            course: current,
                            progress: _progress(current),
                            formatTime: _formatTime,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    QrGeneratorPage(course: current),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ] else ...[
                          _SectionHeader(
                            label: 'Cours en cours',
                            icon: Icons.radio_button_checked_rounded,
                            iconColor: ISPMColors.grey400,
                          ),
                          const SizedBox(height: 10),
                          const _NoCourseCard(message: 'Aucun cours en ce moment'),
                          const SizedBox(height: 24),
                        ],

                        // ── Prochain cours ─────────────────────────────
                        if (next != null) ...[
                          _SectionHeader(
                            label: 'Prochain cours',
                            icon: Icons.schedule_rounded,
                            iconColor: ISPMColors.grey400,
                          ),
                          const SizedBox(height: 10),
                          _NextCourseCard(
                            course: next,
                            countdown: _countdown(next),
                            formatTime: _formatTime,
                          ),
                          const SizedBox(height: 24),
                        ],

                        // ── Liste des autres cours ─────────────────────
                        if (courses.isNotEmpty) ...[
                          _SectionHeader(
                            label: 'Tous les cours du jour',
                            icon: Icons.calendar_today_rounded,
                            iconColor: ISPMColors.grey400,
                            trailing: Text(
                              '${courses.length}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ISPMColors.greenDark,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...courses.map((c) => _MiniCourseRow(
                            course: c,
                            isCurrent: _isCurrent(c),
                            isPast: _isPast(c),
                            formatTime: _formatTime,
                          )),
                        ],

                        // ── État erreur ────────────────────────────────
                        if (scheduleState is ScheduleError)
                          _ErrorCard(
                            message: scheduleState.message,
                            onRetry: () => context
                                .read<ScheduleBloc>()
                                .add(LoadScheduleEvent()),
                          ),
                      ]),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

// ── Widgets internes ────────────────────────────────────────────────────────

// Grille 2×2 de métriques rapides
class _StatsGrid extends StatelessWidget {
  final int totalCourses;
  final int passedCourses;
  final bool hasCurrent;

  const _StatsGrid({
    required this.totalCourses,
    required this.passedCourses,
    required this.hasCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = totalCourses - passedCourses - (hasCurrent ? 1 : 0);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.0,
      children: [
        _StatCard(
          value: '$totalCourses',
          label: 'Cours aujourd\'hui',
          color: ISPMColors.black,
          textColor: ISPMColors.white,
          icon: Icons.calendar_today_rounded,
        ),
        _StatCard(
          value: hasCurrent ? 'EN COURS' : '$passedCourses/$totalCourses',
          label: hasCurrent ? 'Séance active' : 'Cours passés',
          color: hasCurrent ? ISPMColors.green : const Color(0xFFF7F8F6),
          textColor: hasCurrent ? ISPMColors.white : ISPMColors.black,
          icon: hasCurrent
              ? Icons.play_circle_outline_rounded
              : Icons.check_circle_outline_rounded,
          iconColor: hasCurrent ? ISPMColors.white : ISPMColors.green,
          borderColor: hasCurrent ? Colors.transparent : const Color(0xFFEAEAE4),
        ),
        _StatCard(
          value: '$remaining',
          label: 'Cours restants',
          color: const Color(0xFFF7F8F6),
          textColor: ISPMColors.black,
          icon: Icons.hourglass_bottom_rounded,
          borderColor: const Color(0xFFEAEAE4),
        ),
        _StatCard(
          value: passedCourses > 0
              ? '${(passedCourses / totalCourses * 100).round()}%'
              : '—',
          label: 'Avancement',
          color: const Color(0xFFF7F8F6),
          textColor: ISPMColors.black,
          icon: Icons.trending_up_rounded,
          iconColor: ISPMColors.green,
          borderColor: const Color(0xFFEAEAE4),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color textColor;
  final IconData icon;
  final Color? iconColor;
  final Color? borderColor;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
    required this.textColor,
    required this.icon,
    this.iconColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: borderColor != null
            ? Border.all(color: borderColor!)
            : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor ?? textColor.withOpacity(0.7),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: textColor.withOpacity(0.55),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// En-tête de section
class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Widget? trailing;

  const _SectionHeader({
    required this.label,
    required this.icon,
    required this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: ISPMColors.black,
          ),
        ),
        const Spacer(),
        if (trailing != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: ISPMColors.greenSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: trailing!,
          ),
      ],
    );
  }
}

// Carte cours EN COURS avec barre de progression live
class _CurrentCourseCard extends StatelessWidget {
  final Course course;
  final double progress;
  final String Function(DateTime) formatTime;
  final VoidCallback onTap;

  const _CurrentCourseCard({
    required this.course,
    required this.progress,
    required this.formatTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: ISPMColors.black,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ISPMColors.green, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: ISPMColors.green.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icône cours
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: ISPMColors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.class_rounded,
                    color: ISPMColors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: ISPMColors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'EN COURS',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: ISPMColors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: ISPMColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Bouton QR
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: ISPMColors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.qr_code_rounded,
                    color: ISPMColors.green,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Infos filière + horaires
            Row(
              children: [
                Icon(Icons.group_outlined,
                    size: 13, color: ISPMColors.white.withOpacity(0.5)),
                const SizedBox(width: 4),
                Text(
                  course.fieldOfStudy,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: ISPMColors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.access_time_rounded,
                    size: 13, color: ISPMColors.white.withOpacity(0.5)),
                const SizedBox(width: 4),
                Text(
                  '${formatTime(course.startTime)} – ${formatTime(course.endTime)}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: ISPMColors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Barre de progression temporelle
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: ISPMColors.white.withOpacity(0.1),
                      color: ISPMColors.green,
                      minHeight: 5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ISPMColors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Appuyez pour générer le QR de présence',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: ISPMColors.white.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Carte prochain cours avec countdown
class _NextCourseCard extends StatelessWidget {
  final Course course;
  final String countdown;
  final String Function(DateTime) formatTime;

  const _NextCourseCard({
    required this.course,
    required this.countdown,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ISPMColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEAE4)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: ISPMColors.greenSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.schedule_rounded,
              color: ISPMColors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ISPMColors.black,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      course.fieldOfStudy,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: ISPMColors.grey400,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${formatTime(course.startTime)} – ${formatTime(course.endTime)}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: ISPMColors.grey400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: ISPMColors.greenSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              countdown,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ISPMColors.greenDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Ligne compacte pour la liste complète
class _MiniCourseRow extends StatelessWidget {
  final Course course;
  final bool isCurrent;
  final bool isPast;
  final String Function(DateTime) formatTime;

  const _MiniCourseRow({
    required this.course,
    required this.isCurrent,
    required this.isPast,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrent
            ? ISPMColors.black
            : ISPMColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrent
              ? ISPMColors.green
              : const Color(0xFFEAEAE4),
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Indicateur coloré
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: isCurrent
                  ? ISPMColors.green
                  : isPast
                  ? ISPMColors.grey200
                  : ISPMColors.greenSoft,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          // Heure
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatTime(course.startTime),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isCurrent
                      ? ISPMColors.green
                      : isPast
                      ? ISPMColors.grey400
                      : ISPMColors.black,
                ),
              ),
              Text(
                formatTime(course.endTime),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: isCurrent
                      ? ISPMColors.white.withOpacity(0.4)
                      : ISPMColors.grey400,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Titre + filière
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isCurrent
                        ? ISPMColors.white
                        : isPast
                        ? ISPMColors.grey400
                        : ISPMColors.black,
                    decoration: isPast ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  course.fieldOfStudy,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: isCurrent
                        ? ISPMColors.white.withOpacity(0.4)
                        : ISPMColors.grey400,
                  ),
                ),
              ],
            ),
          ),
          // Badge statut
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: ISPMColors.green,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'EN COURS',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: ISPMColors.white,
                ),
              ),
            )
          else if (isPast)
            const Icon(Icons.check_rounded, size: 16, color: ISPMColors.grey400),
        ],
      ),
    );
  }
}

// Cartes utilitaires
class _NoCourseCard extends StatelessWidget {
  final String message;
  const _NoCourseCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ISPMColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEAE4)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ISPMColors.grey100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_busy_rounded,
              size: 20,
              color: ISPMColors.grey400,
            ),
          ),
          const SizedBox(width: 14),
          Text(
            message,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: ISPMColors.grey400,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: ISPMColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEAE4)),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: ISPMColors.green,
          strokeWidth: 2.5,
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ISPMColors.errorSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ISPMColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded,
              size: 22, color: ISPMColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: ISPMColors.error,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              'Réessayer',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ISPMColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}