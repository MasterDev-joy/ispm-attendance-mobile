// lib/features/admin/reports/data/models/report_model.dart
//
// DTO pur — importe json_annotation, PAS l'entity directement.
// toEntity() est le seul lien autorisé vers domain/.
// Le mock reste ici (données de dev), jamais dans le domain.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/report_data.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

@freezed
abstract class GlobalReportModel with _$GlobalReportModel {
  const GlobalReportModel._();

  const factory GlobalReportModel({
    @Default(0) int totalCourses,
    @Default(0) int validatedCourses,
    @Default(0) int uncoveredCourses,
    @Default(0) int totalProfessors,
    @Default(0) int totalSupervisors,
    @Default(0.0) double validationRate,
    @Default([]) List<ProfReportModel> perProfessor,
  }) = _GlobalReportModel;

  factory GlobalReportModel.fromJson(Map<String, dynamic> json) =>
      _$GlobalReportModelFromJson(json);

  GlobalReport toEntity() => GlobalReport(
    totalCourses: totalCourses,
    validatedCourses: validatedCourses,
    uncoveredCourses: uncoveredCourses,
    totalProfessors: totalProfessors,
    totalSupervisors: totalSupervisors,
    validationRate: validationRate,
    perProfessor: perProfessor.map((p) => p.toEntity()).toList(),
  );

  // Mock dev — jamais appelé en production
  static GlobalReportModel mock() => const GlobalReportModel(
    totalCourses: 48,
    validatedCourses: 39,
    uncoveredCourses: 9,
    totalProfessors: 6,
    totalSupervisors: 3,
    validationRate: 0.81,
    perProfessor: [
      ProfReportModel(
        name: 'Rakoto Fifaliana',
        courses: 12,
        validated: 11,
        rate: 0.92,
      ),
      ProfReportModel(
        name: 'Rasoa Miandra',
        courses: 10,
        validated: 8,
        rate: 0.80,
      ),
      ProfReportModel(name: 'Rabe Hery', courses: 9, validated: 7, rate: 0.78),
      ProfReportModel(
        name: 'Ravelo Niry',
        courses: 8,
        validated: 5,
        rate: 0.63,
      ),
      ProfReportModel(
        name: 'Rakoton. S.',
        courses: 5,
        validated: 5,
        rate: 1.00,
      ),
      ProfReportModel(
        name: 'Ramarol. L.',
        courses: 4,
        validated: 3,
        rate: 0.75,
      ),
    ],
  );
}

@freezed
abstract class ProfReportModel with _$ProfReportModel {
  const ProfReportModel._();

  const factory ProfReportModel({
    @Default('') String name,
    @Default(0) int courses,
    @Default(0) int validated,
    @Default(0.0) double rate,
  }) = _ProfReportModel;

  factory ProfReportModel.fromJson(Map<String, dynamic> json) =>
      _$ProfReportModelFromJson(json);

  ProfReport toEntity() => ProfReport(
    name: name,
    courses: courses,
    validated: validated,
    rate: rate,
  );
}
