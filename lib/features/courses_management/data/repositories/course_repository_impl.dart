// lib/features/admin/courses/data/repositories/course_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/dio_failure_mapper.dart';
import '../../domain/entities/admin_course.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_datasource.dart';

@LazySingleton(as: CourseRepository)
class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource _remote;
  CourseRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<AdminCourse>>> getCourses() async {
    try {
      final models = await _remote.fetchCourses();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveCourse({
    String? id,
    required String title,
    required String fieldOfStudy,
    required String professorId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      await _remote.saveCourse(
        id: id,
        title: title,
        fieldOfStudy: fieldOfStudy,
        professorId: professorId,
        startTime: startTime,
        endTime: endTime,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCourse(String id) async {
    try {
      await _remote.deleteCourse(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
