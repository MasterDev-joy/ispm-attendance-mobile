// lib/features/admin/reports/presentation/blocs/report_event.dart
part of 'report_bloc.dart';

@freezed
abstract class ReportEvent with _$ReportEvent {
  const factory ReportEvent.load({@Default('month') String period}) = _Load;
  const factory ReportEvent.changePeriod(String period) = _ChangePeriod;
  const factory ReportEvent.export(String format) = _Export; // 'csv' | 'pdf'
}
