// lib/features/stats/presentation/pages/stats_page.dart
//
// Page Statistiques — adaptée aux 3 rôles.
//   • Professeur  → ses propres taux de présence par cours
//   • Superviseur → ses scans effectués / taux de couverture
//   • Admin       → statistiques globales de l'établissement
// Style dark cohérent avec la HomePage.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispm_attendance/features/auth/presentation/extensions/user_role_ext.dart.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../blocs/stats_bloc.dart';
import '../../domain/entities/stats_data.dart';
import '../../../home/presentation/widgets/shared/home_app_bar.dart';
import '../../../auth/domain/entities/user.dart';

const _kBlue = Color(0xFF378ADD);
const _kAmber = Color(0xFFBA7517);

// ─────────────────────────────────────────────────────────────────────────────

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage>
    with SingleTickerProviderStateMixin {
  StatsPeriod _period = StatsPeriod.month;
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    context.read<StatsBloc>().add(const StatsEvent.load());
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _changePeriod(StatsPeriod p) {
    setState(() => _period = p);
    _animCtrl.reset();
    context.read<StatsBloc>().add(StatsEvent.changePeriod(p));
  }

  Color _accentFor(UserRole r) => switch (r) {
    UserRole.professor => ISPMColors.green,
    UserRole.supervisor => _kBlue,
    UserRole.admin => _kAmber,
    UserRole.unknown => Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final role = authState.maybeWhen(
          authenticated: (user) => user.role,
          orElse: () => UserRole.professor,
        );
        final accent = _accentFor(role);

        return Scaffold(
          backgroundColor: ISPMColors.black,
          body: Stack(
            children: [
              // Background
              Positioned(
                top: -80,
                right: -60,
                child: IspmGlowBlob.circle(
                  radius: 200,
                  primaryColor: accent.withOpacity(0.09),
                  secondaryColor: Colors.transparent,
                ),
              ),
              Positioned(
                bottom: -60,
                left: -40,
                child: IspmGlowBlob.circle(
                  radius: 160,
                  primaryColor: accent.withOpacity(0.06),
                  secondaryColor: Colors.transparent,
                ),
              ),
              const Positioned.fill(child: IspmMeshGrid()),

              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // AppBar
                    _StatsAppBar(
                      accent: accent,
                      role: role,
                      onBack: () => Navigator.pop(context),
                    ),

                    // Sélecteur période
                    _PeriodSelector(
                      selected: _period,
                      accent: accent,
                      onChanged: _changePeriod,
                    ),

                    const SizedBox(height: 4),

                    // Corps
                    Expanded(
                      child: BlocConsumer<StatsBloc, StatsState>(
                        listener: (_, state) {
                          state.maybeWhen(
                            loaded: (data, period) =>
                                _animCtrl.forward(from: 0),
                            orElse: () => null,
                          );
                        },
                        builder: (_, state) {
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
                            error: (message) => _ErrorState(
                              message: message,
                              accent: accent,
                              onRetry: () => context.read<StatsBloc>().add(
                                const StatsEvent.load(),
                              ),
                            ),
                            loaded: (data, period) => _StatsBody(
                              data: data,
                              role: role,
                              accent: accent,
                              animCtrl: _animCtrl,
                              period: period,
                            ),
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
//  AppBar stats
// ─────────────────────────────────────────────────────────────────────────────

class _StatsAppBar extends StatelessWidget {
  final Color accent;
  final UserRole role;
  final VoidCallback onBack;

  const _StatsAppBar({
    required this.accent,
    required this.role,
    required this.onBack,
  });

  String get _title => switch (role) {
    UserRole.professor => 'Mes statistiques',
    UserRole.supervisor => 'Mes scans',
    UserRole.admin => 'Statistiques globales',
    UserRole.unknown => 'Inconnu',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ISPMColors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ISPMColors.white.withOpacity(0.09)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: ISPMColors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: ISPMColors.white,
                  ),
                ),
                Text(
                  'Suivez votre activité',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: ISPMColors.white.withOpacity(0.38),
                  ),
                ),
              ],
            ),
          ),
          // Badge rôle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withOpacity(0.35)),
            ),
            child: Text(
              role.roleLabel,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: accent,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Sélecteur de période
// ─────────────────────────────────────────────────────────────────────────────

class _PeriodSelector extends StatelessWidget {
  final StatsPeriod selected;
  final Color accent;
  final ValueChanged<StatsPeriod> onChanged;

  const _PeriodSelector({
    required this.selected,
    required this.accent,
    required this.onChanged,
  });

  static const _periods = [
    (StatsPeriod.month, 'Ce mois'),
    (StatsPeriod.semester, 'Semestre'),
    (StatsPeriod.all, 'Tout'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: ISPMColors.grey900,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ISPMColors.white.withOpacity(0.06)),
        ),
        child: Row(
          children: _periods.map((e) {
            final (period, label) = e;
            final isActive = period == selected;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(period),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: isActive ? accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: accent.withOpacity(0.30),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? ISPMColors.white
                          : ISPMColors.white.withOpacity(0.40),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Corps des statistiques
// ─────────────────────────────────────────────────────────────────────────────

class _StatsBody extends StatelessWidget {
  final GlobalStats data;
  final UserRole role;
  final Color accent;
  final AnimationController animCtrl;
  final StatsPeriod period;

  const _StatsBody({
    required this.data,
    required this.role,
    required this.accent,
    required this.animCtrl,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
      physics: const BouncingScrollPhysics(),
      children: [
        // Carte résumé global
        _GlobalSummaryCard(data: data, accent: accent, role: role),
        const SizedBox(height: 24),

        // Section par cours
        _SectionHeader(
          label: role == UserRole.admin
              ? 'Couverture par cours'
              : 'Présence par cours',
          accent: accent,
          badge: '${data.perCourse.length}',
        ),
        const SizedBox(height: 10),
        ...data.perCourse.asMap().entries.map(
          (e) => _AnimatedCourseBar(
            course: e.value,
            accent: accent,
            animCtrl: animCtrl,
            index: e.key,
          ),
        ),

        // Cours les plus manqués (prof uniquement)
        if (role == UserRole.professor && data.mostMissed.isNotEmpty) ...[
          const SizedBox(height: 24),
          _SectionHeader(
            label: 'Cours les plus manqués',
            accent: ISPMColors.error,
          ),
          const SizedBox(height: 10),
          ...data.mostMissed.map((c) => _MissedCourseRow(course: c)),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Carte résumé global
// ─────────────────────────────────────────────────────────────────────────────

class _GlobalSummaryCard extends StatelessWidget {
  final GlobalStats data;
  final Color accent;
  final UserRole role;

  const _GlobalSummaryCard({
    required this.data,
    required this.accent,
    required this.role,
  });

  Color _rateColor(double rate) {
    if (rate >= 0.80) return ISPMColors.green;
    if (rate >= 0.60) return const Color(0xFFF57C00);
    return ISPMColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final pct = (data.globalPresenceRate * 100).toStringAsFixed(0);
    final color = _rateColor(data.globalPresenceRate);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.30), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label + taux
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role == UserRole.professor
                          ? 'Taux de présence global'
                          : role == UserRole.supervisor
                          ? 'Taux de couverture'
                          : 'Taux de validation global',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: ISPMColors.white.withOpacity(0.45),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$pct',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: color,
                            letterSpacing: -2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '%',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Mini donuts stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StatPill(
                    label: '${data.presentCount} présences',
                    color: ISPMColors.green,
                  ),
                  const SizedBox(height: 6),
                  _StatPill(
                    label: '${data.absentCount} absences',
                    color: ISPMColors.error,
                  ),
                  const SizedBox(height: 6),
                  _StatPill(
                    label: '${data.totalSessions} séances',
                    color: ISPMColors.white.withOpacity(0.35),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Barre de progression
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: data.globalPresenceRate,
              backgroundColor: ISPMColors.white.withOpacity(0.07),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 12),

          // Indicateur qualitatif
          _QualityIndicator(rate: data.globalPresenceRate),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final Color color;
  const _StatPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _QualityIndicator extends StatelessWidget {
  final double rate;
  const _QualityIndicator({required this.rate});

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color color;
    final IconData icon;

    if (rate >= 0.90) {
      label = 'Excellente assiduité';
      color = ISPMColors.green;
      icon = Icons.star_rounded;
    } else if (rate >= 0.80) {
      label = 'Bonne assiduité';
      color = ISPMColors.green;
      icon = Icons.check_circle_outline_rounded;
    } else if (rate >= 0.60) {
      label = 'Assiduité à améliorer';
      color = const Color(0xFFF57C00);
      icon = Icons.warning_amber_rounded;
    } else {
      label = 'Assiduité insuffisante';
      color = ISPMColors.error;
      icon = Icons.error_outline_rounded;
    }

    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Barre de cours animée
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedCourseBar extends StatelessWidget {
  final CourseStats course;
  final Color accent;
  final AnimationController animCtrl;
  final int index;

  const _AnimatedCourseBar({
    required this.course,
    required this.accent,
    required this.animCtrl,
    required this.index,
  });

  Color _barColor(PresenceRisk risk) => switch (risk) {
    PresenceRisk.good => ISPMColors.green,
    PresenceRisk.warning => const Color(0xFFF57C00),
    PresenceRisk.critical => ISPMColors.error,
  };

  @override
  Widget build(BuildContext context) {
    final pct = (course.presenceRate * 100).toStringAsFixed(0);
    final color = _barColor(course.risk);

    // Stagger via Interval
    final start = (0.12 * index).clamp(0.0, 0.7);
    final anim = CurvedAnimation(
      parent: animCtrl,
      curve: Interval(start, 1.0, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.05, 0),
          end: Offset.zero,
        ).animate(anim),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: ISPMColors.grey900,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: course.risk == PresenceRisk.critical
                  ? ISPMColors.error.withOpacity(0.30)
                  : ISPMColors.white.withOpacity(0.06),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icône cours
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: color.withOpacity(0.25)),
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 16,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 11),
                  // Titre + filière
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.courseTitle,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: ISPMColors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          course.fieldOfStudy,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: ISPMColors.white.withOpacity(0.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Pourcentage
                  Text(
                    '$pct%',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: color,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Barre animée
              AnimatedBuilder(
                animation: animCtrl,
                builder: (_, __) => ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: animCtrl.value * course.presenceRate,
                    backgroundColor: ISPMColors.white.withOpacity(0.07),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Détails
              Row(
                children: [
                  _MiniStat(
                    icon: Icons.check_circle_outline_rounded,
                    value: '${course.presentCount}',
                    label: 'présences',
                    color: ISPMColors.green,
                  ),
                  const SizedBox(width: 14),
                  _MiniStat(
                    icon: Icons.cancel_outlined,
                    value: '${course.absentCount}',
                    label: 'absences',
                    color: course.absentCount > 0
                        ? ISPMColors.error
                        : ISPMColors.white.withOpacity(0.30),
                  ),
                  const SizedBox(width: 14),
                  _MiniStat(
                    icon: Icons.calendar_today_rounded,
                    value: '${course.totalSessions}',
                    label: 'séances',
                    color: ISPMColors.white.withOpacity(0.35),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 3),
        Text(
          '$value $label',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            color: ISPMColors.white.withOpacity(0.38),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Cours les plus manqués
// ─────────────────────────────────────────────────────────────────────────────

class _MissedCourseRow extends StatelessWidget {
  final CourseAbsenceSummary course;
  const _MissedCourseRow({required this.course});

  @override
  Widget build(BuildContext context) {
    final isHigh = course.absenceRate >= 0.40;
    final color = isHigh ? ISPMColors.error : const Color(0xFFF57C00);
    final pct = (course.absenceRate * 100).toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.event_busy_rounded, size: 17, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.courseTitle,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ISPMColors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  course.fieldOfStudy,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: ISPMColors.white.withOpacity(0.35),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${course.absenceCount} abs.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                '$pct% des séances',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: ISPMColors.white.withOpacity(0.35),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Séparateur de section
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color accent;
  final String? badge;
  const _SectionHeader({required this.label, required this.accent, this.badge});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: ISPMColors.white.withOpacity(0.40),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Divider(
            color: ISPMColors.white.withOpacity(0.07),
            thickness: 0.5,
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.13),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withOpacity(0.28)),
            ),
            child: Text(
              badge!,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: accent,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  État erreur
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  final Color accent;
  final VoidCallback onRetry;
  const _ErrorState({
    required this.message,
    required this.accent,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: ISPMColors.error.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ISPMColors.error.withOpacity(0.28)),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 28,
                color: ISPMColors.error,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Impossible de charger',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ISPMColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: ISPMColors.white.withOpacity(0.38),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accent.withOpacity(0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, size: 15, color: accent),
                    const SizedBox(width: 8),
                    Text(
                      'Réessayer',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
