// lib/features/reports/domain/usecases/export_csv.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../entities/report_data.dart';
import '../repositories/report_repository.dart';

@lazySingleton
class ExportCsv {
  final ReportRepository _r;
  const ExportCsv(this._r);

  Future<Either<Failure, String>> call({required String period}) =>
      _r.exportCsv(period: period);
}
