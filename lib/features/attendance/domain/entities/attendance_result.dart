// lib/features/attendance/domain/entities/attendance_result.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_result.freezed.dart';

@freezed
abstract class AttendanceResult with _$AttendanceResult {
  const factory AttendanceResult({
    required String professorName,
    required String courseTitle,
    String? professorPhoto,
  }) = _AttendanceResult;
}
