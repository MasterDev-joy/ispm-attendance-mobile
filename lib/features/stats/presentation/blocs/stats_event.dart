// lib/features/stats/presentation/blocs/stats_event.dart
import 'package:equatable/equatable.dart';

enum StatsPeriod { month, semester, all }

abstract class StatsEvent extends Equatable {
  const StatsEvent();
  @override
  List<Object?> get props => [];
}

class LoadStatsEvent extends StatsEvent {
  final StatsPeriod period;
  const LoadStatsEvent({this.period = StatsPeriod.month});
  @override
  List<Object?> get props => [period];
}

class ChangePeriodEvent extends StatsEvent {
  final StatsPeriod period;
  const ChangePeriodEvent(this.period);
  @override
  List<Object?> get props => [period];
}
