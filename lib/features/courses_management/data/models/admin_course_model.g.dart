// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminCourseModel _$AdminCourseModelFromJson(Map<String, dynamic> json) =>
    _AdminCourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      fieldOfStudy: json['fieldOfStudy'] as String,
      professorName: json['professorName'] as String? ?? '',
      professorId: json['professorId'] as String? ?? '',
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$AdminCourseModelToJson(_AdminCourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'fieldOfStudy': instance.fieldOfStudy,
      'professorName': instance.professorName,
      'professorId': instance.professorId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isActive': instance.isActive,
    };
