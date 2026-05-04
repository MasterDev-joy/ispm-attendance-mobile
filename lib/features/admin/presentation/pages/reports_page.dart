// lib/features/admin/presentation/pages/reports_page.dart
//
// Page Rapports & exports — Admin uniquement.
// Affiche les statistiques globales et permet l'export CSV / PDF.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import 'users_page.dart' show AdminAppBar, ErrorPanel;

const _kAmber = Color(0xFFBA7517);

// ── Modèle rapport ────────────────────────────────────────────────────────────

class _GlobalReport {
  final int    totalCourses;
  final int    validatedCourses;
  final int    uncoveredCourses;
  final int    totalProfessors;
  final int    totalSupervisors;
  final double validationRate;
  final List<_ProfReport> perProfessor;

  const _GlobalReport({
    required this.totalCourses,    required this.validatedCourses,
    required this.uncoveredCourses, required this.totalProfessors,
    required this.totalSupervisors, required this.validationRate,
    required this.perProfessor,
  });

  factory _GlobalReport.fromJson(Map<String, dynamic> j) => _GlobalReport(
    totalCourses:     (j['totalCourses']     ?? 0) as int,
    validatedCourses: (j['validatedCourses'] ?? 0) as int,
    uncoveredCourses: (j['uncoveredCourses'] ?? 0) as int,
    totalProfessors:  (j['totalProfessors']  ?? 0) as int,
    totalSupervisors: (j['totalSupervisors'] ?? 0) as int,
    validationRate:   ((j['validationRate']  ?? 0.0) as num).toDouble(),
    perProfessor:     (j['perProfessor'] as List? ?? [])
        .map((p) => _ProfReport.fromJson(p)).toList(),
  );

  // Mock pour dev
  factory _GlobalReport.mock() => _GlobalReport(
    totalCourses: 48, validatedCourses: 39, uncoveredCourses: 9,
    totalProfessors: 6, totalSupervisors: 3, validationRate: 0.81,
    perProfessor: [
      _ProfReport(name: 'Rakoto Fifaliana', courses: 12, validated: 11, rate: 0.92),
      _ProfReport(name: 'Rasoa Miandra', courses: 10, validated: 8,  rate: 0.80),
      _ProfReport(name: 'Rabe Hery',    courses: 9,  validated: 7,  rate: 0.78),
      _ProfReport(name: 'Ravelo Niry',  courses: 8,  validated: 5,  rate: 0.63),
      _ProfReport(name: 'Rakoton. S.',  courses: 5,  validated: 5,  rate: 1.00),
      _ProfReport(name: 'Ramarol. L.',  courses: 4,  validated: 3,  rate: 0.75),
    ],
  );
}

class _ProfReport {
  final String name;
  final int    courses;
  final int    validated;
  final double rate;
  const _ProfReport({required this.name, required this.courses,
    required this.validated, required this.rate});

  factory _ProfReport.fromJson(Map<String, dynamic> j) => _ProfReport(
    name:      j['name']      ?? '',
    courses:   (j['courses']   ?? 0) as int,
    validated: (j['validated'] ?? 0) as int,
    rate:      ((j['rate']     ?? 0.0) as num).toDouble(),
  );

  Color get rateColor {
    if (rate >= 0.85) return ISPMColors.green;
    if (rate >= 0.65) return const Color(0xFFF57C00);
    return ISPMColors.error;
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with SingleTickerProviderStateMixin {

  _GlobalReport? _report;
  bool   _loading     = true;
  bool   _exporting   = false;
  String _error       = '';
  String _period      = 'month';
  late   AnimationController _animCtrl;

  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 700))..forward();
    _loadReport();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<String?> get _token => _storage.read(key: 'jwt_token');

