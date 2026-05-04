// lib/features/home/presentation/pages/admin_home_body.dart
//
// Corps de la home PAGE pour le rôle Admin.
// Tableau de bord global de l'établissement :
//   • Stats globales (4 cartes) : cours du jour · validés · profs actifs · superviseurs
//   • Alertes temps réel (cours non couverts)
//   • Vue live de tous les cours (via ScheduleBloc — représentatif)
//   • Raccourcis de gestion (Utilisateurs · EDT · Rapports · Paramètres)
//
// NOTE : Les données "globales" (nb profs actifs, superviseurs, etc.) devront
// être alimentées par un futur AdminBloc/API. Pour l'instant on utilise le
// ScheduleBloc existant comme source représentative + des valeurs mock.
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
import '../widgets/shared/home_alert_card.dart';

// Admin widgets
import '../widgets/admin/admin_live_course_row.dart';
import '../widgets/admin/admin_action_card.dart';

const _kAmber = Color(0xFFBA7517);
const _kBlue  = Color(0xFF378ADD);

class AdminHomeBody extends StatelessWidget {
  final DateTime now;
  final AnimationController animController;

  // TODO: Ces valeurs seront fournies par un AdminBloc une fois l'API prête
  final int activeProfessors;
  final int activeSupervisors;

  const AdminHomeBody({
    super.key,
    required this.now,
    required this.animController,
    this.activeProfessors = 4,
    this.activeSupervisors = 2,
  });

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  bool _isCurrent(Course c) =>
      now.isAfter(c.startTime) && now.isBefore(c.endTime);
  bool _isPast(Course c) => now.isAfter(c.endTime);
  bool _isUpcoming(Course c) => now.isBefore(c.startTime);

  CoverageStatus _coverageFor(Course c) {
    if (_isUpcoming(c)) return CoverageStatus.upcoming;
    if (_isCurrent(c))  return CoverageStatus.active;
    // TODO: vérifier via AttendanceRepository si le cours a été scanné
    // Mock : simulé validé si passé depuis > 30 min
    final elapsed = now.difference(c.endTime).inMinutes;
    return elapsed > 30 ? CoverageStatus.covered : CoverageStatus.uncovered;
  }

  // ── Animation staggerée ────────────────────────────────────────────────────

