// lib/features/home/presentation/widgets/supervisor/supervisor_scan_card.dart
//
// Carte cours À SCANNER — exclusive Superviseur.
// Affiche : nom du professeur · titre du cours · filière · horaire
//           · barre de progression live · bouton scan direct → AttendanceScannerPage
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../schedule/domain/entities/course.dart';
import '../../../../attendance/presentation/pages/attendance_scanner_page.dart';

// Couleur signature Superviseur
const _kBlue = Color(0xFF378ADD);

class SupervisorScanCard extends StatelessWidget {
  final Course course;

  /// Nom du professeur qui donne ce cours
  final String professorName;

  /// Progression calculée par le parent (0.0 → 1.0)
  final double progress;

  final String Function(DateTime) formatTime;

  /// true → le cours a déjà été scanné (validé)
  final bool isValidated;

  const SupervisorScanCard({
    super.key,
    required this.course,
    required this.professorName,
    required this.progress,
    required this.formatTime,
    this.isValidated = false,
  });

  void _openScanner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AttendanceScannerPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isValidated
              ? ISPMColors.green.withOpacity(0.50)
              : _kBlue.withOpacity(0.55),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isValidated ? ISPMColors.green : _kBlue).withOpacity(0.10),
            blurRadius: 28,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Ligne titre ──────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône
              _ScanCourseIcon(isValidated: isValidated),
              const SizedBox(width: 11),

              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusBadge(isValidated: isValidated),
                    const SizedBox(height: 4),
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ISPMColors.white,
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Bouton scan (ou icône validé)
              isValidated
                  ? _ValidatedIcon()
                  : _ScanButton(onTap: () => _openScanner(context)),
            ],
          ),

          const SizedBox(height: 12),

          // ── Méta : professeur + filière + horaire ────────────────
          _MetaRow(
            professorName: professorName,
            fieldOfStudy: course.fieldOfStudy,
            startTime: formatTime(course.startTime),
            endTime: formatTime(course.endTime),
          ),

          const SizedBox(height: 13),

          // ── Barre de progression ─────────────────────────────────
          _ScanProgressBar(progress: progress, isValidated: isValidated),

          if (!isValidated) ...[
            const SizedBox(height: 6),
            Text(
              'Appuyez sur Scanner pour valider ce cours',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 9,
                color: ISPMColors.white.withOpacity(0.22),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Sous-widgets ──────────────────────────────────────────────────────────────

class _ScanCourseIcon extends StatelessWidget {
  final bool isValidated;
  const _ScanCourseIcon({required this.isValidated});

  @override
  Widget build(BuildContext context) {
    final color = isValidated ? ISPMColors.green : _kBlue;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.30)),
      ),
      child: Icon(
        isValidated ? Icons.check_circle_rounded : Icons.menu_book_rounded,
        size: 18,
        color: color,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isValidated;
  const _StatusBadge({required this.isValidated});

  @override
  Widget build(BuildContext context) {
    final color = isValidated ? ISPMColors.green : _kBlue;
    final label = isValidated ? '✓ VALIDÉ' : 'EN COURS';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: isValidated ? ISPMColors.green : _kBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: ISPMColors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: ISPMColors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ScanButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: _kBlue,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: _kBlue.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.qr_code_scanner_rounded,
                size: 14, color: ISPMColors.white),
            SizedBox(width: 5),
            Text(
              'Scanner',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ISPMColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValidatedIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: ISPMColors.green.withOpacity(0.13),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: ISPMColors.green.withOpacity(0.35)),
      ),
      child: const Icon(
        Icons.check_rounded,
        size: 20,
        color: ISPMColors.green,
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String professorName;
  final String fieldOfStudy;
  final String startTime;
  final String endTime;

  const _MetaRow({
    required this.professorName,
    required this.fieldOfStudy,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 4,
      children: [
        _Chip(icon: Icons.person_outline_rounded, label: professorName),
        _Chip(icon: Icons.group_outlined, label: fieldOfStudy),
        _Chip(
          icon: Icons.access_time_rounded,
          label: '$startTime – $endTime',
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: ISPMColors.white.withOpacity(0.35)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: ISPMColors.white.withOpacity(0.38),
          ),
        ),
      ],
    );
  }
}

class _ScanProgressBar extends StatelessWidget {
  final double progress;
  final bool isValidated;
  const _ScanProgressBar({required this.progress, required this.isValidated});

  @override
  Widget build(BuildContext context) {
    final color = isValidated ? ISPMColors.green : _kBlue;
    final pct = (progress * 100).round();

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: ISPMColors.white.withOpacity(0.07),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 5,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$pct%',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}