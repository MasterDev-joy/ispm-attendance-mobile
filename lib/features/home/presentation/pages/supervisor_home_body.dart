// lib/features/home/presentation/pages/supervisor_home_body.dart
//
// Corps de la home PAGE pour le rôle Superviseur.
// Compose les widgets supervisor/ + shared/ dans un CustomScrollView.
//
// Logique métier :
//   - Le superviseur voit les cours du jour (même ScheduleBloc)
//   - Il identifie quel cours est "à scanner" (en cours maintenant)
//   - Il voit l'historique des cours passés avec leur statut de scan
//   - Les cours futurs sont listés comme "en attente"
//   - Alerte rouge si un cours passé n'a pas été couvert
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ispm_attendance/core/di/injection_container.dart';
import '../../../attendance/data/repositories/attendance_repository_impl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../attendance/domain/repositories/attendance_repository.dart';
import '../../../schedule/presentation/blocs/schedule_bloc.dart';
import '../../../schedule/domain/entities/course.dart';
import '../../../attendance/presentation/pages/attendance_scanner_page.dart';

// Shared widgets
import '../widgets/shared/home_section_header.dart';
import '../widgets/shared/home_stat_grid.dart';
import '../widgets/shared/home_alert_card.dart';

// Supervisor widgets
import '../widgets/supervisor/supervisor_scan_card.dart';
import '../widgets/supervisor/supervisor_history_row.dart';

const _kBlue = Color(0xFF378ADD);

class SupervisorHomeBody extends StatefulWidget {
  final DateTime now;
  final AnimationController animController;

  /// Nom du prof extrait de l'API (rempli après scan réussi)
  /// Pour la home, on affiche un nom générique si indisponible.
  final String? lastScannedProfessorName;

  const SupervisorHomeBody({
    super.key,
    required this.now,
    required this.animController,
    this.lastScannedProfessorName,
  });

  @override // ← ajouter ceci
  State<SupervisorHomeBody> createState() => _SupervisorHomeBodyState();
}

class _SupervisorHomeBodyState extends State<SupervisorHomeBody> {
  Set<String> _validatedIds = {}; // IDs des cours validés
  // On demande l'instance à GetIt via "sl"
  final _attendanceRepo = sl<AttendanceRepository>();

