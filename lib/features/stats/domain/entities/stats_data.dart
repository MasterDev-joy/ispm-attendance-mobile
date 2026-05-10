// lib/features/stats/domain/entities/stats_data.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_data.freezed.dart';

enum PresenceRisk { good, warning, critical }

enum StatsPeriod { month, semester, all }

@freezed
abstract class CourseStats with _$CourseStats {
  const CourseStats._();

  const factory CourseStats({
    required String courseId,
    required String courseTitle,
    required String fieldOfStudy,
    required int totalSessions,
    required int presentCount,
    required int absentCount,
    PresenceRisk? riskOverride,
  }) = _CourseStats;

  double get presenceRate =>
      totalSessions == 0 ? 0 : presentCount / totalSessions;

  PresenceRisk get risk {
    if (riskOverride != null) return riskOverride!;
    if (presenceRate >= 0.80) return PresenceRisk.good;
    if (presenceRate >= 0.60) return PresenceRisk.warning;
    return PresenceRisk.critical;
  }
}

@freezed
abstract class CourseAbsenceSummary with _$CourseAbsenceSummary {
  const CourseAbsenceSummary._();

  const factory CourseAbsenceSummary({
    required String courseTitle,
    required String fieldOfStudy,
    required int absenceCount,
    required int totalSessions,
  }) = _CourseAbsenceSummary;

  double get absenceRate =>
      totalSessions == 0 ? 0 : absenceCount / totalSessions;
}

@freezed
abstract class GlobalStats with _$GlobalStats {
  const factory GlobalStats({
    required int totalSessions,
    required int presentCount,
    required int absentCount,
    required double globalPresenceRate,
    required List<CourseStats> perCourse,
    required List<CourseAbsenceSummary> mostMissed,
  }) = _GlobalStats;
}
