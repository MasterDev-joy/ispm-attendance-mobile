// lib/features/home/presentation/widgets/supervisor/supervisor_history_row.dart
//
// Ligne historique de scan — exclusive Superviseur.
// 3 états : validated (vert) · scanning (bleu) · pending (gris) · uncovered (rouge)
// Affiche : prof · titre cours · heure · statut
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

const _kBlue = Color(0xFF378ADD);

// ── Enum statut scan ──────────────────────────────────────────────────────────

enum ScanStatus { validated, scanning, pending, uncovered }

extension ScanStatusX on ScanStatus {
  Color get color => switch (this) {
    ScanStatus.validated => ISPMColors.green,
    ScanStatus.scanning => _kBlue,
    ScanStatus.pending => ISPMColors.white.withOpacity(0.35),
    ScanStatus.uncovered => ISPMColors.error,
  };

  String get label => switch (this) {
    ScanStatus.validated => '✓ Validé',
    ScanStatus.scanning => 'En cours',
    ScanStatus.pending => 'En attente',
    ScanStatus.uncovered => 'Non couvert',
  };

  IconData get icon => switch (this) {
    ScanStatus.validated => Icons.check_circle_rounded,
    ScanStatus.scanning => Icons.radio_button_checked_rounded,
    ScanStatus.pending => Icons.schedule_rounded,
    ScanStatus.uncovered => Icons.cancel_outlined,
  };

  Color get bgColor => switch (this) {
    ScanStatus.validated => ISPMColors.green.withOpacity(0.10),
    ScanStatus.scanning => _kBlue.withOpacity(0.10),
    ScanStatus.pending => ISPMColors.grey900,
    ScanStatus.uncovered => ISPMColors.error.withOpacity(0.08),
  };

  Color get borderColor => switch (this) {
    ScanStatus.validated => ISPMColors.green.withOpacity(0.30),
    ScanStatus.scanning => _kBlue.withOpacity(0.35),
    ScanStatus.pending => ISPMColors.white.withOpacity(0.05),
    ScanStatus.uncovered => ISPMColors.error.withOpacity(0.28),
  };
}

// ── Widget ────────────────────────────────────────────────────────────────────

class SupervisorHistoryRow extends StatelessWidget {
  final String courseTitle;
  final String professorName;
  final String startTime;
  final String endTime;
  final ScanStatus status;
  final VoidCallback? onTap;

  const SupervisorHistoryRow({
    super.key,
    required this.courseTitle,
    required this.professorName,
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
            width: status == ScanStatus.scanning ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // ── Indicateur coloré ─────────────────────────────────
            Container(
              width: 3,
              height: 34,
              decoration: BoxDecoration(
                color: status.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(width: 11),

            // ── Heure ─────────────────────────────────────────────
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
                      color: status == ScanStatus.scanning
                          ? _kBlue
                          : ISPMColors.white.withOpacity(0.75),
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

            // ── Cours + prof ──────────────────────────────────────
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
                      color: status == ScanStatus.uncovered
                          ? ISPMColors.error
                          : ISPMColors.white.withOpacity(
                        status == ScanStatus.pending ? 0.55 : 0.88,
                      ),
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
                          professorName,
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

            // ── Badge statut ──────────────────────────────────────
            _StatusBadge(status: status),
          ],
        ),
      ),
    );
  }
}

// ── Badge statut ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final ScanStatus status;
  const _StatusBadge({required this.status});

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