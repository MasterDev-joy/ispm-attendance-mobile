// lib/features/schedule/presentation/pages/schedule_page.dart
//
// ══════════════════════════════════════════════════════════════════════════════
//  SchedulePage — Emploi du temps
// ══════════════════════════════════════════════════════════════════════════════
//
// Refonte dark complète — cohérente avec HomePage.
// Adapté aux 3 rôles :
//   • Professeur  → ses cours + bouton QR sur chaque carte active
//   • Superviseur → tous les cours + bouton scanner sur les cours actifs
//   • Admin       → tous les cours (vue globale) + statut de couverture
//
// Architecture :
//   _SchedulePage (StatefulWidget)
//   └── Stack : background (blobs + mesh) + SafeArea
//       ├── _ScheduleHeader  (SliverAppBar condensé)
//       ├── _WeekStrip        (sélecteur de jour horizontal)
//       └── _CourseList       (liste filtrée par jour sélectionné)
//           ├── _ProfessorCourseCard
//           ├── _SupervisorCourseCard
//           └── _AdminCourseCard
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';

import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../schedule/presentation/blocs/schedule_bloc.dart';
import '../../../schedule/domain/entities/course.dart';
import '../../../attendance/presentation/pages/qr_generator_page.dart';
import '../../../attendance/presentation/pages/attendance_scanner_page.dart';

import '../../../home/presentation/widgets/shared/home_app_bar.dart';
import '../../../home/presentation/widgets/shared/home_alert_card.dart';

// Accent colors
const _kBlue = Color(0xFF378ADD);
const _kAmber = Color(0xFFBA7517);

