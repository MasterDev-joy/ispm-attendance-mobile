// lib/features/attendance/presentation/blocs/attendance_event.dart
part of 'attendance_bloc.dart';

@freezed
abstract class AttendanceEvent with _$AttendanceEvent {
  const factory AttendanceEvent.validateQr({
    required String token,
    required String professorId,
    required String courseId,
  }) = _ValidateQr;
}
