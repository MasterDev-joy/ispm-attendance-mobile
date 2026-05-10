// lib/features/admin/reports/domain/usecases/report_usecases.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../entities/report_data.dart';
import '../repositories/report_repository.dart';

@lazySingleton
class GetReports {
  final ReportRepository _r;
  const GetReports(this._r);

  Future<Either<Failure, GlobalReport>> call({required String period}) =>
      _r.getReports(period: period);
}

@lazySingleton
class ExportCsv {
  final ReportRepository _r;
  const ExportCsv(this._r);

  Future<Either<Failure, String>> call({required String period}) =>
      _r.exportCsv(period: period);
}

@lazySingleton
class ExportPdf {
  final ReportRepository _r;
  const ExportPdf(this._r);

  Future<Either<Failure, String>> call({required String period}) =>
      _r.exportPdf(period: period);
}
