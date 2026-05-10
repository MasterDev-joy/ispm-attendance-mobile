// lib/features/schedule/data/repositories/schedule_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/dio_failure_mapper.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/schedule_remote_datasource.dart';

@LazySingleton(as: ScheduleRepository)
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource _remote;
  ScheduleRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<Course>>> getMyCourses() async {
    try {
      final models = await _remote.fetchMyCourses();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
