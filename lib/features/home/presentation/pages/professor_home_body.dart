// lib/features/home/presentation/pages/professor_home_body.dart
//
// Corps de la home PAGE pour le rôle Professeur.
// Compose tous les widgets professor/ + shared/ dans un CustomScrollView.
// Reçoit [userName] et [now] depuis HomePage (orchestrateur).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../schedule/presentation/blocs/schedule_bloc.dart';
import '../../../schedule/presentation/blocs/schedule_event.dart';
import '../../../schedule/presentation/blocs/schedule_state.dart';
import '../../../schedule/domain/entities/course.dart';

// Shared widgets
import '../widgets/shared/home_section_header.dart';
import '../widgets/shared/home_stat_grid.dart';
import '../widgets/shared/home_mini_course_row.dart';
import '../widgets/shared/home_alert_card.dart';

// Professor widgets
import '../widgets/professor/professor_current_course_card.dart';
import '../widgets/professor/professor_next_course_card.dart';

class ProfessorHomeBody extends StatelessWidget {
  final DateTime now;
  final AnimationController animController;

  const ProfessorHomeBody({
    super.key,
    required this.now,
    required this.animController,
  });

  // ── Helpers temps ──────────────────────────────────────────────────────────

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  bool _isCurrent(Course c) =>
      now.isAfter(c.startTime) && now.isBefore(c.endTime);
  bool _isPast(Course c) => now.isAfter(c.endTime);
  bool _isUpcoming(Course c) => now.isBefore(c.startTime);

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

  double _progress(Course c) {
    final total = c.endTime.difference(c.startTime).inSeconds;
    final elapsed = now.difference(c.startTime).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  String _countdown(Course c) {
    final diff = c.startTime.difference(now);
    if (diff.inMinutes < 1) return 'Imminent';
    if (diff.inHours >= 1) {
      final h = diff.inHours;
      final m = diff.inMinutes % 60;
      return m > 0 ? '${h}h ${m}min' : '${h}h';
    }
    return '${diff.inMinutes} min';
  }

  CourseRowState _rowState(Course c) {
    if (_isCurrent(c)) return CourseRowState.current;
    if (_isPast(c)) return CourseRowState.past;
    return CourseRowState.upcoming;
  }

  // ── Animation staggerée ────────────────────────────────────────────────────

  Widget _stagger(int index, Widget child) {
    final start = (0.08 * index).clamp(0.0, 0.9);
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animController,
        curve: Interval(start, 1.0, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.12),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animController,
          curve: Interval(start, 1.0, curve: Curves.easeOutCubic),
        )),
        child: child,
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        // ── Données dérivées ───────────────────────────────────────
        final isLoading =
            state is ScheduleLoading || state is ScheduleInitial;
        final isError = state is ScheduleError;
        final courses =
        state is ScheduleLoaded ? state.courses : <Course>[];

        final current = _currentCourse(courses);
        final next = _nextCourse(courses);
        final passed = courses.where(_isPast).length;
        final remaining = courses.length -
            passed -
            (current != null ? 1 : 0);
        final validated =
            courses.where((c) => _isPast(c)).length; // proxy validés

        // ── Stats grid ─────────────────────────────────────────────
        final stats = [
          StatCardData(
            value: '${courses.length}',
            label: "Cours aujourd'hui",
            icon: Icons.calendar_today_rounded,
          ),
          StatCardData(
            value: current != null ? 'EN COURS' : '$passed/${courses.length}',
            label: current != null ? 'Séance active' : 'Cours passés',
            icon: current != null
                ? Icons.play_circle_outline_rounded
                : Icons.check_circle_outline_rounded,
            isHighlighted: current != null,
          ),
          StatCardData(
            value: '$remaining',
            label: 'Cours restants',
            icon: Icons.hourglass_bottom_rounded,
          ),
          StatCardData(
            value: courses.isNotEmpty
                ? '${(passed / courses.length * 100).round()}%'
                : '—',
            label: 'Avancement',
            icon: Icons.trending_up_rounded,
            accentColor: ISPMColors.green,
          ),
        ];

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // ── Grille stats ─────────────────────────────────
                  _stagger(0, HomeStatGrid(cards: stats)),

