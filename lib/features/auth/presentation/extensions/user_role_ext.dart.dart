import 'package:flutter/material.dart';

// Import du domaine de la MÊME feature
import '../../domain/entities/user.dart';

// Import du thème depuis le core (autorisé, car feature -> core)
import '../../../../core/theme/app_theme.dart';

extension UserRoleX on UserRole {
  /// Couleur d'accent par rôle
  Color get accentColor => switch (this) {
    UserRole.professor => ISPMColors.green,
    UserRole.supervisor => const Color(0xFF378ADD),
    UserRole.admin => const Color(0xFFBA7517),
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
    UserRole.unknown => Icons.help_outline_rounded,
  };
}
