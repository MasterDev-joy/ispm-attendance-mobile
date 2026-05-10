// lib/features/attendance/data/repositories/attendance_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/dio_failure_mapper.dart';
import '../../domain/entities/attendance_result.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_datasource.dart';

@LazySingleton(as: AttendanceRepository)
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource _remote;
  AttendanceRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, AttendanceResult>> validateAttendance({
    required String token,
    required String professorId,
    required String courseId,
  }) async {
    try {
      final result = await _remote.validateAttendance(
        token: token,
        professorId: professorId,
        courseId: courseId,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Set<String>>> getTodayValidatedCourseIds() async {
    try {
      return Right(await _remote.getTodayValidatedCourseIds());
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}

@LazySingleton(as: QrRepository)
class QrRepositoryImpl implements QrRepository {
  final AttendanceRemoteDataSource _remote;
  QrRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, String>> fetchQrPayload(String courseId) async {
    try {
      return Right(await _remote.fetchQrPayload(courseId));
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
