// lib/features/admin/reports/presentation/pages/reports_page.dart
//
// ✅ AVANT : state is ReportLoaded / state is ReportError (sous-classes Equatable)
//    APRÈS : state.when() / state.whenOrNull() (freezed sealed class)
// ─────────────────────────────────────────────────────────────────────────────
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import '../../domain/entities/report_data.dart';
import '../blocs/report_bloc.dart';
import '../extensions/prof_report_ext.dart';
import '../../../../core/presentation/shared_widgets/admin_shared_widgets.dart';

const _kAmber = Color(0xFFBA7517);

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with SingleTickerProviderStateMixin {
  String _period = 'month';
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    // ✅ Event freezed : ReportEvent.load() au lieu de LoadReportsEvent()
    context.read<ReportBloc>().add(ReportEvent.load(period: _period));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _changePeriod(String period) {
    setState(() => _period = period);
    _animCtrl.forward(from: 0);
    // ✅ Event freezed
    context.read<ReportBloc>().add(ReportEvent.changePeriod(period));
  }

  Future<void> _downloadFile(String data, String format) async {
    try {
      final dir = await getTemporaryDirectory();
      final fileName =
          'reports_${DateTime.now().millisecondsSinceEpoch}.$format';
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(data);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$format téléchargé : ${file.path}'),
            backgroundColor: ISPMColors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: ISPMColors.error,
          ),
        );
      }
    }
  }

  Widget _stagger(int i, Widget child) {
    final start = (0.09 * i).clamp(0.0, 0.7);
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animCtrl,
        curve: Interval(start, 1.0, curve: Curves.easeOut),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ISPMColors.black,
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: IspmGlowBlob.circle(
              radius: 180,
              primaryColor: _kAmber.withOpacity(0.09),
              secondaryColor: Colors.transparent,
            ),
          ),
          Positioned(
            bottom: -80,
            left: -40,
            child: IspmGlowBlob.circle(
              radius: 160,
              primaryColor: ISPMColors.green.withOpacity(0.05),
              secondaryColor: Colors.transparent,
            ),
          ),
          const Positioned.fill(child: IspmMeshGrid()),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                AdminAppBar(
                  title: 'Rapports & exports',
                  subtitle: 'Statistiques globales',
                  onBack: () => Navigator.pop(context),
                ),
                _PeriodSelector(selected: _period, onSelect: _changePeriod),
                const SizedBox(height: 12),

                Expanded(
                  child: BlocConsumer<ReportBloc, ReportState>(
                    // ✅ AVANT : state is ReportExportSuccess / state is ReportExportError
                    //    APRÈS : state.whenOrNull(exportSuccess: ..., exportError: ...)
                    listener: (context, state) {
                      state.whenOrNull(
                        exportSuccess: (report, period, format, data) {
                          _downloadFile(data, format);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Export ${format.toUpperCase()} généré',
                              ),
                              backgroundColor: ISPMColors.green,
                            ),
                          );
                        },
                        exportError: (report, period, message) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: ISPMColors.error,
                            ),
                          );
                        },
                      );
                    },
                    builder: (context, state) => state.when(
                      initial: () => const SizedBox.shrink(),

                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: _kAmber,
                          strokeWidth: 2.5,
                        ),
                      ),

                      error: (message) => AdminErrorPanel(
                        message: message,
                        onRetry: () => context.read<ReportBloc>().add(
                          ReportEvent.load(period: _period),
                        ),
                        accent: _kAmber,
                      ),

                      // loaded + exporting + exportSuccess + exportError
                      // partagent le même builder car tous portent (report, period)
                      loaded: (report, period) =>
                          _buildContent(report, period, isExporting: false),
                      exporting: (report, period) =>
                          _buildContent(report, period, isExporting: true),
                      exportSuccess: (report, period, format, data) =>
                          _buildContent(report, period, isExporting: false),
                      exportError: (report, period, message) =>
                          _buildContent(report, period, isExporting: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    GlobalReport report,
    String period, {
    required bool isExporting,
  }) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
      physics: const BouncingScrollPhysics(),
      children: [
        _stagger(0, _KpiGrid(report: report)),
        const SizedBox(height: 24),
        _stagger(1, _GlobalRateCard(report: report)),
        const SizedBox(height: 24),
        _stagger(
          2,
          _ExportSection(
            exporting: isExporting,
            // ✅ Events freezed
            onExportCsv: () =>
                context.read<ReportBloc>().add(const ReportEvent.export('csv')),
            onExportPdf: () =>
                context.read<ReportBloc>().add(const ReportEvent.export('pdf')),
          ),
        ),
        const SizedBox(height: 24),
        _stagger(
          3,
          _SectionHead(
            label: 'Détail par professeur',
            count: report.perProfessor.length,
          ),
        ),
        const SizedBox(height: 10),
        ...report.perProfessor.asMap().entries.map(
          (e) => _stagger(
            4 + e.key,
            _ProfRow(prof: e.value, animCtrl: _animCtrl, index: e.key),
          ),
        ),
      ],
    );
  }
}

// ── Sélecteur de période ──────────────────────────────────────────────────────

