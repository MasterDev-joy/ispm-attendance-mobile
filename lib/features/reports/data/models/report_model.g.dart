// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GlobalReportModel _$GlobalReportModelFromJson(Map<String, dynamic> json) =>
    _GlobalReportModel(
      totalCourses: (json['totalCourses'] as num?)?.toInt() ?? 0,
      validatedCourses: (json['validatedCourses'] as num?)?.toInt() ?? 0,
      uncoveredCourses: (json['uncoveredCourses'] as num?)?.toInt() ?? 0,
      totalProfessors: (json['totalProfessors'] as num?)?.toInt() ?? 0,
      totalSupervisors: (json['totalSupervisors'] as num?)?.toInt() ?? 0,
      validationRate: (json['validationRate'] as num?)?.toDouble() ?? 0.0,
      perProfessor:
          (json['perProfessor'] as List<dynamic>?)
              ?.map((e) => ProfReportModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GlobalReportModelToJson(_GlobalReportModel instance) =>
    <String, dynamic>{
      'totalCourses': instance.totalCourses,
      'validatedCourses': instance.validatedCourses,
      'uncoveredCourses': instance.uncoveredCourses,
      'totalProfessors': instance.totalProfessors,
      'totalSupervisors': instance.totalSupervisors,
      'validationRate': instance.validationRate,
      'perProfessor': instance.perProfessor,
    };

_ProfReportModel _$ProfReportModelFromJson(Map<String, dynamic> json) =>
    _ProfReportModel(
      name: json['name'] as String? ?? '',
      courses: (json['courses'] as num?)?.toInt() ?? 0,
      validated: (json['validated'] as num?)?.toInt() ?? 0,
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$ProfReportModelToJson(_ProfReportModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'courses': instance.courses,
      'validated': instance.validated,
      'rate': instance.rate,
    };
