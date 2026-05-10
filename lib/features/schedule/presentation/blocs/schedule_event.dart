// lib/features/schedule/presentation/blocs/schedule_event.dart
part of 'schedule_bloc.dart';

@freezed
class ScheduleEvent with _$ScheduleEvent {
  const factory ScheduleEvent.load() = _Load;
}
