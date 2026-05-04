// lib/features/stats/domain/entities/stats_data.dart
//
// Entités Statistiques — mises à jour pour accepter le risk calculé par le backend.
// Compatible avec l'ancien code (riskOverride est nullable).
// ─────────────────────────────────────────────────────────────────────────────

enum PresenceRisk { good, warning, critical }

/// Résumé de présence pour un cours donné (prof ou superviseur)
class CourseStats {
  final String courseId;
  final String courseTitle;
  final String fieldOfStudy;
  final int    totalSessions;
  final int    presentCount;
  final int    absentCount;

  /// Risk transmis par le backend — si null, calculé localement via presenceRate
  final PresenceRisk? riskOverride;

  const CourseStats({
    required this.courseId,
    required this.courseTitle,
    required this.fieldOfStudy,
    required this.totalSessions,
    required this.presentCount,
    required this.absentCount,
    this.riskOverride,
  });

  double get presenceRate =>
      totalSessions == 0 ? 0 : presentCount / totalSessions;

  /// Priorité : riskOverride (backend) > calcul local
  PresenceRisk get risk {
    if (riskOverride != null) return riskOverride!;
    if (presenceRate >= 0.80) return PresenceRisk.good;
    if (presenceRate >= 0.60) return PresenceRisk.warning;
    return PresenceRisk.critical;
  }
}

/// Résumé d'un cours souvent manqué (section "Cours les plus manqués")
class CourseAbsenceSummary {
  final String courseTitle;
  final String fieldOfStudy;
  final int    absenceCount;
  final int    totalSessions;

  const CourseAbsenceSummary({
    required this.courseTitle,
    required this.fieldOfStudy,
    required this.absenceCount,
    required this.totalSessions,
  });

  double get absenceRate =>
      totalSessions == 0 ? 0 : absenceCount / totalSessions;
}

/// Données globales agrégées pour la StatsPage
class GlobalStats {
  final int    totalSessions;
  final int    presentCount;
  final int    absentCount;
  final double globalPresenceRate;
  final List<CourseStats>          perCourse;
  final List<CourseAbsenceSummary> mostMissed;

  const GlobalStats({
    required this.totalSessions,
    required this.presentCount,
    required this.absentCount,
    required this.globalPresenceRate,
    required this.perCourse,
    required this.mostMissed,
  });
}