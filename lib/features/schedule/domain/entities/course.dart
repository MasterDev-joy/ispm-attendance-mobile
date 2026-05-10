// lib/features/schedule/domain/entities/course.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'course.freezed.dart';

@freezed
abstract class Course with _$Course {
  const factory Course({
    required String id,
    required String title,
    required String fieldOfStudy,
    required String professorName,
    required DateTime startTime,
    required DateTime endTime,
  }) = _Course;
}
