// lib/features/admin/courses/data/models/admin_course_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/admin_course.dart';

part 'admin_course_model.freezed.dart';
part 'admin_course_model.g.dart';

@freezed
abstract class AdminCourseModel with _$AdminCourseModel {
  const AdminCourseModel._();

  const factory AdminCourseModel({
    required String id,
    required String title,
    @JsonKey(name: 'fieldOfStudy') required String fieldOfStudy,
    @Default('') String professorName,
    @Default('') String professorId,
    required String startTime,
    required String endTime,
    @Default(true) bool isActive,
  }) = _AdminCourseModel;

  factory AdminCourseModel.fromJson(Map<String, dynamic> json) =>
      _$AdminCourseModelFromJson(json);

  AdminCourse toEntity() => AdminCourse(
    id: id,
    title: title,
    fieldOfStudy: fieldOfStudy,
    professorName: professorName,
    professorId: professorId,
    startTime: DateTime.parse(startTime),
    endTime: DateTime.parse(endTime),
    isActive: isActive,
  );
}
