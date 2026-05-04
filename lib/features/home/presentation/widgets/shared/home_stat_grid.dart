// lib/features/home/presentation/widgets/shared/home_stat_grid.dart
//
// Grille 2×2 de métriques statistiques.
// Entièrement générique : reçoit une List<StatCardData> (4 éléments).
// Chaque rôle construit sa propre liste de StatCardData.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

// ── Modèle de données ─────────────────────────────────────────────────────────

class StatCardData {
  /// Valeur principale affichée en grand (ex: "5", "EN COURS", "40%")
  final String value;

  /// Label descriptif sous la valeur
  final String label;

  /// Icône
  final IconData icon;

  /// Couleur d'accent (icône + texte si highlighted)
  final Color accentColor;

  /// Carte mise en avant avec fond teinté + bordure colorée
  final bool isHighlighted;

  const StatCardData({
    required this.value,
    required this.label,
    required this.icon,
    this.accentColor = ISPMColors.green,
    this.isHighlighted = false,
  });
}

// ── Widget principal ──────────────────────────────────────────────────────────

class HomeStatGrid extends StatelessWidget {
  /// Exactement 4 cartes attendues
  final List<StatCardData> cards;

  const HomeStatGrid({
    super.key,
    required this.cards,
  }) : assert(cards.length == 4, 'HomeStatGrid attend exactement 4 StatCardData');

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      mainAxisSpacing: 9,
      crossAxisSpacing: 9,
      childAspectRatio: 2.05,
      children: cards.map((data) => _StatCard(data: data)).toList(),
    );
  }
}

// ── Carte individuelle ────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final StatCardData data;

  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final accent = data.accentColor;
    final highlighted = data.isHighlighted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: highlighted ? accent.withOpacity(0.13) : ISPMColors.grey900,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlighted
              ? accent.withOpacity(0.50)
              : ISPMColors.white.withOpacity(0.06),
          width: highlighted ? 1.5 : 1.0,
        ),
        boxShadow: highlighted
            ? [
          BoxShadow(
            color: accent.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ]
            : null,
      ),
      child: Row(
        children: [
          // Icône
          Icon(
            data.icon,
            size: 18,
            color: highlighted
                ? accent
                : ISPMColors.white.withOpacity(0.35),
          ),

          const SizedBox(width: 10),

          // Valeur + label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Valeur — taille adaptative si texte long
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    data.value,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: highlighted ? accent : ISPMColors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  data.label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    color: ISPMColors.white.withOpacity(0.32),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}