// lib/features/home/presentation/widgets/shared/home_app_bar.dart
//
// AppBar partagé par les 3 rôles.
// Paramétrable via [accentColor] pour adapter la teinte
// (vert Professeur · bleu Superviseur · amber Admin).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../auth/domain/entities/user.dart';

// ── Modèle de configuration ──────────────────────────────────────────────────

extension UserRoleX on UserRole {
  /// Couleur d'accent par rôle
  Color get accentColor => switch (this) {
    UserRole.professor => ISPMColors.green,
    UserRole.supervisor => Color(0xFF378ADD),
    UserRole.admin => Color(0xFFBA7517),
    UserRole.unknown => Colors.grey,
  };

  /// Label affiché dans le badge rôle
  String get roleLabel => switch (this) {
    UserRole.professor => 'Professeur',
    UserRole.supervisor => 'Superviseur',
    UserRole.admin => 'Admin',
    UserRole.unknown => 'Inconnu',
  };

  /// Icône du badge rôle
  IconData get roleIcon => switch (this) {
    UserRole.professor => Icons.menu_book_rounded,
    UserRole.supervisor => Icons.qr_code_scanner_rounded,
    UserRole.admin => Icons.shield_rounded,
    UserRole.unknown => Icons.help_outline,
  };
}

// ── Widget ───────────────────────────────────────────────────────────────────

class HomeAppBar extends StatelessWidget {
  final String userName;
  final UserRole role;

  /// Afficher le badge "point vert" sur la cloche
  final bool hasNotification;

  /// Callback bouton notification
  final VoidCallback onNotificationTap;

  /// Callback bouton logout
  final VoidCallback onLogoutTap;

  const HomeAppBar({
    super.key,
    required this.userName,
    required this.role,
    this.hasNotification = false,
    required this.onNotificationTap,
    required this.onLogoutTap,
  });

  String get _initial =>
      userName.trim().isNotEmpty ? userName.trim()[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    final accent = role.accentColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
      child: Row(
        children: [
          // ── Avatar ──────────────────────────────────────────────
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.13),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: accent.withOpacity(0.45), width: 1.5),
            ),
            child: Center(
              child: Text(
                _initial,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ── Nom + badge rôle ─────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour,',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: ISPMColors.white.withOpacity(0.38),
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        userName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ISPMColors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _RoleBadge(role: role, accent: accent),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ── Bouton notification ──────────────────────────────────
          _AppBarAction(
            icon: Icons.notifications_outlined,
            badge: hasNotification,
            onTap: onNotificationTap,
          ),

          const SizedBox(width: 6),

          // ── Bouton logout ────────────────────────────────────────
          _AppBarAction(icon: Icons.logout_rounded, onTap: onLogoutTap),
        ],
      ),
    );
  }
}

// ── Badge rôle ───────────────────────────────────────────────────────────────

class _RoleBadge extends StatelessWidget {
  final UserRole role;
  final Color accent;

  const _RoleBadge({required this.role, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            role.roleLabel.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bouton action AppBar ─────────────────────────────────────────────────────

class _AppBarAction extends StatelessWidget {
  final IconData icon;
  final bool badge;
  final VoidCallback onTap;

  const _AppBarAction({
    required this.icon,
    required this.onTap,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: ISPMColors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ISPMColors.white.withOpacity(0.09)),
            ),
            child: Icon(
              icon,
              size: 17,
              color: ISPMColors.white.withOpacity(0.75),
            ),
          ),
          if (badge)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: ISPMColors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
