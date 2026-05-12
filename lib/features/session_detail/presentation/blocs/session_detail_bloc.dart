// presentation/blocs/session_detail_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/usecases/get_session_details_usecase.dart';
import '../../domain/usecases/export_session_pdf_usecase.dart';
import '../../domain/usecases/export_session_pdf_params.dart';
import '../../domain/entities/session_attendance.dart';
part 'session_detail_bloc.freezed.dart';
part 'session_detail_event.dart';
part 'session_detail_state.dart';

@injectable
class SessionDetailBloc extends Bloc<SessionDetailEvent, SessionDetailState> {
  final GetSessionDetailsUseCase _getSessionDetails;
  final ExportSessionPdfUsecase _exportPdf;

  SessionDetailBloc(this._getSessionDetails, this._exportPdf)
    : super(const SessionDetailState.initial()) {
    on<LoadSessionDetailEvent>(_onLoadSessionDetail);
    on<ExportPdfEvent>(_onExportPdf);
  }

  Future<void> _onLoadSessionDetail(
    LoadSessionDetailEvent event,
    Emitter<SessionDetailState> emit,
  ) async {
    emit(SessionDetailState.loading());

    final result = await _getSessionDetails(event.sessionId);

    result.fold(
      (failure) => emit(SessionDetailState.error(failure.toString())),
      (attendance) => emit(
        SessionDetailState.loaded(
          courseTitle: event.courseTitle,
          fieldOfStudy: event.fieldOfStudy,
          startTime: event.startTime,
          endTime: event.endTime,
          attendance: attendance,
        ),
      ),
    );
  }

  Future<void> _onExportPdf(
    ExportPdfEvent event,
    Emitter<SessionDetailState> emit,
  ) async {
    final current = state;
    if (current is! _Loaded) return;

    emit(current.copyWith(isExporting: true));

    final result = await _exportPdf(
      ExportSessionPdfParams(
        courseTitle: current.courseTitle,
        fieldOfStudy: current.fieldOfStudy,
        startTime: current.startTime,
        endTime: current.endTime,
        attendance: current.attendance,
      ),
    );

    result.fold((failure) {
      emit(current.copyWith(isExporting: false));
      emit(SessionDetailState.error(failure.toString()));
    }, (_) => emit(current.copyWith(isExporting: false)));
  }
}
