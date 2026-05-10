// lib/features/stats/data/repositories/stats_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/dio_failure_mapper.dart';
import '../../domain/entities/stats_data.dart';
import '../../domain/repositories/stats_repository.dart';
import '../datasources/stats_remote_datasource.dart';

@LazySingleton(as: StatsRepository)
class StatsRepositoryImpl implements StatsRepository {
  final StatsRemoteDataSource _remote;
  StatsRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, GlobalStats>> getStats(StatsPeriod period) async {
    try {
      return Right(await _remote.fetchStats(period));
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
