// lib/features/admin/reports/presentation/blocs/report_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/report_data.dart';
import '../../domain/usecases/get_reports_usecase.dart';
import '../../domain/usecases/export_csv.dart';
import '../../domain/usecases/export_pdf.dart';
import '../../../../../core/error/failures.dart';

part 'report_bloc.freezed.dart';
part 'report_event.dart';
part 'report_state.dart';

@injectable
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetReports _getReports;
  final ExportCsv _exportCsv;
  final ExportPdf _exportPdf;

  ReportBloc(this._getReports, this._exportCsv, this._exportPdf)
    : super(const ReportState.initial()) {
    on<_Load>(_onLoad);
    on<_ChangePeriod>(_onChangePeriod);
    on<_Export>(_onExport);
  }

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _onLoad(_Load event, Emitter<ReportState> emit) async {
    emit(const ReportState.loading());
    final result = await _getReports(period: event.period);
    result.fold(
      (f) => emit(ReportState.error(_msg(f))),
      (report) =>
          emit(ReportState.loaded(report: report, period: event.period)),
    );
  }

  Future<void> _onChangePeriod(
    _ChangePeriod event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportState.loading());
    final result = await _getReports(period: event.period);
    result.fold(
      (f) => emit(ReportState.error(_msg(f))),
      (report) =>
          emit(ReportState.loaded(report: report, period: event.period)),
    );
  }

  Future<void> _onExport(_Export event, Emitter<ReportState> emit) async {
    // On récupère la période de l'état courant
    final current = state.whenOrNull(loaded: (r, p) => (r, p));
    if (current == null) return;
    final (report, period) = current;

    emit(ReportState.exporting(report: report, period: period));

    final result = event.format == 'csv'
        ? await _exportCsv(period: period)
        : await _exportPdf(period: period);

    result.fold(
      (f) {
        emit(
          ReportState.exportError(
            report: report,
            period: period,
            message: _msg(f),
          ),
        );
        emit(ReportState.loaded(report: report, period: period));
      },
      (data) {
        emit(
          ReportState.exportSuccess(
            report: report,
            period: period,
            format: event.format,
            data: data,
          ),
        );
        emit(ReportState.loaded(report: report, period: period));
      },
    );
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  String _msg(Failure f) => f.when(
    server: (m) => m,
    network: () => 'Pas de connexion réseau',
    unauthorized: () => 'Session expirée',
    forbidden: () => 'Accès refusé — admin uniquement',
    cache: (m) => m,
    unknown: (m) => m,
  );
}
