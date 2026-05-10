// lib/features/admin/courses/presentation/blocs/course_state.dart
part of 'course_bloc.dart';

@freezed
abstract class CourseState with _$CourseState {
  const factory CourseState.initial() = _Initial;
  const factory CourseState.loading() = _Loading;
  const factory CourseState.saving() = _Saving;
  const factory CourseState.saveDone() = _SaveDone;
  const factory CourseState.loaded({
    required List<AdminCourse> courses,
    required List<AdminCourse> filtered,
    required String query,
  }) = _Loaded;
  const factory CourseState.error(String message) = _Error;
}
