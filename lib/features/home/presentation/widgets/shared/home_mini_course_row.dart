// lib/features/home/presentation/widgets/shared/home_mini_course_row.dart
//
// Ligne compacte pour la liste de cours du jour.
// Gère les 3 états : past / current / upcoming.
// Utilisé par Professeur et Superviseur.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

// ── Enum état ─────────────────────────────────────────────────────────────────

enum CourseRowState { past, current, upcoming }

// ── Widget ───────────────────────────────────────────────────────────────────

class HomeMiniCourseRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String startTime;
  final String endTime;
  final CourseRowState state;

  /// Couleur d'accent pour l'état "current" (vert prof, bleu superviseur)
  final Color accentColor;

  /// Badge texte custom (ex: "EN COURS", "✓ Validé", "En attente")
  final String? badgeLabel;

  /// Callback tap optionnel
  final VoidCallback? onTap;

  const HomeMiniCourseRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.startTime,
    required this.endTime,
    required this.state,
    this.accentColor = ISPMColors.green,
    this.badgeLabel,
    this.onTap,
  });

  bool get _isCurrent => state == CourseRowState.current;
  bool get _isPast => state == CourseRowState.past;

  Color get _indicatorColor => switch (state) {
    CourseRowState.current => accentColor,
    CourseRowState.past => ISPMColors.white.withOpacity(0.12),
    CourseRowState.upcoming => accentColor.withOpacity(0.40),
  };

  Color get _timeColor => _isCurrent
      ? accentColor
      : ISPMColors.white.withOpacity(_isPast ? 0.25 : 0.75);

  Color get _titleColor =>
      _isCurrent ? ISPMColors.white : ISPMColors.white.withOpacity(_isPast ? 0.28 : 0.85);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _isPast ? 0.50 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 7),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _isCurrent
                ? accentColor.withOpacity(0.10)
                : ISPMColors.grey900,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: _isCurrent
                  ? accentColor.withOpacity(0.35)
                  : ISPMColors.white.withOpacity(0.05),
              width: _isCurrent ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              // ── Indicateur coloré vertical ─────────────────────
              Container(
                width: 3,
                height: 32,
                decoration: BoxDecoration(
                  color: _indicatorColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(width: 11),

              // ── Heure ──────────────────────────────────────────
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
                        color: _timeColor,
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

              // ── Titre + sous-titre ──────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _titleColor,
                        decoration: _isPast ? TextDecoration.lineThrough : null,
                        decorationColor: ISPMColors.white.withOpacity(0.20),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: ISPMColors.white.withOpacity(0.27),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ── Badge ou icône d'état ───────────────────────────
              if (badgeLabel != null)
                _RowBadge(label: badgeLabel!, accent: accentColor, state: state)
              else
                _DefaultStateIcon(state: state, accent: accentColor),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Badge texte personnalisé ──────────────────────────────────────────────────

class _RowBadge extends StatelessWidget {
  final String label;
  final Color accent;
  final CourseRowState state;

  const _RowBadge({required this.label, required this.accent, required this.state});

  @override
  Widget build(BuildContext context) {
    final isCurrent = state == CourseRowState.current;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isCurrent ? accent : accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: isCurrent
            ? null
            : Border.all(color: accent.withOpacity(0.28)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: isCurrent ? ISPMColors.white : accent,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ── Icône d'état par défaut ───────────────────────────────────────────────────

class _DefaultStateIcon extends StatelessWidget {
  final CourseRowState state;
  final Color accent;

  const _DefaultStateIcon({required this.state, required this.accent});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      CourseRowState.past => Icon(
        Icons.check_rounded,
        size: 15,
        color: ISPMColors.white.withOpacity(0.22),
      ),
      CourseRowState.current => Icon(
        Icons.radio_button_checked_rounded,
        size: 14,
        color: accent,
      ),
      CourseRowState.upcoming => Icon(
        Icons.schedule_rounded,
        size: 14,
        color: ISPMColors.white.withOpacity(0.22),
      ),
    };
  }
}