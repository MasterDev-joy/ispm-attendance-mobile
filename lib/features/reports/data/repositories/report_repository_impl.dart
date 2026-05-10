// lib/features/admin/reports/data/repositories/report_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/dio_failure_mapper.dart';
import '../../domain/entities/report_data.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_datasource.dart';

@LazySingleton(as: ReportRepository)
class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource _remote;
  ReportRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, GlobalReport>> getReports({
    required String period,
  }) async {
    try {
      final model = await _remote.fetchReports(period: period);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportCsv({required String period}) async {
    try {
      return Right(await _remote.fetchExportCsv(period: period));
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportPdf({required String period}) async {
    try {
      return Right(await _remote.fetchExportPdf(period: period));
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
