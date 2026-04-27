// lib/features/stats/presentation/pages/stats_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../blocs/stats_bloc.dart';
import '../blocs/stats_event.dart';
import '../blocs/stats_state.dart';
import '../../domain/entities/stats_data.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  StatsPeriod _selectedPeriod = StatsPeriod.month;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    context.read<StatsBloc>().add(const LoadStatsEvent());
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _changePeriod(StatsPeriod p) {
    setState(() => _selectedPeriod = p);
    _animCtrl.reset();
    context.read<StatsBloc>().add(ChangePeriodEvent(p));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F6),
      appBar: AppBar(
        title: const Text('Mes statistiques'),
        backgroundColor: ISPMColors.white,
        foregroundColor: ISPMColors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          _PeriodSelector(
              selected: _selectedPeriod, onChanged: _changePeriod),
          Expanded(
            child: BlocConsumer<StatsBloc, StatsState>(
              listener: (_, state) {
                if (state is StatsLoaded) {
                  _animCtrl.forward(from: 0);
                }
              },
              builder: (_, state) {
                if (state is StatsLoading || state is StatsInitial) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: ISPMColors.green));
                }
                if (state is StatsError) {
                  return Center(
                    child: Text(state.message,
                        style:
                            const TextStyle(color: ISPMColors.error)),
                  );
                }
                if (state is StatsLoaded) {
                  return FadeTransition(
                    opacity: _fadeAnim,
                    child: _StatsBody(
                        data: state.data, animCtrl: _animCtrl),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sélecteur de période ───────────────────────────────────────────────────

class _PeriodSelector extends StatelessWidget {
  final StatsPeriod selected;
  final ValueChanged<StatsPeriod> onChanged;

  const _PeriodSelector(
      {required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final periods = [
      (StatsPeriod.month, 'Ce mois'),
      (StatsPeriod.semester, 'Semestre'),
      (StatsPeriod.all, 'Tout'),
    ];
    return Container(
      color: ISPMColors.white,
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: periods.map((entry) {
          final (period, label) = entry;
          final active = period == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: active
                      ? ISPMColors.green
                      : ISPMColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    color: active
                        ? ISPMColors.white
                        : ISPMColors.grey600,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Corps des stats ────────────────────────────────────────────────────────

class _StatsBody extends StatelessWidget {
  final GlobalStats data;
  final AnimationController animCtrl;

  const _StatsBody({required this.data, required this.animCtrl});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _GlobalSummaryCard(data: data),
        const SizedBox(height: 20),
        const _SectionTitle(title: 'Présence par cours'),
        const SizedBox(height: 8),
        ...data.perCourse.map((c) => _CourseBar(
              course: c,
              animCtrl: animCtrl,
            )),
        if (data.mostMissed.isNotEmpty) ...[
          const SizedBox(height: 20),
          const _SectionTitle(title: 'Cours les plus manqués'),
          const SizedBox(height: 8),
          ...data.mostMissed
              .map((c) => _MissedCourseCard(course: c)),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

// ── Carte résumé global ────────────────────────────────────────────────────

class _GlobalSummaryCard extends StatelessWidget {
  final GlobalStats data;
  const _GlobalSummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final pct = (data.globalPresenceRate * 100).toStringAsFixed(0);
    final color = data.globalPresenceRate >= 0.80
        ? ISPMColors.success
        : data.globalPresenceRate >= 0.60
            ? ISPMColors.warning
            : ISPMColors.error;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ISPMColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Taux de présence global',
              style: TextStyle(
                  color: ISPMColors.grey600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('$pct%',
                  style: TextStyle(
                      color: color,
                      fontSize: 42,
                      fontWeight: FontWeight.w800)),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StatChip(
                      label: '${data.presentCount} présences',
                      color: ISPMColors.success),
                  const SizedBox(height: 4),
                  _StatChip(
                      label: '${data.absentCount} absences',
                      color: ISPMColors.error),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: data.globalPresenceRate,
              backgroundColor: ISPMColors.grey100,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text('${data.totalSessions} séances au total',
              style: const TextStyle(
                  color: ISPMColors.grey400, fontSize: 12)),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600)),
    );
  }
}

// ── Barre par cours ────────────────────────────────────────────────────────

class _CourseBar extends StatelessWidget {
  final CourseStats course;
  final AnimationController animCtrl;

  const _CourseBar({required this.course, required this.animCtrl});

  Color get _barColor {
    switch (course.risk) {
      case PresenceRisk.good:
        return ISPMColors.success;
      case PresenceRisk.warning:
        return ISPMColors.warning;
      case PresenceRisk.critical:
        return ISPMColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pct = (course.presenceRate * 100).toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ISPMColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.courseTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: ISPMColors.black)),
                    Text(course.fieldOfStudy,
                        style: const TextStyle(
                            color: ISPMColors.grey400,
                            fontSize: 12)),
                  ],
                ),
              ),
              Text('$pct%',
                  style: TextStyle(
                      color: _barColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: animCtrl,
            builder: (_, __) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: animCtrl.value * course.presenceRate,
                backgroundColor: ISPMColors.grey100,
                valueColor:
                    AlwaysStoppedAnimation<Color>(_barColor),
                minHeight: 7,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${course.presentCount} présent${course.presentCount > 1 ? 's' : ''} '
            '· ${course.absentCount} absent${course.absentCount > 1 ? 's' : ''} '
            '· ${course.totalSessions} séances',
            style: const TextStyle(
                color: ISPMColors.grey400, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ── Cours les plus manqués ─────────────────────────────────────────────────

class _MissedCourseCard extends StatelessWidget {
  final CourseAbsenceSummary course;
  const _MissedCourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final pct = (course.absenceRate * 100).toStringAsFixed(0);
    final isHigh = course.absenceRate >= 0.40;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ISPMColors.white,
        borderRadius: BorderRadius.circular(12),
        border: isHigh
            ? Border.all(color: ISPMColors.error.withOpacity(0.3))
            : null,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: (isHigh ? ISPMColors.error : ISPMColors.warning)
                  .withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy_rounded,
              color: isHigh ? ISPMColors.error : ISPMColors.warning,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course.courseTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: ISPMColors.black)),
                Text(course.fieldOfStudy,
                    style: const TextStyle(
                        color: ISPMColors.grey400, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${course.absenceCount} absence${course.absenceCount > 1 ? 's' : ''}',
                style: TextStyle(
                    color: isHigh ? ISPMColors.error : ISPMColors.warning,
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
              ),
              Text('$pct% des séances',
                  style: const TextStyle(
                      color: ISPMColors.grey400, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Titre de section ───────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: ISPMColors.black));
  }
}
