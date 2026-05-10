// lib/features/schedule/presentation/blocs/schedule_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/course.dart';
import '../../domain/usecases/get_my_courses.dart';
import '../../../../../core/error/failures.dart';

part 'schedule_bloc.freezed.dart';
part 'schedule_event.dart';
part 'schedule_state.dart';

@injectable
class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetMyCourses _getMyCourses;

  ScheduleBloc(this._getMyCourses) : super(const ScheduleState.initial()) {
    on<_Load>(_onLoad);
  }

  Future<void> _onLoad(_Load _, Emitter<ScheduleState> emit) async {
    emit(const ScheduleState.loading());
    final result = await _getMyCourses();
    result.fold(
      (f) => emit(ScheduleState.error(_msg(f))),
      (courses) => emit(ScheduleState.loaded(courses)),
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
