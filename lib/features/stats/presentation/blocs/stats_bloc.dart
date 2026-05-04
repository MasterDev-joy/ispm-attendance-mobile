// lib/features/stats/presentation/blocs/stats_bloc.dart
//
// StatsBloc — corrigé pour appeler GET /api/stats?period=month|semester|all
// Le backend retourne des données adaptées au rôle du token JWT.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/app_config.dart';
import '../../domain/entities/stats_data.dart';
import 'stats_event.dart';
import 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final _storage = const FlutterSecureStorage();

  StatsBloc() : super(StatsInitial()) {
    on<LoadStatsEvent>(_onLoad);
    on<ChangePeriodEvent>(_onChangePeriod);
  }

  // ── Chargement initial ────────────────────────────────────────────────────

  Future<void> _onLoad(
      LoadStatsEvent event, Emitter<StatsState> emit) async {
    emit(StatsLoading());
    await _fetchAndEmit(event.period, emit);
  }

  // ── Changement de période ─────────────────────────────────────────────────

  Future<void> _onChangePeriod(
      ChangePeriodEvent event, Emitter<StatsState> emit) async {
    emit(StatsLoading());
    await _fetchAndEmit(event.period, emit);
  }

  // ── Appel API + parsing ───────────────────────────────────────────────────

  Future<void> _fetchAndEmit(
      StatsPeriod period, Emitter<StatsState> emit) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) throw Exception('Token introuvable — reconnectez-vous');

      // Convertit l'enum en string pour l'URL
      final periodStr = _periodToString(period);

      final response = await http
          .get(
        Uri.parse('${AppConfig.baseUrl}/api/stats?period=$periodStr'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final data = _parseGlobalStats(json);
        emit(StatsLoaded(data: data, period: period));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Session expirée — reconnectez-vous');
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['error'] ?? 'Erreur serveur (${response.statusCode})');
      }
    } catch (e) {
      emit(StatsError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // ── Conversion enum → string ──────────────────────────────────────────────

  String _periodToString(StatsPeriod p) => switch (p) {
    StatsPeriod.month    => 'month',
    StatsPeriod.semester => 'semester',
    StatsPeriod.all      => 'all',
  };

  // ── Parsing de la réponse JSON → GlobalStats ──────────────────────────────
  //
  // Structure attendue du backend (stats.controller.ts) :
  // {
  //   "role":               "professor" | "supervisor" | "admin",
  //   "period":             "month",
  //   "globalPresenceRate": 0.85,
  //   "presentCount":       17,
  //   "absentCount":        3,
  //   "totalSessions":      20,
  //   "perCourse": [
  //     {
  //       "courseId":      "abc",
  //       "courseTitle":   "Algorithmique",
  //       "fieldOfStudy":  "Informatique",
  //       "presenceRate":  0.92,
  //       "presentCount":  11,
  //       "absentCount":   1,
  //       "totalSessions": 12,
  //       "risk":          "good" | "warning" | "critical"
  //     }
  //   ],
  //   "mostMissed": [
  //     {
  //       "courseTitle":   "Réseaux",
  //       "fieldOfStudy":  "Télécommunications",
  //       "absenceCount":  3,
  //       "absenceRate":   0.38
  //     }
  //   ]
  // }

  GlobalStats _parseGlobalStats(Map<String, dynamic> json) {
    // ── perCourse ─────────────────────────────────────────────────
    final perCourseRaw = json['perCourse'] as List<dynamic>? ?? [];
    final perCourse = perCourseRaw.map((c) {
      final map = c as Map<String, dynamic>;
      return CourseStats(
        courseId:      map['courseId']      as String? ?? '',
        courseTitle:   map['courseTitle']   as String? ?? '',
        fieldOfStudy:  map['fieldOfStudy']  as String? ?? '',
        totalSessions: (map['totalSessions'] as num?)?.toInt() ?? 0,
        presentCount:  (map['presentCount']  as num?)?.toInt() ?? 0,
        absentCount:   (map['absentCount']   as num?)?.toInt() ?? 0,
        // Surcharge optionnelle du risk depuis le backend
        riskOverride:  _parseRisk(map['risk'] as String?),
      );
    }).toList();

    // ── mostMissed ────────────────────────────────────────────────
    final mostMissedRaw = json['mostMissed'] as List<dynamic>? ?? [];
    final mostMissed = mostMissedRaw.map((m) {
      final map = m as Map<String, dynamic>;
      return CourseAbsenceSummary(
        courseTitle:   map['courseTitle']   as String? ?? '',
        fieldOfStudy:  map['fieldOfStudy']  as String? ?? '',
        absenceCount:  (map['absenceCount']  as num?)?.toInt() ?? 0,
        totalSessions: _resolveTotalSessions(map),
      );
    }).toList();

    return GlobalStats(
      totalSessions:      (json['totalSessions']      as num?)?.toInt() ?? 0,
      presentCount:       (json['presentCount']       as num?)?.toInt() ?? 0,
      absentCount:        (json['absentCount']        as num?)?.toInt() ?? 0,
      globalPresenceRate: (json['globalPresenceRate'] as num?)?.toDouble() ?? 0.0,
      perCourse:          perCourse,
      mostMissed:         mostMissed,
    );
  }

  /// Convertit le string "good" | "warning" | "critical" en enum PresenceRisk
  PresenceRisk? _parseRisk(String? raw) => switch (raw) {
    'good'     => PresenceRisk.good,
    'warning'  => PresenceRisk.warning,
    'critical' => PresenceRisk.critical,
    _          => null, // null = le getter de CourseStats calcule lui-même
  };

  /// Le backend peut envoyer totalSessions ou le calculer à partir de absenceRate
  int _resolveTotalSessions(Map<String, dynamic> map) {
    if (map['totalSessions'] != null) {
      return (map['totalSessions'] as num).toInt();
    }
    // Fallback : absenceRate = absenceCount / totalSessions → on reconstruit
    final absenceCount = (map['absenceCount'] as num?)?.toInt() ?? 0;
    final absenceRate  = (map['absenceRate']  as num?)?.toDouble() ?? 0.0;
    if (absenceRate > 0 && absenceCount > 0) {
      return (absenceCount / absenceRate).round();
    }
    return absenceCount; // pire cas
  }
}