// lib/features/stats/domain/entities/stats_data.dart

enum PresenceRisk { good, warning, critical }

/// Résumé de présence du prof pour un cours donné
class CourseStats {
  final String courseId;
  final String courseTitle;
  final String fieldOfStudy;
  final int totalSessions;      // nombre de séances dans la période
  final int presentCount;       // fois où le prof était ON_TIME
  final int absentCount;        // fois où le prof était ABSENT ou non scanné

  const CourseStats({
    required this.courseId,
    required this.courseTitle,
    required this.fieldOfStudy,
    required this.totalSessions,
    required this.presentCount,
    required this.absentCount,
  });

  double get presenceRate =>
      totalSessions == 0 ? 0 : presentCount / totalSessions;

  PresenceRisk get risk {
    if (presenceRate >= 0.80) return PresenceRisk.good;
    if (presenceRate >= 0.60) return PresenceRisk.warning;
    return PresenceRisk.critical;
  }
}

/// Résumé d'un cours souvent manqué (pour la liste "Cours les plus manqués")
class CourseAbsenceSummary {
  final String courseTitle;
  final String fieldOfStudy;
  final int absenceCount;
  final int totalSessions;

  const CourseAbsenceSummary({
    required this.courseTitle,
    required this.fieldOfStudy,
    required this.absenceCount,
    required this.totalSessions,
  });

  double get absenceRate =>
      totalSessions == 0 ? 0 : absenceCount / totalSessions;
}

/// Données globales agrégées pour le tableau de bord
class GlobalStats {
  final int totalSessions;
  final int presentCount;
  final int absentCount;
  final double globalPresenceRate;
  final List<CourseStats> perCourse;
  final List<CourseAbsenceSummary> mostMissed; // cours les plus manqués

  const GlobalStats({
    required this.totalSessions,
    required this.presentCount,
    required this.absentCount,
    required this.globalPresenceRate,
    required this.perCourse,
    required this.mostMissed,
  });
}