  Future<void> _loadReport() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final token = await _token;
      final res   = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/admin/reports?period=$_period'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        setState(() {
          _report  = _GlobalReport.fromJson(jsonDecode(res.body));
          _loading = false;
        });
        _animCtrl.forward(from: 0);
      } else {
        // Fallback mock pour dev
        setState(() { _report = _GlobalReport.mock(); _loading = false; });
      }
    } catch (_) {
      // Fallback mock si pas d'API
      setState(() { _report = _GlobalReport.mock(); _loading = false; });
    }
  }

  Future<void> _export(String format) async {
    setState(() => _exporting = true);
    try {
      final token = await _token;
      final res   = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/admin/reports/export?format=$format&period=$_period'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (mounted) {
        if (res.statusCode == 200) {
          _showSuccess('Export $format généré avec succès');
        } else {
          _showError('Erreur lors de l\'export');
        }
      }
    } catch (e) {
      if (mounted) _showError('Export non disponible : vérifiez le serveur');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  void _showSuccess(String msg) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, style: const TextStyle(fontFamily: 'Poppins')),
          backgroundColor: ISPMColors.green, behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, style: const TextStyle(fontFamily: 'Poppins')),
          backgroundColor: ISPMColors.error, behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));

  Widget _stagger(int i, Widget child) {
    final start = (0.09 * i).clamp(0.0, 0.7);
    return FadeTransition(
      opacity: CurvedAnimation(parent: _animCtrl,
          curve: Interval(start, 1.0, curve: Curves.easeOut)),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ISPMColors.black,
      body: Stack(children: [
        Positioned(top: -60, right: -60,
            child: IspmGlowBlob.circle(radius: 180,
                primaryColor: _kAmber.withOpacity(0.09),
                secondaryColor: Colors.transparent)),
        Positioned(bottom: -80, left: -40,
            child: IspmGlowBlob.circle(radius: 160,
                primaryColor: ISPMColors.green.withOpacity(0.05),
                secondaryColor: Colors.transparent)),
        const Positioned.fill(child: IspmMeshGrid()),

        SafeArea(bottom: false, child: Column(children: [
          // AppBar
          AdminAppBar(
            title: 'Rapports & exports',
            subtitle: 'Statistiques globales',
            onBack: () => Navigator.pop(context),
          ),

          // Sélecteur période
          _PeriodSelector(
            selected: _period,
            onSelect: (p) { setState(() => _period = p); _loadReport(); },
          ),

          const SizedBox(height: 12),

          Expanded(child: _loading
              ? const Center(child: CircularProgressIndicator(
              color: _kAmber, strokeWidth: 2.5))
              : _error.isNotEmpty
              ? ErrorPanel(message: _error, onRetry: _loadReport, accent: _kAmber)
              : _report == null
              ? const SizedBox()
              : ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
              physics: const BouncingScrollPhysics(),
              children: [
                // KPIs
                _stagger(0, _KpiGrid(report: _report!)),
                const SizedBox(height: 24),

                // Barre taux global
                _stagger(1, _GlobalRateCard(report: _report!)),
                const SizedBox(height: 24),

                // Export
                _stagger(2, _ExportSection(
                  exporting: _exporting,
                  onExportCsv: () => _export('csv'),
                  onExportPdf: () => _export('pdf'),
                )),
                const SizedBox(height: 24),

                // Par professeur
                _stagger(3, _SectionHead(label: 'Détail par professeur',
                    count: _report!.perProfessor.length)),
                const SizedBox(height: 10),
                ..._report!.perProfessor.asMap().entries.map((e) =>
                    _stagger(4 + e.key,
                        _ProfRow(prof: e.value, animCtrl: _animCtrl,
                            index: e.key))),
              ])),
        ])),
      ]),
    );
  }
}

// ── Sélecteur période ─────────────────────────────────────────────────────────

class _PeriodSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _PeriodSelector({required this.selected, required this.onSelect});

  static const _periods = [
    ('week',     'Semaine'),
    ('month',    'Mois'),
    ('semester', 'Semestre'),
    ('all',      'Tout'),
  ];

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: ISPMColors.grey900, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ISPMColors.white.withOpacity(0.06))),
        child: Row(children: _periods.map((e) {
          final (val, label) = e;
          final isActive = val == selected;
          return Expanded(child: GestureDetector(
              onTap: () => onSelect(val),
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                      color: isActive ? _kAmber : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isActive ? [BoxShadow(color: _kAmber.withOpacity(0.28),
                          blurRadius: 8, offset: const Offset(0, 2))] : null),
                  alignment: Alignment.center,
                  child: Text(label, style: TextStyle(fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? ISPMColors.white : ISPMColors.white.withOpacity(0.40))))));
        }).toList()),
      ));
}