// ─────────────────────────────────────────────────────────────────────────────

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with SingleTickerProviderStateMixin {
  late Timer _clockTimer;
  DateTime _now = DateTime.now();
  late AnimationController _animController;

  // Jour sélectionné dans le strip — par défaut aujourd'hui
  late DateTime _selectedDay;

  // Jours de la semaine courante (lun → dim)
  late List<DateTime> _weekDays;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _selectedDay = _today;
    _weekDays = _buildWeek(_now);

    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    context.read<ScheduleBloc>().add(const ScheduleEvent.load());
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _animController.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  DateTime get _today => DateTime(_now.year, _now.month, _now.day);

  List<DateTime> _buildWeek(DateTime ref) {
    final monday = ref.subtract(Duration(days: ref.weekday - 1));
    return List.generate(
      7,
      (i) => DateTime(monday.year, monday.month, monday.day + i),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isCurrent(Course c) =>
      _now.isAfter(c.startTime) && _now.isBefore(c.endTime);

  bool _isPast(Course c) => _now.isAfter(c.endTime);

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  double _progress(Course c) {
    final total = c.endTime.difference(c.startTime).inSeconds;
    final elapsed = _now.difference(c.startTime).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  List<Course> _filteredCourses(List<Course> all) =>
      all.where((c) => _isSameDay(c.startTime, _selectedDay)).toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

  UserRole _resolveRole(String raw) {
    switch (raw.toLowerCase().trim()) {
      case 'supervisor':
      case 'superviseur':
        return UserRole.supervisor;
      case 'admin':
      case 'administrator':
        return UserRole.admin;
      default:
        return UserRole.professor;
    }
  }

  Color _accentFor(UserRole r) => switch (r) {
    UserRole.professor => ISPMColors.green,
    UserRole.supervisor => _kBlue,
    UserRole.admin => _kAmber,
  };

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final userName = authState.maybeWhen(
          authenticated: (user) => user.name,
          orElse: () => '',
        );
        final role = authState.maybeWhen(
          authenticated: (user) => _resolveRole(user.role),
          orElse: () => UserRole.professor,
        );

        final accent = _accentFor(role);

        return Scaffold(
          backgroundColor: ISPMColors.black,
          body: Stack(
            children: [
              // Background blobs
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
                top: 350,
                right: -80,
                child: IspmGlowBlob.circle(
                  radius: 140,
                  primaryColor: accent.withOpacity(0.06),
                  secondaryColor: Colors.transparent,
                ),
              ),
              const Positioned.fill(child: IspmMeshGrid()),

              // Contenu
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // AppBar
                    _ScheduleAppBar(
                      userName: userName,
                      role: role,
                      accent: accent,
                      now: _now,
                      onBack: () => Navigator.pop(context),
                      onRefresh: () => context.read<ScheduleBloc>().add(
                        const ScheduleEvent.load(),
                      ),
                    ),

                    // Strip semaine
                    _WeekStrip(
                      days: _weekDays,
                      selected: _selectedDay,
                      today: _today,
                      accent: accent,
                      onSelect: (d) => setState(() {
                        _selectedDay = d;
                        _animController.reset();
                        _animController.forward();
                      }),
                    ),

                    const SizedBox(height: 4),

                    // Liste cours
                    Expanded(
                      child: BlocBuilder<ScheduleBloc, ScheduleState>(
                        builder: (context, state) {
                          // Utilisation de .when() généré par Freezed
                          return state.when(
                            initial: () => Center(
                              child: CircularProgressIndicator(
                                color: accent,
                                strokeWidth: 2.5,
                              ),
                            ),
                            loading: () => Center(
                              child: CircularProgressIndicator(
                                color: accent,
                                strokeWidth: 2.5,
                              ),
                            ),
                            error: (message) => Padding(
                              padding: const EdgeInsets.all(20),
                              child: HomeAlertCard(
                                severity: AlertSeverity.error,
                                message: message,
                                actionLabel: 'Réessayer',
                                onAction: () => context
                                    .read<ScheduleBloc>()
                                    .add(const ScheduleEvent.load()),
                              ),
                            ),
                            loaded: (allCourses) {
                              final courses = _filteredCourses(allCourses);

                              if (courses.isEmpty) {
                                return _EmptyDay(
                                  isToday: _isSameDay(_selectedDay, _today),
                                  accent: accent,
                                );
                              }

                              return _CourseTimeline(
                                courses: courses,
                                role: role,
                                accent: accent,
                                now: _now,
                                animController: _animController,
                                isCurrent: _isCurrent,
                                isPast: _isPast,
                                progress: _progress,
                                fmt: _fmt,
                                authState: authState,
                              );
                            },
                          );
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
//  AppBar schedule
// ─────────────────────────────────────────────────────────────────────────────

class _ScheduleAppBar extends StatelessWidget {
  final String userName;
  final UserRole role;
  final Color accent;
  final DateTime now;
  final VoidCallback onBack;
  final VoidCallback onRefresh;

  const _ScheduleAppBar({
    required this.userName,
    required this.role,
    required this.accent,
    required this.now,
    required this.onBack,
    required this.onRefresh,
  });

  String get _monthYear {
    const months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];
    return '${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          // Bouton retour
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: ISPMColors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: ISPMColors.white.withOpacity(0.09)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: ISPMColors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Titre + mois
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emploi du temps',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ISPMColors.white,
                  ),
                ),
                Text(
                  _monthYear,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: ISPMColors.white.withOpacity(0.40),
                  ),
                ),
              ],
            ),
          ),

          // Refresh
          GestureDetector(
            onTap: onRefresh,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: ISPMColors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: ISPMColors.white.withOpacity(0.09)),
              ),
              child: Icon(
                Icons.refresh_rounded,
                size: 17,
                color: ISPMColors.white.withOpacity(0.70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Strip semaine horizontal
// ─────────────────────────────────────────────────────────────────────────────

class _WeekStrip extends StatelessWidget {
  final List<DateTime> days;
  final DateTime selected;
  final DateTime today;
  final Color accent;
  final ValueChanged<DateTime> onSelect;

  const _WeekStrip({
    required this.days,
    required this.selected,
    required this.today,
    required this.accent,
    required this.onSelect,
  });

  static const _dayLabels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.asMap().entries.map((e) {
          final i = e.key;
          final d = e.value;
          final isSelected =
              d.year == selected.year &&
              d.month == selected.month &&
              d.day == selected.day;
          final isToday =
              d.year == today.year &&
              d.month == today.month &&
              d.day == today.day;

          return GestureDetector(
            onTap: () => onSelect(d),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 40,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? accent
                    : isToday
                    ? accent.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? accent
                      : isToday
                      ? accent.withOpacity(0.35)
                      : ISPMColors.white.withOpacity(0.06),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _dayLabels[i],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? ISPMColors.white
                          : ISPMColors.white.withOpacity(0.40),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${d.day}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? ISPMColors.white
                          : isToday
                          ? accent
                          : ISPMColors.white.withOpacity(0.75),
                    ),
                  ),
                  if (isToday && !isSelected) ...[
                    const SizedBox(height: 3),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Timeline de cours
// ─────────────────────────────────────────────────────────────────────────────

class _CourseTimeline extends StatelessWidget {
  final List<Course> courses;
  final UserRole role;
  final Color accent;
  final DateTime now;
  final AnimationController animController;
  final bool Function(Course) isCurrent;
  final bool Function(Course) isPast;
  final double Function(Course) progress;
  final String Function(DateTime) fmt;
  final AuthState authState;

  const _CourseTimeline({
    required this.courses,
    required this.role,
    required this.accent,
    required this.now,
    required this.animController,
    required this.isCurrent,
    required this.isPast,
    required this.progress,
    required this.fmt,
    required this.authState,
  });

  Widget _stagger(int i, Widget child) {
    final start = (0.10 * i).clamp(0.0, 0.8);
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animController,
        curve: Interval(start, 1.0, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: animController,
                curve: Interval(start, 1.0, curve: Curves.easeOutCubic),
              ),
            ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
      physics: const BouncingScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (ctx, i) {
        final c = courses[i];
        final cur = isCurrent(c);
        final past = isPast(c);

        Widget card;
        switch (role) {
          case UserRole.professor:
            card = _ProfessorCourseCard(
              course: c,
              isCurrent: cur,
              isPast: past,
              progress: cur ? progress(c) : null,
              fmt: fmt,
              onQrTap: (!past)
                  ? () => Navigator.push(
                      ctx,
                      MaterialPageRoute(
                        builder: (_) => QrGeneratorPage(course: c),
                      ),
                    )
                  : null,
            );
          case UserRole.supervisor:
            card = _SupervisorCourseCard(
              course: c,
              isCurrent: cur,
              isPast: past,
              progress: cur ? progress(c) : null,
              fmt: fmt,
              onScanTap: cur
                  ? () => Navigator.push(
                      ctx,
                      MaterialPageRoute(
                        builder: (_) => const AttendanceScannerPage(),
                      ),
                    )
                  : null,
            );
          case UserRole.admin:
            card = _AdminCourseCard(
              course: c,
              isCurrent: cur,
              isPast: past,
              progress: cur ? progress(c) : null,
              fmt: fmt,
            );
        }

        return _stagger(i, card);
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Carte Professeur
// ─────────────────────────────────────────────────────────────────────────────

class _ProfessorCourseCard extends StatelessWidget {
  final Course course;
  final bool isCurrent;
  final bool isPast;
  final double? progress;
  final String Function(DateTime) fmt;
  final VoidCallback? onQrTap;

  const _ProfessorCourseCard({
    required this.course,
    required this.isCurrent,
    required this.isPast,
    this.progress,
    required this.fmt,
    this.onQrTap,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      isCurrent: isCurrent,
      isPast: isPast,
      accentColor: ISPMColors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CourseIconBox(
                isCurrent: isCurrent,
                isPast: isPast,
                color: ISPMColors.green,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isCurrent)
                      _StatusPill(label: 'EN COURS', color: ISPMColors.green),
                    if (isCurrent) const SizedBox(height: 4),
                    _CourseTitle(title: course.title, isPast: isPast),
                    const SizedBox(height: 3),
                    _MetaRow(
                      fieldOfStudy: course.fieldOfStudy,
                      start: fmt(course.startTime),
                      end: fmt(course.endTime),
                    ),
                  ],
                ),
              ),
              if (onQrTap != null)
                _ActionButton(
                  icon: Icons.qr_code_rounded,
                  color: ISPMColors.green,
                  onTap: onQrTap!,
                ),
            ],
          ),
          if (isCurrent && progress != null) ...[
            const SizedBox(height: 12),
            _ProgressRow(progress: progress!, color: ISPMColors.green),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Carte Superviseur
// ─────────────────────────────────────────────────────────────────────────────

class _SupervisorCourseCard extends StatelessWidget {
  final Course course;
  final bool isCurrent;
  final bool isPast;
  final double? progress;
  final String Function(DateTime) fmt;
  final VoidCallback? onScanTap;

  const _SupervisorCourseCard({
    required this.course,
    required this.isCurrent,
    required this.isPast,
    this.progress,
    required this.fmt,
    this.onScanTap,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      isCurrent: isCurrent,
      isPast: isPast,
      accentColor: _kBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CourseIconBox(
                isCurrent: isCurrent,
                isPast: isPast,
                color: _kBlue,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isCurrent)
                      _StatusPill(label: 'À SCANNER', color: _kBlue),
                    if (isPast)
                      _StatusPill(
                        label: 'TERMINÉ',
                        color: ISPMColors.white.withOpacity(0.25),
                      ),
                    if (isCurrent || isPast) const SizedBox(height: 4),
                    _CourseTitle(title: course.title, isPast: isPast),
                    const SizedBox(height: 3),
                    _MetaRow(
                      fieldOfStudy: course.fieldOfStudy,
                      start: fmt(course.startTime),
                      end: fmt(course.endTime),
                    ),
                  ],
                ),
              ),
              if (onScanTap != null)
                _ActionButton(
                  icon: Icons.qr_code_scanner_rounded,
                  color: _kBlue,
                  label: 'Scanner',
                  onTap: onScanTap!,
                ),
            ],
          ),
          if (isCurrent && progress != null) ...[
            const SizedBox(height: 12),
            _ProgressRow(progress: progress!, color: _kBlue),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Carte Admin
// ─────────────────────────────────────────────────────────────────────────────

class _AdminCourseCard extends StatelessWidget {
  final Course course;
  final bool isCurrent;
  final bool isPast;
  final double? progress;
  final String Function(DateTime) fmt;

  const _AdminCourseCard({
    required this.course,
    required this.isCurrent,
    required this.isPast,
    this.progress,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    // Simuler statut couverture
    final isCovered = isPast;
    final coverColor = isCovered
        ? ISPMColors.green
        : isCurrent
        ? _kBlue
        : ISPMColors.white.withOpacity(0.25);

    return _BaseCard(
      isCurrent: isCurrent,
      isPast: isPast,
      accentColor: _kAmber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CourseIconBox(
                isCurrent: isCurrent,
                isPast: isPast,
                color: _kAmber,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (isCurrent)
                          _StatusPill(label: 'EN COURS', color: _kBlue),
                        if (isCurrent) const SizedBox(width: 6),
                        _StatusPill(
                          label: isCovered ? '✓ COUVERT' : 'NON COUVERT',
                          color: coverColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _CourseTitle(title: course.title, isPast: isPast),
                    const SizedBox(height: 3),
                    _MetaRow(
                      fieldOfStudy: course.fieldOfStudy,
                      start: fmt(course.startTime),
                      end: fmt(course.endTime),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isCurrent && progress != null) ...[
            const SizedBox(height: 12),
            _ProgressRow(progress: progress!, color: _kAmber),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Sous-widgets communs aux cartes
// ─────────────────────────────────────────────────────────────────────────────

class _BaseCard extends StatelessWidget {
  final bool isCurrent;
  final bool isPast;
  final Color accentColor;
  final Widget child;

  const _BaseCard({
    required this.isCurrent,
    required this.isPast,
    required this.accentColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isPast ? 0.52 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isCurrent ? accentColor.withOpacity(0.10) : ISPMColors.grey900,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCurrent
                ? accentColor.withOpacity(0.55)
                : ISPMColors.white.withOpacity(0.06),
            width: isCurrent ? 1.5 : 1.0,
          ),
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.10),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    );
  }
}

class _CourseIconBox extends StatelessWidget {
  final bool isCurrent;
  final bool isPast;
  final Color color;
  const _CourseIconBox({
    required this.isCurrent,
    required this.isPast,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isPast
            ? ISPMColors.white.withOpacity(0.05)
            : color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPast
              ? ISPMColors.white.withOpacity(0.08)
              : color.withOpacity(0.30),
        ),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        size: 18,
        color: isPast ? ISPMColors.white.withOpacity(0.25) : color,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withOpacity(0.30)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _CourseTitle extends StatelessWidget {
  final String title;
  final bool isPast;
  const _CourseTitle({required this.title, required this.isPast});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: ISPMColors.white.withOpacity(isPast ? 0.35 : 1.0),
        decoration: isPast ? TextDecoration.lineThrough : null,
        decorationColor: ISPMColors.white.withOpacity(0.25),
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String fieldOfStudy;
  final String start;
  final String end;
  const _MetaRow({
    required this.fieldOfStudy,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.group_outlined,
          size: 11,
          color: ISPMColors.white.withOpacity(0.30),
        ),
        const SizedBox(width: 3),
        Text(
          fieldOfStudy,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: ISPMColors.white.withOpacity(0.35),
          ),
        ),
        const SizedBox(width: 10),
        Icon(
          Icons.access_time_rounded,
          size: 11,
          color: ISPMColors.white.withOpacity(0.30),
        ),
        const SizedBox(width: 3),
        Text(
          '$start – $end',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: ISPMColors.white.withOpacity(0.35),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String? label;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.30),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: ISPMColors.white),
              const SizedBox(width: 5),
              Text(
                label!,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: ISPMColors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.13),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.30)),
        ),
        child: Icon(icon, size: 17, color: color),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final double progress;
  final Color color;
  const _ProgressRow({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: ISPMColors.white.withOpacity(0.07),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          '${(progress * 100).round()}%',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  État vide
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyDay extends StatelessWidget {
  final bool isToday;
  final Color accent;
  const _EmptyDay({required this.isToday, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withOpacity(0.25)),
            ),
            child: Icon(Icons.event_available_rounded, size: 28, color: accent),
          ),
          const SizedBox(height: 16),
          Text(
            isToday ? 'Aucun cours aujourd\'hui' : 'Aucun cours ce jour',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: ISPMColors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isToday
                ? 'Votre journée est libre !'
                : 'Pas de cours planifié pour ce jour.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: ISPMColors.white.withOpacity(0.35),
            ),
          ),
        ],
      ),
    );
  }
}
