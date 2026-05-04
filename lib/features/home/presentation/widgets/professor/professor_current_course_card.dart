// lib/features/home/presentation/widgets/professor/professor_current_course_card.dart
//
// Carte cours EN COURS — exclusive Professeur.
// Affiche : titre · filière · horaire · barre de progression live
//           · bouton QR → QrGeneratorPage
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../schedule/domain/entities/course.dart';
import '../../../../attendance/presentation/pages/qr_generator_page.dart';

class ProfessorCurrentCourseCard extends StatelessWidget {
  final Course course;

  /// Progression calculée par le parent (0.0 → 1.0)
  final double progress;

  final String Function(DateTime) formatTime;

  const ProfessorCurrentCourseCard({
    super.key,
    required this.course,
    required this.progress,
    required this.formatTime,
  });

  void _openQr(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QrGeneratorPage(course: course)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openQr(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ISPMColors.grey900,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: ISPMColors.green.withOpacity(0.55),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: ISPMColors.green.withOpacity(0.10),
              blurRadius: 28,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Ligne titre ────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icône cours
                _CourseIcon(),

                const SizedBox(width: 11),

                // Badge + titre
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _EnCoursBadge(),
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

                // Bouton QR
                _QrButton(onTap: () => _openQr(context)),
              ],
            ),

            const SizedBox(height: 11),

            // ── Méta : filière + horaire ───────────────────────────
            Row(
              children: [
                _MetaChip(
                  icon: Icons.group_outlined,
                  label: course.fieldOfStudy,
                ),
                const SizedBox(width: 14),
                _MetaChip(
                  icon: Icons.access_time_rounded,
                  label:
                  '${formatTime(course.startTime)} – ${formatTime(course.endTime)}',
                ),
              ],
            ),

            const SizedBox(height: 13),

            // ── Barre de progression ───────────────────────────────
            _ProgressBar(progress: progress),

            const SizedBox(height: 6),

            Text(
              'Appuyez pour générer le QR de présence',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 9,
                color: ISPMColors.white.withOpacity(0.22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sous-widgets internes ─────────────────────────────────────────────────────

class _CourseIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: ISPMColors.green.withOpacity(0.13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ISPMColors.green.withOpacity(0.30)),
      ),
      child: const Icon(
        Icons.menu_book_rounded,
        size: 18,
        color: ISPMColors.green,
      ),
    );
  }
}

class _EnCoursBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: ISPMColors.green,
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
          const Text(
            'EN COURS',
            style: TextStyle(
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

class _QrButton extends StatelessWidget {
  final VoidCallback onTap;
  const _QrButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: ISPMColors.green.withOpacity(0.13),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: ISPMColors.green.withOpacity(0.35)),
        ),
        child: const Icon(
          Icons.qr_code_rounded,
          size: 18,
          color: ISPMColors.green,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

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
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: ISPMColors.white.withOpacity(0.07),
                  valueColor:
                  const AlwaysStoppedAnimation<Color>(ISPMColors.green),
                  minHeight: 5,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '$pct%',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ISPMColors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          pct < 50
              ? 'Début de séance'
              : pct < 80
              ? 'Séance en cours'
              : 'Fin de séance approche',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 9,
            color: ISPMColors.green.withOpacity(0.55),
          ),
        ),
      ],
    );
  }
}