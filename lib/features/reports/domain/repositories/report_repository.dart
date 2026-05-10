// lib/features/admin/reports/domain/repositories/report_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failures.dart';
import '../entities/report_data.dart';

abstract class ReportRepository {
  Future<Either<Failure, GlobalReport>> getReports({required String period});
  Future<Either<Failure, String>> exportCsv({required String period});
  Future<Either<Failure, String>> exportPdf({required String period});
}