class _PeriodSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _PeriodSelector({required this.selected, required this.onSelect});

  static const _periods = [
    ('week', 'Semaine'),
    ('month', 'Mois'),
    ('semester', 'Semestre'),
    ('all', 'Tout'),
  ];

  @override
  Widget build(BuildContext context) => Padding(
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
          final (val, label) = e;
          final isActive = val == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(val),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isActive ? _kAmber : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: _kAmber.withOpacity(0.28),
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
                    fontSize: 11,
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

// ── KPI Grid, GlobalRateCard, ExportSection, ProfRow ─────────────────────────
// (identiques à l'original — aucun changement nécessaire)

class _KpiGrid extends StatelessWidget {
  final GlobalReport report;
  const _KpiGrid({required this.report});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        Icons.calendar_today_rounded,
        '${report.totalCourses}',
        'Cours total',
        _kAmber,
        false,
      ),
      (
        Icons.check_circle_outline_rounded,
        '${report.validatedCourses}',
        'Validés',
        ISPMColors.green,
        true,
      ),
      (
        Icons.cancel_outlined,
        '${report.uncoveredCourses}',
        'Non couverts',
        report.uncoveredCourses > 0 ? ISPMColors.error : ISPMColors.grey400,
        false,
      ),
      (
        Icons.group_rounded,
        '${report.totalProfessors}',
        'Professeurs',
        _kAmber,
        false,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 9,
      crossAxisSpacing: 9,
      childAspectRatio: 1.9,
      children: items.map((e) {
        final (icon, value, label, color, hi) = e;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: hi ? color.withOpacity(0.12) : ISPMColors.grey900,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hi
                  ? color.withOpacity(0.40)
                  : ISPMColors.white.withOpacity(0.06),
              width: hi ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: hi ? color : ISPMColors.white.withOpacity(0.35),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: hi ? color : ISPMColors.white,
                        ),
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: ISPMColors.white.withOpacity(0.32),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _GlobalRateCard extends StatelessWidget {
  final GlobalReport report;
  const _GlobalRateCard({required this.report});

  Color _rateColor() {
    if (report.validationRate >= 0.85) return ISPMColors.green;
    if (report.validationRate >= 0.65) return const Color(0xFFF57C00);
    return ISPMColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final pct = (report.validationRate * 100).toStringAsFixed(0);
    final color = _rateColor();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.30), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Taux de validation global',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: ISPMColors.white.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                pct,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 52,
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
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _RatePill(
                    '${report.validatedCourses} validés',
                    ISPMColors.green,
                  ),
                  const SizedBox(height: 5),
                  _RatePill(
                    '${report.uncoveredCourses} manqués',
                    ISPMColors.error,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: report.validationRate,
              backgroundColor: ISPMColors.white.withOpacity(0.07),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatePill extends StatelessWidget {
  final String text;
  final Color color;
  const _RatePill(this.text, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.25)),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    ),
  );
}

class _ExportSection extends StatelessWidget {
  final bool exporting;
  final VoidCallback onExportCsv;
  final VoidCallback onExportPdf;
  const _ExportSection({
    required this.exporting,
    required this.onExportCsv,
    required this.onExportPdf,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ISPMColors.grey900,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: ISPMColors.white.withOpacity(0.06)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXPORTER',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: ISPMColors.white.withOpacity(0.40),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _ExportBtn(
                icon: Icons.table_chart_outlined,
                label: 'CSV',
                subtitle: 'Tableau de données',
                color: ISPMColors.green,
                loading: exporting,
                onTap: onExportCsv,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ExportBtn(
                icon: Icons.picture_as_pdf_rounded,
                label: 'PDF',
                subtitle: 'Rapport formaté',
                color: ISPMColors.error,
                loading: exporting,
                onTap: onExportPdf,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _ExportBtn extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final Color color;
  final bool loading;
  final VoidCallback onTap;
  const _ExportBtn({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: loading ? null : onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withOpacity(0.30), width: 1.5),
      ),
      child: Row(
        children: [
          loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: color,
                    strokeWidth: 2,
                  ),
                )
              : Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: ISPMColors.white.withOpacity(0.35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _SectionHead extends StatelessWidget {
  final String label;
  final int count;
  const _SectionHead({required this.label, required this.count});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: ISPMColors.white.withOpacity(0.38),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Divider(
          color: ISPMColors.white.withOpacity(0.07),
          thickness: 0.5,
        ),
      ),
      const SizedBox(width: 10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: _kAmber.withOpacity(0.13),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _kAmber.withOpacity(0.28)),
        ),
        child: Text(
          '$count',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: _kAmber,
          ),
        ),
      ),
    ],
  );
}

class _ProfRow extends StatelessWidget {
  final ProfReport prof;
  final AnimationController animCtrl;
  final int index;
  const _ProfRow({
    required this.prof,
    required this.animCtrl,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final color = prof.rateColor; // via extension présentation
    final pct = (prof.rate * 100).toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ISPMColors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: color.withOpacity(0.28)),
                ),
                child: Center(
                  child: Text(
                    prof.name.isNotEmpty ? prof.name[0].toUpperCase() : 'P',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  prof.name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ISPMColors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$pct%',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: animCtrl,
            builder: (_, __) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: animCtrl.value * prof.rate,
                backgroundColor: ISPMColors.white.withOpacity(0.07),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 5,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 11,
                color: ISPMColors.green,
              ),
              const SizedBox(width: 3),
              Text(
                '${prof.validated}/${prof.courses} cours validés',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: ISPMColors.white.withOpacity(0.38),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
