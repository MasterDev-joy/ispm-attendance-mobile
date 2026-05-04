// lib/features/home/presentation/widgets/shared/home_alert_card.dart
//
// Carte d'alerte colorée (error / warning / info).
// Utilisée par les 3 rôles :
//   • Superviseur → cours non couvert
//   • Admin       → anomalies globales
//   • Professeur  → erreur chargement planning
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

// ── Enum sévérité ─────────────────────────────────────────────────────────────

enum AlertSeverity { error, warning, info, success }

extension AlertSeverityX on AlertSeverity {
  Color get color => switch (this) {
    AlertSeverity.error => ISPMColors.error,
    AlertSeverity.warning => const Color(0xFFF57C00),
    AlertSeverity.info => const Color(0xFF378ADD),
    AlertSeverity.success => ISPMColors.green,
  };

  IconData get defaultIcon => switch (this) {
    AlertSeverity.error => Icons.error_outline_rounded,
    AlertSeverity.warning => Icons.warning_amber_rounded,
    AlertSeverity.info => Icons.info_outline_rounded,
    AlertSeverity.success => Icons.check_circle_outline_rounded,
  };
}

// ── Widget ───────────────────────────────────────────────────────────────────

class HomeAlertCard extends StatelessWidget {
  final AlertSeverity severity;
  final String message;

  /// Icône custom (utilise le défaut de la sévérité si null)
  final IconData? icon;

  /// Label du bouton d'action (ex: "Réessayer", "Voir")
  final String? actionLabel;
  final VoidCallback? onAction;

  const HomeAlertCard({
    super.key,
    required this.severity,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final color = severity.color;
    final effectiveIcon = icon ?? severity.defaultIcon;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.28)),
      ),
      child: Row(
        children: [
          // Icône
          Icon(effectiveIcon, size: 18, color: color),

          const SizedBox(width: 10),

          // Message
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
                height: 1.4,
              ),
            ),
          ),

          // Action optionnelle
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onAction,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withOpacity(0.30)),
                ),
                child: Text(
                  actionLabel!,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Variante chargement vide ──────────────────────────────────────────────────

/// Carte "état vide" — aucun cours, aucune donnée à afficher
class HomeEmptyCard extends StatelessWidget {
  final String message;
  final IconData icon;

  const HomeEmptyCard({
    super.key,
    required this.message,
    this.icon = Icons.event_busy_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ISPMColors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: ISPMColors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              size: 18,
              color: ISPMColors.white.withOpacity(0.22),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: ISPMColors.white.withOpacity(0.32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Variante chargement ───────────────────────────────────────────────────────

/// Carte placeholder pendant le chargement
class HomeLoadingCard extends StatelessWidget {
  final double height;
  final Color accentColor;

  const HomeLoadingCard({
    super.key,
    this.height = 90,
    this.accentColor = ISPMColors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ISPMColors.white.withOpacity(0.06)),
      ),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            color: accentColor,
            strokeWidth: 2.5,
          ),
        ),
      ),
    );
  }
}