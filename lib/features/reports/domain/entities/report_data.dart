// lib/features/admin/reports/domain/entities/report_data.dart
//
// ✅ RÈGLE AGENT : domain/ n'importe PAS Flutter ni de package tiers.
//    La couleur du taux (rateColor) reste dans la couche présentation
//    via une extension → prof_report_ext.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_data.freezed.dart';

@freezed
abstract class GlobalReport with _$GlobalReport {
  const factory GlobalReport({
    required int totalCourses,
    required int validatedCourses,
    required int uncoveredCourses,
    required int totalProfessors,
    required int totalSupervisors,
    required double validationRate,
    required List<ProfReport> perProfessor,
  }) = _GlobalReport;
}

@freezed
abstract class ProfReport with _$ProfReport {
  const factory ProfReport({
    required String name,
    required int courses,
    required int validated,
    required double rate,
  }) = _ProfReport;
}
