import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/schedule_repository_impl.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepositoryImpl _repository;

  ScheduleBloc({required ScheduleRepositoryImpl repository})
      : _repository = repository,
        super(ScheduleInitial()) {
    on<LoadScheduleEvent>(_onLoadSchedule);
  }

  Future<void> _onLoadSchedule(
      LoadScheduleEvent event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      // On appelle l'API Node.js
      final courses = await _repository.getMyCourses();
      emit(ScheduleLoaded(courses));
    } catch (e) {
      emit(ScheduleError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}