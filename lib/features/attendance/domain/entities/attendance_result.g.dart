// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceResult _$AttendanceResultFromJson(Map<String, dynamic> json) =>
    _AttendanceResult(
      professorName: json['professorName'] as String,
      courseTitle: json['courseTitle'] as String,
      professorPhoto: json['professorPhoto'] as String?,
    );

Map<String, dynamic> _$AttendanceResultToJson(_AttendanceResult instance) =>
    <String, dynamic>{
      'professorName': instance.professorName,
      'courseTitle': instance.courseTitle,
      'professorPhoto': instance.professorPhoto,
    };
