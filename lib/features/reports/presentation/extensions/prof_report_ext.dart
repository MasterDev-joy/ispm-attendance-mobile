// lib/features/admin/reports/presentation/extensions/prof_report_ext.dart
//
// Extension de présentation sur ProfReport.
// Isole la logique de couleur hors de l'entité domaine — ✅ correct.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../domain/entities/report_data.dart';

extension ProfReportPresentation on ProfReport {
  /// ≥ 85 % → vert  |  ≥ 65 % → orange  |  < 65 % → rouge
  Color get rateColor {
    if (rate >= 0.85) return ISPMColors.green;
    if (rate >= 0.65) return const Color(0xFFF57C00);
    return ISPMColors.error;
  }
}
