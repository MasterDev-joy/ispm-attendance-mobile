// lib/features/attendance/domain/entities/attendance_result.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_result.freezed.dart';
part 'attendance_result.g.dart';

/// Résultat renvoyé par le backend après validation d'un QR code
@freezed
abstract class AttendanceResult with _$AttendanceResult {
  const factory AttendanceResult({
    required String professorName,
    required String courseTitle,
    String? professorPhoto,
  }) = _AttendanceResult;

  factory AttendanceResult.fromJson(Map<String, dynamic> json) =>
      AttendanceResult(
        professorName: json['professorName'] as String? ?? '',
        courseTitle: json['courseTitle'] as String? ?? '',
        professorPhoto: json['professorPhoto'] as String?,
      );
}
