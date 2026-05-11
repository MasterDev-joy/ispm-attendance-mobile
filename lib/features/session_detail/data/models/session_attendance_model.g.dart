// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionAttendanceModel _$SessionAttendanceModelFromJson(
  Map<String, dynamic> json,
) => _SessionAttendanceModel(
  id: json['id'] as String,
  status: $enumDecode(
    _$AttendanceStatusEnumMap,
    json['status'],
    unknownValue: AttendanceStatus.absent,
  ),
  scanTime: json['scanTime'] == null
      ? null
      : DateTime.parse(json['scanTime'] as String),
  supervisor: json['supervisor'] == null
      ? null
      : SupervisorModel.fromJson(json['supervisor'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SessionAttendanceModelToJson(
  _SessionAttendanceModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': _$AttendanceStatusEnumMap[instance.status]!,
  'scanTime': instance.scanTime?.toIso8601String(),
  'supervisor': instance.supervisor,
};

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.onTime: 'onTime',
  AttendanceStatus.absent: 'absent',
};

_SupervisorModel _$SupervisorModelFromJson(Map<String, dynamic> json) =>
    _SupervisorModel(
      name: json['name'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$SupervisorModelToJson(_SupervisorModel instance) =>
    <String, dynamic>{'name': instance.name, 'email': instance.email};
