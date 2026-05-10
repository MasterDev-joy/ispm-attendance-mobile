// lib/features/attendance/data/models/attendance_result_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/attendance_result.dart';

part 'attendance_result_model.freezed.dart';
part 'attendance_result_model.g.dart';

@freezed
abstract class AttendanceResultModel with _$AttendanceResultModel {
  const AttendanceResultModel._();

  const factory AttendanceResultModel({
    // @JsonKey mappe le nom JSON → le nom Dart
    @JsonKey(name: 'professor') required String professorName,
    @JsonKey(name: 'course') required String courseTitle,
    @JsonKey(name: 'profilePicture') String? professorPhoto,

    // Ces champs existent dans la réponse, autant les capturer
    String? attendanceId,
    String? status,
    DateTime? scanTime,
  }) = _AttendanceResultModel;

  factory AttendanceResultModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceResultModelFromJson(json);

  AttendanceResult toEntity() => AttendanceResult(
    professorName: professorName,
    courseTitle: courseTitle,
    professorPhoto: professorPhoto,
  );
}
