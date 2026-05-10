// lib/features/attendance/presentation/blocs/attendance_state.dart
part of 'attendance_bloc.dart';

@freezed
class AttendanceState with _$AttendanceState {
  const factory AttendanceState.initial() = _Initial;
  const factory AttendanceState.loading() = _Loading;
  // Map<String,dynamic> remplacé par l'entity typée AttendanceResult
  const factory AttendanceState.success(AttendanceResult result) = _Success;
  const factory AttendanceState.error(String message) = _Error;
}
