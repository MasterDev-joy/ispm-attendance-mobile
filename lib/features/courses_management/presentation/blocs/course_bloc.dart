// lib/features/admin/courses/presentation/blocs/course_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/admin_course.dart';
import '../../domain/usecases/course_usecases.dart';
import '../../../../../core/error/failures.dart';

part 'course_bloc.freezed.dart';
part 'course_event.dart';
part 'course_state.dart';

@injectable
class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCourses _getCourses;
  final SaveCourse _saveCourse;
  final DeleteCourse _deleteCourse;

  CourseBloc(this._getCourses, this._saveCourse, this._deleteCourse)
    : super(const CourseState.initial()) {
    on<_Load>(_onLoad);
    on<_Save>(_onSave);
    on<_Delete>(_onDelete);
    on<_FilterChanged>(_onFilter);
  }

  Future<void> _onLoad(_Load _, Emitter<CourseState> emit) async {
    emit(const CourseState.loading());
    final result = await _getCourses();
    result.fold(
      (f) => emit(CourseState.error(_msg(f))),
      (courses) => emit(
        CourseState.loaded(courses: courses, filtered: courses, query: ''),
      ),
    );
  }

  Future<void> _onSave(_Save event, Emitter<CourseState> emit) async {
    emit(const CourseState.saving());
    final result = await _saveCourse(
      id: event.id,
      title: event.title,
      fieldOfStudy: event.fieldOfStudy,
      professorId: event.professorId,
      startTime: event.startTime,
      endTime: event.endTime,
    );
    result.fold((f) => emit(CourseState.error(_msg(f))), (_) {
      emit(const CourseState.saveDone());
      add(const CourseEvent.load());
    });
  }

  Future<void> _onDelete(_Delete event, Emitter<CourseState> emit) async {
    final result = await _deleteCourse(event.id);
    result.fold(
      (f) => emit(CourseState.error(_msg(f))),
      (_) => add(const CourseEvent.load()),
    );
  }

  void _onFilter(_FilterChanged event, Emitter<CourseState> emit) {
    final courses =
        state.whenOrNull(loaded: (courses, filtered, query) => courses) ?? [];
    final q = event.query.toLowerCase();
    final filtered = q.isEmpty
        ? courses
        : courses
              .where(
                (c) =>
                    c.title.toLowerCase().contains(q) ||
                    c.professorName.toLowerCase().contains(q) ||
                    c.fieldOfStudy.toLowerCase().contains(q),
              )
              .toList();
    emit(
      CourseState.loaded(
        courses: courses,
        filtered: filtered,
        query: event.query,
      ),
    );
  }

  String _msg(Failure f) => f.when(
    server: (m) => m,
    network: () => 'Pas de connexion réseau',
    unauthorized: () => 'Session expirée',
    forbidden: () => 'Accès refusé',
    cache: (m) => m,
    unknown: (m) => m,
  );
}
