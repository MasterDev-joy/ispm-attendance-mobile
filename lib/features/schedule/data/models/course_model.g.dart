// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => _CourseModel(
  id: json['id'] as String,
  title: json['title'] as String,
  fieldOfStudy: json['field_of_study'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  professor: json['professor'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$CourseModelToJson(_CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'field_of_study': instance.fieldOfStudy,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'professor': instance.professor,
    };