  Widget _stagger(int index, Widget child) {
    final start = (0.07 * index).clamp(0.0, 0.9);
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
        final isLoading =
            state is ScheduleLoading || state is ScheduleInitial;
        final isError  = state is ScheduleError;
        final courses  =
        state is ScheduleLoaded ? state.courses : <Course>[];

        // ── Métriques globales ─────────────────────────────────────
        final totalCourses    = courses.length;
        final coveredCourses  = courses
            .where((c) => _coverageFor(c) == CoverageStatus.covered)
            .length;
        final uncoveredCourses = courses
            .where((c) => _coverageFor(c) == CoverageStatus.uncovered)
            .length;
        final activeCourses   = courses
            .where(_isCurrent)
            .length;

        // ── Stats grid ─────────────────────────────────────────────
        final stats = [
          StatCardData(
            value: '$totalCourses',
            label: 'Cours du jour',
            icon: Icons.calendar_today_rounded,
            accentColor: _kAmber,
          ),
          StatCardData(
            value: totalCourses > 0
                ? '$coveredCourses/$totalCourses'
                : '—',
            label: 'Cours validés',
            icon: Icons.check_circle_outline_rounded,
            accentColor: ISPMColors.green,
            isHighlighted: coveredCourses > 0,
          ),
          StatCardData(
            value: '$activeProfessors',
            label: 'Profs actifs',
            icon: Icons.menu_book_rounded,
            accentColor: _kAmber,
          ),
          StatCardData(
            value: '$activeSupervisors',
            label: 'Superviseurs actifs',
            icon: Icons.qr_code_scanner_rounded,
            accentColor: _kBlue,
            isHighlighted: activeSupervisors > 0,
          ),
        ];

        // ── Trier les cours : actifs → passés → à venir ────────────
        final sortedCourses = [...courses]..sort((a, b) {
          int _priority(Course c) {
            if (_isCurrent(c))  return 0;
            if (_isPast(c))     return 1;
            return 2;
          }
          final p = _priority(a).compareTo(_priority(b));
          return p != 0 ? p : a.startTime.compareTo(b.startTime);
        });

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // ── Alertes critiques ──────────────────────────────
                  if (uncoveredCourses > 0) ...[
                    _stagger(
                      0,
                      HomeAlertCard(
                        severity: AlertSeverity.error,
                        message: uncoveredCourses == 1
                            ? '1 cours non couvert par un superviseur'
                            : '$uncoveredCourses cours non couverts par un superviseur',
                        icon: Icons.warning_amber_rounded,
                        actionLabel: 'Voir',
                        onAction: () =>
                            Navigator.pushNamed(context, '/courses'),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // ── Grille stats globales ──────────────────────────
                  _stagger(1, HomeStatGrid(cards: stats)),

                  const SizedBox(height: 28),

                  // ── Vue live tous cours ────────────────────────────
                  _stagger(
                    2,
                    HomeSectionHeader(
                      label: 'Cours live',
                      icon: Icons.radio_button_checked_rounded,
                      iconColor: activeCourses > 0
                          ? _kAmber
                          : ISPMColors.white.withOpacity(0.35),
                      badgeText: '$totalCourses',
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (isLoading)
                    _stagger(3, const HomeLoadingCard(height: 120, accentColor: _kAmber))
                  else if (courses.isEmpty)
                    _stagger(
                      3,
                      const HomeEmptyCard(
                        message: "Aucun cours planifié aujourd'hui",
                        icon: Icons.calendar_today_rounded,
                      ),
                    )
                  else
                    ...sortedCourses.asMap().entries.map(
                          (e) => _stagger(
                        3 + e.key,
                        AdminLiveCourseRow(
                          courseTitle:   e.value.title,
                          // TODO: remplacer par vrai nom prof via AdminBloc
                          professorName: 'Prof. ${e.value.fieldOfStudy.split(' ').first}',
                          fieldOfStudy:  e.value.fieldOfStudy,
                          startTime:     _fmt(e.value.startTime),
                          endTime:       _fmt(e.value.endTime),
                          status:        _coverageFor(e.value),
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/courses',
                            arguments: e.value.id,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 28),

                  // ── Raccourcis gestion ─────────────────────────────
                  _stagger(
                    4 + courses.length,
                    const HomeSectionHeader(
                      label: 'Gestion',
                      icon: Icons.settings_rounded,
                      iconColor: _kAmber,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Actions avec badge dynamique
                  ..._buildActionCards(context, courses.length),

                  // ── Erreur ─────────────────────────────────────────
                  if (isError)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: HomeAlertCard(
                        severity: AlertSeverity.error,
                        message: (state).message,
                        actionLabel: 'Réessayer',
                        onAction: () => context
                            .read<ScheduleBloc>()
                            .add(LoadScheduleEvent()),
                      ),
                    ),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Cartes d'action avec badges ───────────────────────────────────────────

  List<Widget> _buildActionCards(BuildContext context, int coursesCount) {
    final items = [
      AdminActionItem(
        icon: Icons.group_rounded,
        title: 'Utilisateurs',
        subtitle: 'Gérer profs & superviseurs',
        route: '/users',
        badge: '${activeProfessors + activeSupervisors}',
      ),
      AdminActionItem(
        icon: Icons.calendar_month_rounded,
        title: 'Emplois du temps',
        subtitle: 'Ajouter & modifier les cours',
        route: '/courses',
        badge: coursesCount > 0 ? '$coursesCount' : null,
      ),
      const AdminActionItem(
        icon: Icons.insert_drive_file_rounded,
        title: 'Rapports & exports',
        subtitle: 'CSV · PDF présences',
        route: '/reports',
      ),
      const AdminActionItem(
        icon: Icons.settings_rounded,
        title: 'Paramètres système',
        subtitle: 'Configuration générale',
        route: '/settings',
        accentColor: ISPMColors.grey400,
      ),
    ];

    return items.asMap().entries.map((e) {
      return _stagger(
        5 + e.key,
        AdminActionCard(item: e.value),
      );
    }).toList();
  }
}