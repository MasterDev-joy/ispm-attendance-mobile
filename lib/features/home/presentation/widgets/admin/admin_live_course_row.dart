// lib/features/home/presentation/widgets/admin/admin_live_course_row.dart
//
// Ligne cours LIVE — exclusive Admin.
// Vue globale de tous les cours en temps réel de l'établissement.
// 3 états de couverture : covered (vert) · active (bleu) · uncovered (rouge)
// Affiche : titre cours · nom prof · filière · heure · statut couverture
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

const _kBlue   = Color(0xFF378ADD);
const _kAmber  = Color(0xFFBA7517);

// ── Enum couverture ───────────────────────────────────────────────────────────

enum CoverageStatus { covered, active, uncovered, upcoming }

extension CoverageStatusX on CoverageStatus {
  Color get color => switch (this) {
    CoverageStatus.covered   => ISPMColors.green,
    CoverageStatus.active    => _kBlue,
    CoverageStatus.uncovered => ISPMColors.error,
    CoverageStatus.upcoming  => ISPMColors.white.withOpacity(0.30),
  };

  String get label => switch (this) {
    CoverageStatus.covered   => '✓ Couvert',
    CoverageStatus.active    => 'En cours',
    CoverageStatus.uncovered => 'Non couvert',
    CoverageStatus.upcoming  => 'À venir',
  };

  IconData get icon => switch (this) {
    CoverageStatus.covered   => Icons.verified_rounded,
    CoverageStatus.active    => Icons.radio_button_checked_rounded,
    CoverageStatus.uncovered => Icons.cancel_outlined,
    CoverageStatus.upcoming  => Icons.schedule_rounded,
  };

  Color get bgColor => switch (this) {
    CoverageStatus.covered   => ISPMColors.green.withOpacity(0.08),
    CoverageStatus.active    => _kBlue.withOpacity(0.08),
    CoverageStatus.uncovered => ISPMColors.error.withOpacity(0.07),
    CoverageStatus.upcoming  => ISPMColors.grey900,
  };

  Color get borderColor => switch (this) {
    CoverageStatus.covered   => ISPMColors.green.withOpacity(0.25),
    CoverageStatus.active    => _kBlue.withOpacity(0.30),
    CoverageStatus.uncovered => ISPMColors.error.withOpacity(0.28),
    CoverageStatus.upcoming  => ISPMColors.white.withOpacity(0.05),
  };
}

// ── Widget ────────────────────────────────────────────────────────────────────

class AdminLiveCourseRow extends StatelessWidget {
  final String courseTitle;
  final String professorName;
  final String fieldOfStudy;
  final String startTime;
  final String endTime;
  final CoverageStatus status;

  /// Callback tap — ouvre le détail du cours si disponible
  final VoidCallback? onTap;

  const AdminLiveCourseRow({
    super.key,
    required this.courseTitle,
    required this.professorName,
    required this.fieldOfStudy,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 7),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: status.bgColor,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: status.borderColor,
            width: status == CoverageStatus.active ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // ── Indicateur coloré vertical ─────────────────────────
            Container(
              width: 3,
              height: 36,
              decoration: BoxDecoration(
                color: status.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(width: 11),

            // ── Heure ──────────────────────────────────────────────
            SizedBox(
              width: 36,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    startTime,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: status == CoverageStatus.active
                          ? _kBlue
                          : ISPMColors.white.withOpacity(0.70),
                    ),
                  ),
                  Text(
                    endTime,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 9,
                      color: ISPMColors.white.withOpacity(0.25),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ── Infos cours ────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseTitle,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: status == CoverageStatus.uncovered
                          ? ISPMColors.error
                          : ISPMColors.white.withOpacity(0.88),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 10,
                        color: ISPMColors.white.withOpacity(0.28),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '$professorName · $fieldOfStudy',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            color: ISPMColors.white.withOpacity(0.28),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── Badge statut ───────────────────────────────────────
            _CoverageBadge(status: status),

            // Chevron si tappable
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 14,
                color: ISPMColors.white.withOpacity(0.20),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Badge couverture ──────────────────────────────────────────────────────────

class _CoverageBadge extends StatelessWidget {
  final CoverageStatus status;
  const _CoverageBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: status.color.withOpacity(0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 10, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}