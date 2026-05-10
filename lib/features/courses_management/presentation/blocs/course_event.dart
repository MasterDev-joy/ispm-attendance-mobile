// lib/features/admin/courses/presentation/blocs/course_event.dart
part of 'course_bloc.dart';

@freezed
abstract class CourseEvent with _$CourseEvent {
  const factory CourseEvent.load() = _Load;
  const factory CourseEvent.save({
    String? id,
    required String title,
    required String fieldOfStudy,
    required String professorId,
    required DateTime startTime,
    required DateTime endTime,
  }) = _Save;
  const factory CourseEvent.delete(String id) = _Delete;
  const factory CourseEvent.filterChanged(String query) = _FilterChanged;
}
