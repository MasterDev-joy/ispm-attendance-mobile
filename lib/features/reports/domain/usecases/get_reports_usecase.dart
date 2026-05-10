// lib/features/reports/domain/usecases/get_reports_usecase.dart
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
