// lib/features/home/presentation/widgets/shared/home_section_header.dart
//
// Séparateur de section labelisé — identique au style LoginPage.
// Utilisé par les 3 rôles avec couleur d'accent paramétrable.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class HomeSectionHeader extends StatelessWidget {
  /// Texte du label (affiché en majuscules automatiquement)
  final String label;

  /// Icône à gauche du label
  final IconData icon;

  /// Couleur de l'icône (et du badge si présent)
  final Color iconColor;

  /// Badge optionnel à droite (ex: compteur "5")
  final String? badgeText;

  /// Widget entièrement custom à droite (prioritaire sur [badgeText])
  final Widget? trailing;

  const HomeSectionHeader({
    super.key,
    required this.label,
    required this.icon,
    this.iconColor = ISPMColors.green,
    this.badgeText,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icône
        Icon(icon, size: 13, color: iconColor),
        const SizedBox(width: 6),

        // Label
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            color: ISPMColors.white.withOpacity(0.40),
          ),
        ),

        const SizedBox(width: 10),

        // Divider extensible
        const Expanded(
          child: Divider(
            color: Color(0x14FFFFFF), // white 8%
            thickness: 0.5,
          ),
        ),

        // Trailing — widget custom ou badge texte
        if (trailing != null) ...[
          const SizedBox(width: 10),
          trailing!,
        ] else if (badgeText != null) ...[
          const SizedBox(width: 10),
          _SectionBadge(text: badgeText!, color: iconColor),
        ],
      ],
    );
  }
}

// ── Badge compteur ────────────────────────────────────────────────────────────

class _SectionBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _SectionBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.30)),
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
}