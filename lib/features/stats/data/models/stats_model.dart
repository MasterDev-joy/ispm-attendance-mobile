// lib/features/stats/data/models/stats_model.dart
//
// Pas de @freezed ici : StatsModel est un pur helper de désérialisation
// (pas de toJson, pas de copyWith). On garde la classe statique.
// ─────────────────────────────────────────────────────────────────────────────
import '../../domain/entities/stats_data.dart';

class StatsModel {
  static GlobalStats fromJson(Map<String, dynamic> json) {
    final perCourse = (json['perCourse'] as List<dynamic>? ?? [])
        .map((c) => _parseCourseStats(c as Map<String, dynamic>))
        .toList();

    final mostMissed = (json['mostMissed'] as List<dynamic>? ?? [])
        .map((m) => _parseCourseAbsenceSummary(m as Map<String, dynamic>))
        .toList();

    return GlobalStats(
      totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
      presentCount: (json['presentCount'] as num?)?.toInt() ?? 0,
      absentCount: (json['absentCount'] as num?)?.toInt() ?? 0,
      globalPresenceRate:
          (json['globalPresenceRate'] as num?)?.toDouble() ?? 0.0,
      perCourse: perCourse,
      mostMissed: mostMissed,
    );
  }

  static CourseStats _parseCourseStats(Map<String, dynamic> map) => CourseStats(
    courseId: map['courseId'] as String? ?? '',
    courseTitle: map['courseTitle'] as String? ?? '',
    fieldOfStudy: map['fieldOfStudy'] as String? ?? '',
    totalSessions: (map['totalSessions'] as num?)?.toInt() ?? 0,
    presentCount: (map['presentCount'] as num?)?.toInt() ?? 0,
    absentCount: (map['absentCount'] as num?)?.toInt() ?? 0,
    riskOverride: _parseRisk(map['risk'] as String?),
  );

  static CourseAbsenceSummary _parseCourseAbsenceSummary(
    Map<String, dynamic> map,
  ) => CourseAbsenceSummary(
    courseTitle: map['courseTitle'] as String? ?? '',
    fieldOfStudy: map['fieldOfStudy'] as String? ?? '',
    absenceCount: (map['absenceCount'] as num?)?.toInt() ?? 0,
    totalSessions: _resolveTotalSessions(map),
  );

  static PresenceRisk? _parseRisk(String? raw) => switch (raw) {
    'good' => PresenceRisk.good,
    'warning' => PresenceRisk.warning,
    'critical' => PresenceRisk.critical,
    _ => null,
  };

  static int _resolveTotalSessions(Map<String, dynamic> map) {
    if (map['totalSessions'] != null) {
      return (map['totalSessions'] as num).toInt();
    }
    final absenceCount = (map['absenceCount'] as num?)?.toInt() ?? 0;
    final absenceRate = (map['absenceRate'] as num?)?.toDouble() ?? 0.0;
    if (absenceRate > 0 && absenceCount > 0) {
      return (absenceCount / absenceRate).round();
    }
    return absenceCount;
  }
}
