// lib/features/schedule/data/models/course_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/course.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

@freezed
abstract class CourseModel with _$CourseModel {
  const CourseModel._();

  const factory CourseModel({
    required String id,
    required String title,
    @JsonKey(name: 'field_of_study') required String fieldOfStudy,
    required String startTime,
    required String endTime,
    Map<String, dynamic>? professor,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  Course toEntity() => Course(
    id: id,
    title: title,
    fieldOfStudy: fieldOfStudy,
    professorName: professor != null
        ? '${professor!['firstName']} ${professor!['lastName']}'
        : 'Professeur inconnu',
    startTime: DateTime.parse(startTime),
    endTime: DateTime.parse(endTime),
  );
}
