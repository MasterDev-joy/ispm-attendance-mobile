// lib/features/home/presentation/widgets/admin/admin_action_card.dart
//
// Carte raccourci de gestion — exclusive Admin.
// 4 actions : Utilisateurs · Emplois du temps · Rapports · Paramètres
// Chaque carte → navigation vers la page correspondante
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

const _kAmber = Color(0xFFBA7517);

// ── Modèle ActionItem ─────────────────────────────────────────────────────────

class AdminActionItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  /// Badge numérique optionnel (ex: nb utilisateurs, nb cours)
  final String? badge;

  /// Couleur d'accent — par défaut amber Admin
  final Color accentColor;

  const AdminActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    this.badge,
    this.accentColor = _kAmber,
  });
}

// ── Actions prédéfinies Admin ─────────────────────────────────────────────────

class AdminActions {
  static const List<AdminActionItem> all = [
    AdminActionItem(
      icon: Icons.group_rounded,
      title: 'Utilisateurs',
      subtitle: 'Gérer profs & superviseurs',
      route: '/users',
    ),
    AdminActionItem(
      icon: Icons.calendar_month_rounded,
      title: 'Emplois du temps',
      subtitle: 'Ajouter & modifier les cours',
      route: '/courses',
    ),
    AdminActionItem(
      icon: Icons.insert_drive_file_rounded,
      title: 'Rapports & exports',
      subtitle: 'CSV · PDF présences',
      route: '/reports',
    ),
    AdminActionItem(
      icon: Icons.settings_rounded,
      title: 'Paramètres système',
      subtitle: 'Configuration générale',
      route: '/settings',
      accentColor: Color(0xFF888888),
    ),
  ];
}

// ── Widget carte ──────────────────────────────────────────────────────────────

class AdminActionCard extends StatelessWidget {
  final AdminActionItem item;
  final VoidCallback? onTap;

  const AdminActionCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = item.accentColor;

    return GestureDetector(
      onTap: onTap ?? () => Navigator.pushNamed(context, item.route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: ISPMColors.grey900,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ISPMColors.white.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            // ── Icône ──────────────────────────────────────────────
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accent.withOpacity(0.28)),
              ),
              child: Icon(item.icon, size: 18, color: accent),
            ),

            const SizedBox(width: 13),

            // ── Titre + sous-titre ──────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: ISPMColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: ISPMColors.white.withOpacity(0.32),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── Badge compteur optionnel ────────────────────────────
            if (item.badge != null) ...[
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: accent.withOpacity(0.28)),
                ),
                child: Text(
                  item.badge!,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],

            // ── Chevron ─────────────────────────────────────────────
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: ISPMColors.white.withOpacity(0.22),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Liste complète des 4 actions ──────────────────────────────────────────────

class AdminActionList extends StatelessWidget {
  /// Items custom — utilise [AdminActions.all] si non fourni
  final List<AdminActionItem>? items;

  const AdminActionList({super.key, this.items});

  @override
  Widget build(BuildContext context) {
    final list = items ?? AdminActions.all;
    return Column(
      children: list
          .map((item) => AdminActionCard(item: item))
          .toList(),
    );
  }
}