// ── Grille KPIs ───────────────────────────────────────────────────────────────

class _KpiGrid extends StatelessWidget {
  final _GlobalReport report;
  const _KpiGrid({required this.report});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.calendar_today_rounded, '${report.totalCourses}',
      'Cours total', _kAmber, false),
      (Icons.check_circle_outline_rounded, '${report.validatedCourses}',
      'Validés', ISPMColors.green, true),
      (Icons.cancel_outlined, '${report.uncoveredCourses}',
      'Non couverts',
      report.uncoveredCourses > 0 ? ISPMColors.error : ISPMColors.grey400,
      false),
      (Icons.group_rounded, '${report.totalProfessors}',
      'Professeurs', _kAmber, false),
    ];

    return GridView.count(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2, mainAxisSpacing: 9, crossAxisSpacing: 9,
        childAspectRatio: 1.9,
        children: items.map((e) {
          final (icon, value, label, color, hi) = e;
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                  color: hi ? color.withOpacity(0.12) : ISPMColors.grey900,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: hi ? color.withOpacity(0.40) : ISPMColors.white.withOpacity(0.06),
                      width: hi ? 1.5 : 1.0)),
              child: Row(children: [
                Icon(icon, size: 18,
                    color: hi ? color : ISPMColors.white.withOpacity(0.35)),
                const SizedBox(width: 10),
                Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(value, style: TextStyle(
                              fontFamily: 'Poppins', fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: hi ? color : ISPMColors.white))),
                      Text(label, style: TextStyle(fontFamily: 'Poppins',
                          fontSize: 10, color: ISPMColors.white.withOpacity(0.32))),
                    ])),
              ]));
        }).toList());
  }
}

// ── Carte taux global ─────────────────────────────────────────────────────────

class _GlobalRateCard extends StatelessWidget {
  final _GlobalReport report;
  const _GlobalRateCard({required this.report});

  Color get _rateColor {
    if (report.validationRate >= 0.85) return ISPMColors.green;
    if (report.validationRate >= 0.65) return const Color(0xFFF57C00);
    return ISPMColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final pct   = (report.validationRate * 100).toStringAsFixed(0);
    final color = _rateColor;

    return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: ISPMColors.grey900, borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withOpacity(0.30), width: 1.5),
            boxShadow: [BoxShadow(color: color.withOpacity(0.07),
                blurRadius: 20, offset: const Offset(0, 5))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Taux de validation global',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12,
                  color: ISPMColors.white.withOpacity(0.45))),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(pct, style: TextStyle(fontFamily: 'Poppins', fontSize: 52,
                fontWeight: FontWeight.w800, color: color, letterSpacing: -2)),
            Padding(padding: const EdgeInsets.only(bottom: 8),
                child: Text('%', style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 24, fontWeight: FontWeight.w700, color: color))),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              _RatePill('${report.validatedCourses} validés', ISPMColors.green),
              const SizedBox(height: 5),
              _RatePill('${report.uncoveredCourses} manqués', ISPMColors.error),
            ]),
          ]),
          const SizedBox(height: 14),
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                  value: report.validationRate,
                  backgroundColor: ISPMColors.white.withOpacity(0.07),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8)),
        ]));
  }
}

class _RatePill extends StatelessWidget {
  final String text;
  final Color  color;
  const _RatePill(this.text, this.color);

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.25))),
      child: Text(text, style: TextStyle(fontFamily: 'Poppins', fontSize: 11,
          fontWeight: FontWeight.w600, color: color)));
}

// ── Section export ────────────────────────────────────────────────────────────

