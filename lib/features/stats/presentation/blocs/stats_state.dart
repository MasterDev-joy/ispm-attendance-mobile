// lib/features/stats/presentation/blocs/stats_state.dart
part of 'stats_bloc.dart';

@freezed
class StatsState with _$StatsState {
  const factory StatsState.initial() = _Initial;
  const factory StatsState.loading() = _Loading;
  const factory StatsState.loaded({
    required GlobalStats data,
    required StatsPeriod period,
  }) = _Loaded;
  const factory StatsState.error(String message) = _Error;
}
