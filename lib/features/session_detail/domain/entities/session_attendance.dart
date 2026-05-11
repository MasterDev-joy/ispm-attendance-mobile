// lib/features/session_detail/domain/entities/session_attendance.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_attendance.freezed.dart';

enum AttendanceStatus { onTime, absent }

@freezed
abstract class SessionAttendance with _$SessionAttendance {
  const factory SessionAttendance({
    required String id,
    required AttendanceStatus status,
    DateTime? scanTime,
    Supervisor? supervisor,
  }) = _SessionAttendance;
}

@freezed
abstract class Supervisor with _$Supervisor {
  const factory Supervisor({required String name, required String email}) =
      _Supervisor;
}
