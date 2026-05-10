// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceResultModel _$AttendanceResultModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceResultModel(
  professorName: json['professor'] as String,
  courseTitle: json['course'] as String,
  professorPhoto: json['profilePicture'] as String?,
  attendanceId: json['attendanceId'] as String?,
  status: json['status'] as String?,
  scanTime: json['scanTime'] == null
      ? null
      : DateTime.parse(json['scanTime'] as String),
);

Map<String, dynamic> _$AttendanceResultModelToJson(
  _AttendanceResultModel instance,
) => <String, dynamic>{
  'professor': instance.professorName,
  'course': instance.courseTitle,
  'profilePicture': instance.professorPhoto,
  'attendanceId': instance.attendanceId,
  'status': instance.status,
  'scanTime': instance.scanTime?.toIso8601String(),
};
