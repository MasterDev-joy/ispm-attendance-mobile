// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ──────────────────────────────────────────
//  ISPM Design System — Couleurs & Typographie
// ──────────────────────────────────────────

class ISPMColors {
  // Vert signature ISPM
  static const greenDark  = Color(0xFF1E7A1E);
  static const green      = Color(0xFF2EAA2E);
  static const greenLight = Color(0xFF3DCC3D);
  static const greenSoft  = Color(0xFFE8F8E8);
  static const greenGlow  = Color(0xFFD0F0D0);

  // Noir & Gris
  static const black      = Color(0xFF111111);
  static const grey900    = Color(0xFF1E1E1E);
  static const grey800    = Color(0xFF2B2B2B);
  static const grey700    = Color(0xFF3A3A3A);
  static const grey600    = Color(0xFF4A4A4A);
  static const grey400    = Color(0xFF888888);
  static const grey200    = Color(0xFFD0D0C8);
  static const grey100    = Color(0xFFF0F0EC);
  static const white      = Color(0xFFFFFFFF);

  // Sémantique
  static const error       = Color(0xFFD32F2F);
  static const errorSoft   = Color(0xFFFFEBEE);
  static const warning     = Color(0xFFF57C00);
  static const warningSoft = Color(0xFFFFF3E0);
  static const success     = Color(0xFF2EAA2E);
  static const successSoft = Color(0xFFE8F8E8);
}

class ISPMTheme {
  // ── Thème Light (inchangé, pour les autres pages) ──────────────
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.fromSeed(
        seedColor: ISPMColors.green,
        brightness: Brightness.light,
        primary: ISPMColors.green,
        secondary: ISPMColors.greenDark,
        surface: ISPMColors.white,
        error: ISPMColors.error,
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F8F6),
      appBarTheme: const AppBarTheme(
        backgroundColor: ISPMColors.white,
        foregroundColor: ISPMColors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: ISPMColors.black,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: ISPMColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFEAEAE4), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ISPMColors.grey100,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
          const BorderSide(color: ISPMColors.green, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
          const BorderSide(color: ISPMColors.error, width: 1.5),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: ISPMColors.grey400,
          fontSize: 14,
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: ISPMColors.green,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ISPMColors.green,
          foregroundColor: ISPMColors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ISPMColors.green,
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    );
  }

  // ── Thème Dark (login page) ────────────────────────────────────
  // Utilisé uniquement pour la LoginPage via Theme(data: ISPMTheme.dark, child: ...)
  // Il n'est PAS appliqué globalement dans MaterialApp.
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ISPMColors.green,
        brightness: Brightness.dark,
        primary: ISPMColors.green,
        secondary: ISPMColors.greenLight,
        surface: ISPMColors.grey900,
        error: ISPMColors.error,
      ),
      scaffoldBackgroundColor: ISPMColors.black,
      // Les InputDecoration sont gérés manuellement dans IspmTextField
      // pour le dark mode (AnimatedContainer custom).
      // On ne définit que le strict minimum ici.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ISPMColors.green,
          foregroundColor: ISPMColors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ISPMColors.green,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    );
  }
}