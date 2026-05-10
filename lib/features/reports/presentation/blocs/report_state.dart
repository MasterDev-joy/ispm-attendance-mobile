// lib/features/admin/reports/presentation/blocs/report_state.dart
//
// ✅ AVANT : 6 classes Equatable séparées (ReportInitial, ReportLoading…)
//    APRÈS : 1 sealed class freezed avec 6 factories
//    → state.when() / state.whenOrNull() dans les pages
// ─────────────────────────────────────────────────────────────────────────────
part of 'report_bloc.dart';

@freezed
abstract class ReportState with _$ReportState {
  const factory ReportState.initial() = _Initial;
  const factory ReportState.loading() = _Loading;
  const factory ReportState.loaded({
    required GlobalReport report,
    required String period,
  }) = _Loaded;
  const factory ReportState.exporting({
    required GlobalReport report,
    required String period,
  }) = _Exporting;
  const factory ReportState.exportSuccess({
    required GlobalReport report,
    required String period,
    required String format,
    required String data,
  }) = _ExportSuccess;
  const factory ReportState.exportError({
    required GlobalReport report,
    required String period,
    required String message,
  }) = _ExportError;
  const factory ReportState.error(String message) = _Error;
}