                  const SizedBox(height: 28),

                  // ── Cours en cours ────────────────────────────────
                  _stagger(
                    1,
                    HomeSectionHeader(
                      label: 'Cours en cours',
                      icon: Icons.radio_button_checked_rounded,
                      iconColor: current != null
                          ? ISPMColors.green
                          : ISPMColors.white.withOpacity(0.35),
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (isLoading)
                    _stagger(2, HomeLoadingCard(height: 110))
                  else if (current != null)
                    _stagger(
                      2,
                      ProfessorCurrentCourseCard(
                        course: current,
                        progress: _progress(current),
                        formatTime: _formatTime,
                      ),
                    )
                  else
                    _stagger(
                      2,
                      const HomeEmptyCard(
                        message: 'Aucun cours en ce moment',
                        icon: Icons.event_busy_rounded,
                      ),
                    ),

                  const SizedBox(height: 28),

                  // ── Prochain cours ────────────────────────────────
                  if (next != null) ...[
                    _stagger(
                      3,
                      const HomeSectionHeader(
                        label: 'Prochain cours',
                        icon: Icons.schedule_rounded,
                        iconColor: ISPMColors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _stagger(
                      4,
                      ProfessorNextCourseCard(
                        course: next,
                        formatTime: _formatTime,
                        countdown: _countdown(next),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // ── Cours validés ─────────────────────────────────
                  if (validated > 0) ...[
                    _stagger(
                      5,
                      HomeSectionHeader(
                        label: 'Cours validés',
                        icon: Icons.verified_rounded,
                        iconColor: ISPMColors.green,
                        badgeText: '$validated',
                      ),
                    ),
                    const SizedBox(height: 10),
                    _stagger(
                      6,
                      _ValidatedCoursesCard(count: validated, total: courses.length),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // ── Liste complète ────────────────────────────────
                  if (courses.isNotEmpty) ...[
                    _stagger(
                      7,
                      HomeSectionHeader(
                        label: 'Tous les cours du jour',
                        icon: Icons.calendar_today_rounded,
                        iconColor: ISPMColors.white.withOpacity(0.40),
                        badgeText: '${courses.length}',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...courses.asMap().entries.map(
                          (e) => _stagger(
                        8 + e.key,
                        HomeMiniCourseRow(
                          title: e.value.title,
                          subtitle: e.value.fieldOfStudy,
                          startTime: _formatTime(e.value.startTime),
                          endTime: _formatTime(e.value.endTime),
                          state: _rowState(e.value),
                          accentColor: ISPMColors.green,
                          badgeLabel: _isCurrent(e.value)
                              ? 'EN COURS'
                              : _isPast(e.value)
                              ? '✓'
                              : null,
                        ),
                      ),
                    ),
                  ],

                  // ── Erreur ────────────────────────────────────────
                  if (isError)
                    HomeAlertCard(
                      severity: AlertSeverity.error,
                      message: (state).message,
                      actionLabel: 'Réessayer',
                      onAction: () =>
                          context.read<ScheduleBloc>().add(LoadScheduleEvent()),
                    ),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Carte cours validés ───────────────────────────────────────────────────────

class _ValidatedCoursesCard extends StatelessWidget {
  final int count;
  final int total;

  const _ValidatedCoursesCard({required this.count, required this.total});

  @override
  Widget build(BuildContext context) {
    final ratio = total > 0 ? count / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ISPMColors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          // Indicateur circulaire
          SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: ratio,
                  backgroundColor: ISPMColors.white.withOpacity(0.07),
                  color: ISPMColors.green,
                  strokeWidth: 4,
                ),
                Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ISPMColors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count cours sur $total validé${count > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ISPMColors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Scannés par un superviseur',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: ISPMColors.white.withOpacity(0.35),
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.verified_rounded,
            color: ISPMColors.green.withOpacity(0.6),
            size: 20,
          ),
        ],
      ),
    );
  }
}