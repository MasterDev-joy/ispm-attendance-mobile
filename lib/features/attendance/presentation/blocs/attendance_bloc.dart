import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/attendance_repository.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository repository;

  AttendanceBloc({required this.repository}) : super(AttendanceInitial()) {
    on<ValidateQrEvent>(_onValidateQr);
  }

  Future<void> _onValidateQr(ValidateQrEvent event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      // Appel vers votre API Node.js
      final result = await repository.validateAttendance(
        token: event.token,
        professorId: event.professorId,
        courseId: event.courseId,
      );

      // Succès : On passe les données du prof à l'interface
      emit(AttendanceValidationSuccess(result));
    } catch (e) {
      // Erreur : QR expiré, déjà validé, etc.
      emit(AttendanceError(e.toString()));
    }
  }
}