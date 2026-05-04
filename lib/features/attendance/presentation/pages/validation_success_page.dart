// lib/features/attendance/presentation/pages/validation_success_page.dart
//
// Page de confirmation de scan — affichée après validation réussie.
// Style dark cohérent. Fond noir + animation elastic + carte prof dark.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';

const _kBlue = Color(0xFF378ADD);

class ValidationSuccessPage extends StatefulWidget {
  final Map<String, dynamic> validationData;
  const ValidationSuccessPage({super.key, required this.validationData});

  @override
  State<ValidationSuccessPage> createState() => _ValidationSuccessPageState();
}

class _ValidationSuccessPageState extends State<ValidationSuccessPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _scaleAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl,
            curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)));

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl,
            curve: const Interval(0.35, 1.0, curve: Curves.easeOut)));

    _slideAnim = Tween<double>(begin: 24.0, end: 0.0).animate(
        CurvedAnimation(parent: _ctrl,
            curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic)));

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final professorName =
        widget.validationData['professor'] ?? 'Professeur inconnu';
    final message =
        widget.validationData['message'] ?? 'Présence validée avec succès';
    final courseTitle =
        widget.validationData['course'] ?? '';
    final timestamp  =
    widget.validationData['timestamp'] as String?;

    return Scaffold(
      backgroundColor: ISPMColors.black,
      body: Stack(
        children: [
          // Background
          Positioned(top: -60, left: -60,
              child: IspmGlowBlob.circle(radius: 200,
                  primaryColor: ISPMColors.greenDark.withOpacity(0.12),
                  secondaryColor: Colors.transparent)),
          Positioned(bottom: -80, right: -60,
              child: IspmGlowBlob.circle(radius: 160,
                  primaryColor: _kBlue.withOpacity(0.08),
                  secondaryColor: Colors.transparent)),
          const Positioned.fill(child: IspmMeshGrid()),

          // Contenu
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // ── Icône succès animée ──────────────────────────
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: _SuccessIcon(),
                  ),

                  const SizedBox(height: 28),

                  // ── Message + carte ──────────────────────────────
                  AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, child) => Opacity(
                      opacity: _fadeAnim.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnim.value),
                        child: child,
                      ),
                    ),
                    child: Column(children: [
                      Text(message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Poppins', fontSize: 20,
                              fontWeight: FontWeight.w700, color: ISPMColors.white,
                              height: 1.3)),
                      const SizedBox(height: 8),
                      Text('La présence a été enregistrée dans le système.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 13,
                              color: ISPMColors.white.withOpacity(0.40),
                              height: 1.5)),

                      const SizedBox(height: 32),

                      // Carte identité professeur
                      _ProfessorCard(
                        professorName: professorName,
                        courseTitle:   courseTitle,
                        timestamp:     timestamp,
                      ),
                    ]),
                  ),

                  const Spacer(),

                  // ── Boutons ──────────────────────────────────────
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(children: [
                      // Scanner un autre
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.qr_code_scanner_rounded,
                              size: 17),
                          label: const Text('Scanner un autre professeur'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kBlue,
                            foregroundColor: ISPMColors.white,
                            minimumSize: const Size.fromHeight(50),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            textStyle: const TextStyle(
                                fontFamily: 'Poppins', fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Retour accueil
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: ISPMColors.white.withOpacity(0.50)),
                        child: const Text('Retour à l\'accueil',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Icône succès ──────────────────────────────────────────────────────────────

class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Halo externe
        Container(
          width: 110, height: 110,
          decoration: BoxDecoration(
            color: ISPMColors.green.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
        ),
        // Cercle principal
        Container(
          width: 88, height: 88,
          decoration: BoxDecoration(
            color: ISPMColors.green.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(
                color: ISPMColors.green.withOpacity(0.50), width: 2),
          ),
          child: const Icon(Icons.check_rounded,
              color: ISPMColors.green, size: 44),
        ),
      ],
    );
  }
}

// ── Carte professeur ──────────────────────────────────────────────────────────

class _ProfessorCard extends StatelessWidget {
  final String  professorName;
  final String  courseTitle;
  final String? timestamp;

  const _ProfessorCard({
    required this.professorName,
    required this.courseTitle,
    this.timestamp,
  });

  String get _initial =>
      professorName.trim().isNotEmpty ? professorName.trim()[0].toUpperCase() : 'P';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ISPMColors.green.withOpacity(0.35), width: 1.5),
        boxShadow: [BoxShadow(
          color: ISPMColors.green.withOpacity(0.08),
          blurRadius: 24, offset: const Offset(0, 6),
        )],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Label
        Text('IDENTITÉ VÉRIFIÉE',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 9,
                fontWeight: FontWeight.w700,
                color: ISPMColors.white.withOpacity(0.38), letterSpacing: 0.8)),
        const SizedBox(height: 14),

        // Identité
        Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
                color: ISPMColors.green.withOpacity(0.13),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ISPMColors.green.withOpacity(0.35))),
            child: Center(child: Text(_initial,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 22,
                    fontWeight: FontWeight.w700, color: ISPMColors.green))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(professorName,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 17,
                        fontWeight: FontWeight.w700, color: ISPMColors.white)),
                const SizedBox(height: 2),
                Text('Professeur', style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 12, color: ISPMColors.white.withOpacity(0.38))),
              ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
                color: ISPMColors.green.withOpacity(0.13),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: ISPMColors.green.withOpacity(0.30))),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.verified_rounded, size: 13, color: ISPMColors.green),
              SizedBox(width: 5),
              Text('Vérifié', style: TextStyle(fontFamily: 'Poppins',
                  fontSize: 11, fontWeight: FontWeight.w600,
                  color: ISPMColors.green)),
            ]),
          ),
        ]),

        // Cours + heure si disponibles
        if (courseTitle.isNotEmpty || timestamp != null) ...[
          const SizedBox(height: 14),
          Divider(color: ISPMColors.white.withOpacity(0.06), height: 0),
          const SizedBox(height: 12),
          Row(children: [
            if (courseTitle.isNotEmpty) Expanded(child: _MetaItem(
              icon: Icons.menu_book_rounded,
              label: 'Cours',
              value: courseTitle,
            )),
            if (timestamp != null) _MetaItem(
              icon: Icons.access_time_rounded,
              label: 'Heure',
              value: timestamp!,
            ),
          ]),
        ],
      ]),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetaItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: ISPMColors.white.withOpacity(0.30)),
      const SizedBox(width: 5),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 9,
            color: ISPMColors.white.withOpacity(0.35))),
        Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12,
            fontWeight: FontWeight.w500, color: ISPMColors.white)),
      ]),
    ]);
  }
}