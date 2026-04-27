// lib/features/stats/presentation/blocs/stats_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/stats_data.dart';
import 'stats_event.dart';
import 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc() : super(StatsInitial()) {
    on<LoadStatsEvent>(_onLoad);
    on<ChangePeriodEvent>(_onChangePeriod);
  }

  Future<void> _onLoad(LoadStatsEvent event, Emitter<StatsState> emit) async {
    emit(StatsLoading());
    try {
      // TODO: Remplacer par → GET /api/attendance/my-stats?period=month|semester|all
      // La réponse attendue : { totalSessions, presentCount, absentCount, perCourse: [...] }
      await Future.delayed(const Duration(milliseconds: 600));
      emit(StatsLoaded(data: _mockData(event.period), period: event.period));
    } catch (e) {
      emit(StatsError('Impossible de charger les statistiques : $e'));
    }
  }

  Future<void> _onChangePeriod(
      ChangePeriodEvent event, Emitter<StatsState> emit) async {
    emit(StatsLoading());
    try {
      // TODO: Remplacer par appel API avec event.period
      await Future.delayed(const Duration(milliseconds: 400));
      emit(StatsLoaded(data: _mockData(event.period), period: event.period));
    } catch (e) {
      emit(StatsError('Erreur : $e'));
    }
  }

  /// Mock data basé sur la logique réelle :
  /// présences du PROFESSEUR sur ses cours (pas des étudiants)
  GlobalStats _mockData(StatsPeriod period) {
    switch (period) {
      case StatsPeriod.month:
        final courses = [
          const CourseStats(
            courseId: '1',
            courseTitle: 'Algorithmique',
            fieldOfStudy: 'Informatique',
            totalSessions: 8,
            presentCount: 8,
            absentCount: 0,
          ),
          const CourseStats(
            courseId: '2',
            courseTitle: 'Base de données',
            fieldOfStudy: 'Informatique',
            totalSessions: 6,
            presentCount: 5,
            absentCount: 1,
          ),
          const CourseStats(
            courseId: '3',
            courseTitle: 'Réseaux',
            fieldOfStudy: 'Télécommunications',
            totalSessions: 4,
            presentCount: 3,
            absentCount: 1,
          ),
        ];
        return _buildGlobal(courses, period);

      case StatsPeriod.semester:
        final courses = [
          const CourseStats(
            courseId: '1',
            courseTitle: 'Algorithmique',
            fieldOfStudy: 'Informatique',
            totalSessions: 24,
            presentCount: 23,
            absentCount: 1,
          ),
          const CourseStats(
            courseId: '2',
            courseTitle: 'Base de données',
            fieldOfStudy: 'Informatique',
            totalSessions: 18,
            presentCount: 15,
            absentCount: 3,
          ),
          const CourseStats(
            courseId: '3',
            courseTitle: 'Réseaux',
            fieldOfStudy: 'Télécommunications',
            totalSessions: 16,
            presentCount: 11,
            absentCount: 5,
          ),
          const CourseStats(
            courseId: '4',
            courseTitle: 'Mathématiques',
            fieldOfStudy: 'Sciences',
            totalSessions: 20,
            presentCount: 20,
            absentCount: 0,
          ),
        ];
        return _buildGlobal(courses, period);

      case StatsPeriod.all:
        final courses = [
          const CourseStats(
            courseId: '1',
            courseTitle: 'Algorithmique',
            fieldOfStudy: 'Informatique',
            totalSessions: 48,
            presentCount: 46,
            absentCount: 2,
          ),
          const CourseStats(
            courseId: '2',
            courseTitle: 'Base de données',
            fieldOfStudy: 'Informatique',
            totalSessions: 36,
            presentCount: 29,
            absentCount: 7,
          ),
          const CourseStats(
            courseId: '3',
            courseTitle: 'Réseaux',
            fieldOfStudy: 'Télécommunications',
            totalSessions: 32,
            presentCount: 22,
            absentCount: 10,
          ),
          const CourseStats(
            courseId: '4',
            courseTitle: 'Mathématiques',
            fieldOfStudy: 'Sciences',
            totalSessions: 40,
            presentCount: 40,
            absentCount: 0,
          ),
        ];
        return _buildGlobal(courses, period);
    }
  }

  GlobalStats _buildGlobal(List<CourseStats> courses, StatsPeriod period) {
    final total = courses.fold(0, (s, c) => s + c.totalSessions);
    final present = courses.fold(0, (s, c) => s + c.presentCount);
    final absent = courses.fold(0, (s, c) => s + c.absentCount);

    // Cours les plus manqués : triés par absences décroissantes
    final mostMissed = courses
        .where((c) => c.absentCount > 0)
        .map((c) => CourseAbsenceSummary(
              courseTitle: c.courseTitle,
              fieldOfStudy: c.fieldOfStudy,
              absenceCount: c.absentCount,
              totalSessions: c.totalSessions,
            ))
        .toList()
      ..sort((a, b) => b.absenceCount.compareTo(a.absenceCount));

    return GlobalStats(
      totalSessions: total,
      presentCount: present,
      absentCount: absent,
      globalPresenceRate: total == 0 ? 0 : present / total,
      perCourse: courses,
      mostMissed: mostMissed,
    );
  }
}
