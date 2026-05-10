// lib/features/stats/presentation/blocs/stats_event.dart
part of 'stats_bloc.dart';

@freezed
abstract class StatsEvent with _$StatsEvent {
  const factory StatsEvent.load({
    @Default(StatsPeriod.month) StatsPeriod period,
  }) = _Load;
  const factory StatsEvent.changePeriod(StatsPeriod period) = _ChangePeriod;
}