class _ExportSection extends StatelessWidget {
  final bool exporting;
  final VoidCallback onExportCsv;
  final VoidCallback onExportPdf;
  const _ExportSection({required this.exporting,
    required this.onExportCsv, required this.onExportPdf});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: ISPMColors.grey900, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ISPMColors.white.withOpacity(0.06))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('EXPORTER', style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
              fontWeight: FontWeight.w600, letterSpacing: 0.8,
              color: ISPMColors.white.withOpacity(0.40))),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _ExportBtn(
                icon: Icons.table_chart_outlined,
                label: 'CSV',
                subtitle: 'Tableau de données',
                color: ISPMColors.green,
                loading: exporting,
                onTap: onExportCsv)),
            const SizedBox(width: 10),
            Expanded(child: _ExportBtn(
                icon: Icons.picture_as_pdf_rounded,
                label: 'PDF',
                subtitle: 'Rapport formaté',
                color: ISPMColors.error,
                loading: exporting,
                onTap: onExportPdf)),
          ]),
        ]));
  }
}

class _ExportBtn extends StatelessWidget {
  final IconData icon;
  final String   label, subtitle;
  final Color    color;
  final bool     loading;
  final VoidCallback onTap;
  const _ExportBtn({required this.icon, required this.label,
    required this.subtitle, required this.color,
    required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          decoration: BoxDecoration(
              color: color.withOpacity(0.10), borderRadius: BorderRadius.circular(13),
              border: Border.all(color: color.withOpacity(0.30), width: 1.5)),
          child: Row(children: [
            loading
                ? SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(color: color, strokeWidth: 2))
                : Icon(icon, size: 20, color: color),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 14,
                      fontWeight: FontWeight.w700, color: color)),
                  Text(subtitle, style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
                      color: ISPMColors.white.withOpacity(0.35))),
                ])),
          ])));
}

// ── Ligne prof ────────────────────────────────────────────────────────────────

class _SectionHead extends StatelessWidget {
  final String label;
  final int    count;
  const _SectionHead({required this.label, required this.count});

  @override
  Widget build(BuildContext context) => Row(children: [
    Text(label.toUpperCase(), style: TextStyle(fontFamily: 'Poppins',
        fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.8,
        color: ISPMColors.white.withOpacity(0.38))),
    const SizedBox(width: 10),
    Expanded(child: Divider(
        color: ISPMColors.white.withOpacity(0.07), thickness: 0.5)),
    const SizedBox(width: 10),
    Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: _kAmber.withOpacity(0.13),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kAmber.withOpacity(0.28))),
        child: Text('$count', style: const TextStyle(fontFamily: 'Poppins',
            fontSize: 10, fontWeight: FontWeight.w600, color: _kAmber))),
  ]);
}

class _ProfRow extends StatelessWidget {
  final _ProfReport prof;
  final AnimationController animCtrl;
  final int index;
  const _ProfRow({required this.prof, required this.animCtrl,
    required this.index});

  @override
  Widget build(BuildContext context) {
    final color = prof.rateColor;
    final pct   = (prof.rate * 100).toStringAsFixed(0);

    return Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: ISPMColors.grey900, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ISPMColors.white.withOpacity(0.06))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            // Avatar
            Container(width: 36, height: 36,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: color.withOpacity(0.28))),
                child: Center(child: Text(
                    prof.name.isNotEmpty ? prof.name[0].toUpperCase() : 'P',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 15,
                        fontWeight: FontWeight.w700, color: color)))),
            const SizedBox(width: 11),
            Expanded(child: Text(prof.name,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 14,
                    fontWeight: FontWeight.w600, color: ISPMColors.white),
                overflow: TextOverflow.ellipsis)),
            // Taux
            Text('$pct%', style: TextStyle(fontFamily: 'Poppins', fontSize: 18,
                fontWeight: FontWeight.w800, color: color)),
          ]),
          const SizedBox(height: 10),
          // Barre
          AnimatedBuilder(
              animation: animCtrl,
              builder: (_, __) => ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                      value: animCtrl.value * prof.rate,
                      backgroundColor: ISPMColors.white.withOpacity(0.07),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 5))),
          const SizedBox(height: 6),
          // Compteurs
          Row(children: [
            Icon(Icons.check_circle_outline_rounded, size: 11,
                color: ISPMColors.green),
            const SizedBox(width: 3),
            Text('${prof.validated}/${prof.courses} cours validés',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 11,
                    color: ISPMColors.white.withOpacity(0.38))),
          ]),
        ]));
  }
}