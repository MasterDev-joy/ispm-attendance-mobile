// lib/features/stats/presentation/blocs/stats_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/stats_data.dart';
import 'stats_event.dart';

abstract class StatsState extends Equatable {
  const StatsState();
  @override
  List<Object?> get props => [];
}

class StatsInitial extends StatsState {}

class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState {
  final GlobalStats data;
  final StatsPeriod period;
  const StatsLoaded({required this.data, required this.period});
  @override
  List<Object?> get props => [data, period];
}

class StatsError extends StatsState {
  final String message;
  const StatsError(this.message);
  @override
  List<Object?> get props => [message];
}
