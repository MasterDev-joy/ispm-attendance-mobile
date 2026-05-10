// lib/features/reports/domain/usecases/export_pdf.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../entities/report_data.dart';
import '../repositories/report_repository.dart';

@lazySingleton
class ExportPdf {
  final ReportRepository _r;
  const ExportPdf(this._r);

  Future<Either<Failure, String>> call({required String period}) =>
      _r.exportPdf(period: period);
}