  Future<void> _loadValidatedIds() async {
    // Le repository retourne un Either<Failure, Set<String>>
    final result = await _attendanceRepo.getTodayValidatedCourseIds();

    if (mounted) {
      // On utilise .fold() pour séparer l'erreur du succès
      result.fold(
        (failure) {
          // Gestion de l'erreur (tu peux afficher un log ou un snackbar)
          debugPrint("Erreur de récupération : ${failure.errorMessage}");
        },
        (ids) {
          // Succès : on met à jour l'état
          setState(() => _validatedIds = ids);
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadValidatedIds();
  }
  // ── Helpers ────────────────────────────────────────────────────────────────

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  bool _isCurrent(Course c) =>
      widget.now.isAfter(c.startTime) && widget.now.isBefore(c.endTime);
  bool _isPast(Course c) => widget.now.isAfter(c.endTime);
  bool _isUpcoming(Course c) => widget.now.isBefore(c.startTime);

  Course? _activeCourse(List<Course> courses) {
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
    final elapsed = widget.now.difference(c.startTime).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  String _countdown(Course c) {
    final diff = c.startTime.difference(widget.now);
    if (diff.inMinutes < 1) return 'Imminent';
    if (diff.inHours >= 1) {
      final h = diff.inHours;
      final m = diff.inMinutes % 60;
      return m > 0 ? 'dans ${h}h ${m}min' : 'dans ${h}h';
    }
    return 'dans ${diff.inMinutes} min';
  }

  ScanStatus _scanStatusFor(Course c) {
    if (_isCurrent(c)) return ScanStatus.scanning;
    if (_isPast(c)) {
      return _validatedIds.contains(c.id)
          ? ScanStatus.validated
          : ScanStatus.uncovered;
    }
    return ScanStatus.pending;
  }

  // ── Animation staggerée ────────────────────────────────────────────────────

  Widget _stagger(int index, Widget child) {
    final start = (0.08 * index).clamp(0.0, 0.9);
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: widget.animController,
        curve: Interval(start, 1.0, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: widget.animController,
                curve: Interval(start, 1.0, curve: Curves.easeOutCubic),
              ),
            ),
        child: child,
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        final (
          bool isLoading,
          bool isError,
          List<Course> courses,
          String errorMessage,
        ) = state.maybeWhen(
          // États de chargement
          initial: () => (true, false, <Course>[], ''),
          loading: () => (true, false, <Course>[], ''),

          // État chargé avec succès
          loaded: (coursesData) => (false, false, coursesData, ''),

          // État d'erreur
          error: (message) => (false, true, <Course>[], message),

          // Sécurité (au cas où tu ajoutes un autre état plus tard)
          orElse: () => (false, false, <Course>[], ''),
        );

        final active = _activeCourse(courses);
        final next = _nextCourse(courses);
        final pastCourses = courses.where(_isPast).toList();
        final uncoveredCount = pastCourses
            .where((c) => _scanStatusFor(c) == ScanStatus.uncovered)
            .length;
        final validatedCount = pastCourses
            .where((c) => _scanStatusFor(c) == ScanStatus.validated)
            .length;
        final pendingCount = courses.where(_isUpcoming).length;

        // ── Stats grid ─────────────────────────────────────────────
        final stats = [
          StatCardData(
            value: active != null ? 'À SCANNER' : '—',
            label: 'Cours actif',
            icon: Icons.qr_code_scanner_rounded,
            accentColor: _kBlue,
            isHighlighted: active != null,
          ),
          StatCardData(
            value: '$validatedCount',
            label: "Validés aujourd'hui",
            icon: Icons.check_circle_outline_rounded,
            accentColor: ISPMColors.green,
            isHighlighted: validatedCount > 0,
          ),
          StatCardData(
            value: '$pendingCount',
            label: 'En attente',
            icon: Icons.schedule_rounded,
            accentColor: ISPMColors.white.withOpacity(0.5),
          ),
          StatCardData(
            value: '${courses.length}',
            label: 'Total assigné',
            icon: Icons.calendar_today_rounded,
          ),
        ];

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Alerte cours non couverts ─────────────────────
                  if (uncoveredCount > 0) ...[
                    _stagger(
                      0,
                      HomeAlertCard(
                        severity: AlertSeverity.error,
                        message: uncoveredCount == 1
                            ? '1 cours passé non couvert aujourd\'hui'
                            : '$uncoveredCount cours passés non couverts',
                        icon: Icons.warning_amber_rounded,
                        actionLabel: 'Voir',
                        onAction: () =>
                            Navigator.pushNamed(context, '/schedule'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Grille stats ──────────────────────────────────
                  _stagger(1, HomeStatGrid(cards: stats)),

                  const SizedBox(height: 28),

                  // ── Cours à scanner ────────────────────────────────
                  _stagger(
                    2,
                    HomeSectionHeader(
                      label: 'Cours à scanner',
                      icon: Icons.qr_code_scanner_rounded,
                      iconColor: active != null
                          ? _kBlue
                          : ISPMColors.white.withOpacity(0.35),
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (isLoading)
                    _stagger(
                      3,
                      HomeLoadingCard(height: 120, accentColor: _kBlue),
                    )
                  else if (active != null)
                    _stagger(
                      3,
                      SupervisorScanCard(
                        course: active,
                        // TODO: remplacer par le vrai nom du prof (via API)
                        professorName: active.professorName.isNotEmpty
                            ? active.professorName
                            : 'Professeur',
                        progress: _progress(active),
                        formatTime: _fmt,
                        isValidated: false,
                      ),
                    )
                  else
                    _stagger(
                      3,
                      const HomeEmptyCard(
                        message: 'Aucun cours à scanner en ce moment',
                        icon: Icons.qr_code_outlined,
                      ),
                    ),

                  const SizedBox(height: 28),

                  // ── Prochain à scanner ─────────────────────────────
                  if (next != null) ...[
                    _stagger(
                      4,
                      HomeSectionHeader(
                        label: 'Prochain à scanner',
                        icon: Icons.schedule_rounded,
                        iconColor: _kBlue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _stagger(
                      4,
                      _NextScanCard(
                        course: next,
                        countdown: _countdown(next),
                        fmt: _fmt,
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // ── Historique du jour ─────────────────────────────
                  if (courses.isNotEmpty) ...[
                    _stagger(
                      6,
                      HomeSectionHeader(
                        label: 'Historique du jour',
                        icon: Icons.history_rounded,
                        iconColor: ISPMColors.white.withOpacity(0.40),
                        badgeText: '${courses.length}',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...courses.asMap().entries.map(
                      (e) => _stagger(
                        7 + e.key,
                        SupervisorHistoryRow(
                          courseTitle: e.value.title,
                          // TODO: remplacer par le vrai nom du prof depuis API
                          professorName: e.value.professorName.isNotEmpty
                              ? e.value.professorName
                              : 'Professeur',
                          startTime: _fmt(e.value.startTime),
                          endTime: _fmt(e.value.endTime),
                          status: _scanStatusFor(e.value),
                          onTap: _isCurrent(e.value)
                              ? () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const AttendanceScannerPage(),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],

                  // ── Erreur ────────────────────────────────────────
                  if (isError)
                    HomeAlertCard(
                      severity: AlertSeverity.error,
                      message: errorMessage,
                      actionLabel: 'Réessayer',
                      onAction: () => context.read<ScheduleBloc>().add(
                        ScheduleEvent.load(),
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
}

// ── Carte prochain à scanner ──────────────────────────────────────────────────

class _NextScanCard extends StatelessWidget {
  final Course course;
  final String countdown;
  final String Function(DateTime) fmt;

  const _NextScanCard({
    required this.course,
    required this.countdown,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ISPMColors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _kBlue.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kBlue.withOpacity(0.22)),
            ),
            child: const Icon(Icons.schedule_rounded, size: 18, color: _kBlue),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ISPMColors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${course.fieldOfStudy} · ${fmt(course.startTime)} – ${fmt(course.endTime)}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: ISPMColors.white.withOpacity(0.38),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _kBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _kBlue.withOpacity(0.32)),
            ),
            child: Text(
              countdown,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _kBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bouton accès rapide scanner ───────────────────────────────────────────────

class _QuickScanButton extends StatelessWidget {
  final VoidCallback onTap;
  const _QuickScanButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _kBlue.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kBlue.withOpacity(0.35), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: _kBlue.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.qr_code_scanner_rounded, size: 20, color: _kBlue),
            SizedBox(width: 10),
            Text(
              'OUVRIR LE SCANNER',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _kBlue,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
