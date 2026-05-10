// lib/features/attendance/presentation/blocs/attendance_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/attendance_result.dart';
import '../../domain/repositories/attendance_repository.dart';

part 'attendance_bloc.freezed.dart';
part 'attendance_event.dart';
part 'attendance_state.dart';

@injectable
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository _repository;

  AttendanceBloc(this._repository) : super(const AttendanceState.initial()) {
    on<_ValidateQr>(_onValidateQr);
  }

  Future<void> _onValidateQr(
    _ValidateQr event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceState.loading());
    final result = await _repository.validateAttendance(
      token: event.token,
      professorId: event.professorId,
      courseId: event.courseId,
    );
    result.fold(
      (f) => emit(AttendanceState.error(_msg(f))),
      (data) => emit(AttendanceState.success(data)),
    );
  }

  String _msg(Failure f) => f.when(
    server: (m) => m,
    network: () => 'Pas de connexion réseau',
    unauthorized: () => 'Non authentifié',
    forbidden: () => 'Accès refusé',
    cache: (m) => m,
    unknown: (m) => m,
  );
}
