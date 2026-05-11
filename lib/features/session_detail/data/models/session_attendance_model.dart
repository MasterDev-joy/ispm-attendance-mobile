// lib/features/session_detail/data/models/session_attendance_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/session_attendance.dart';

part 'session_attendance_model.freezed.dart';
part 'session_attendance_model.g.dart';

@freezed
abstract class SessionAttendanceModel with _$SessionAttendanceModel {
  const SessionAttendanceModel._(); // Constructeur privé requis pour toEntity()

  const factory SessionAttendanceModel({
    required String id,
    @JsonKey(unknownEnumValue: AttendanceStatus.absent)
    required AttendanceStatus status,
    DateTime? scanTime,
    SupervisorModel? supervisor,
  }) = _SessionAttendanceModel;

  factory SessionAttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$SessionAttendanceModelFromJson(json);

  /// Convertit le modèle de données (Data) en entité métier (Domain)
  SessionAttendance toEntity() {
    return SessionAttendance(
      id: id,
      status: status,
      scanTime: scanTime,
      supervisor: supervisor?.toEntity(),
    );
  }
}

@freezed
abstract class SupervisorModel with _$SupervisorModel {
  const SupervisorModel._();

  const factory SupervisorModel({required String name, required String email}) =
      _SupervisorModel;

  factory SupervisorModel.fromJson(Map<String, dynamic> json) =>
      _$SupervisorModelFromJson(json);

  Supervisor toEntity() {
    return Supervisor(name: name, email: email);
  }
}
