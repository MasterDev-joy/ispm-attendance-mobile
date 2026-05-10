// lib/features/courses_management/domain/usecases/get_courses_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../entities/admin_course.dart';
import '../repositories/course_repository.dart';

@lazySingleton
class GetCourses {
  final CourseRepository _r;
  const GetCourses(this._r);
  Future<Either<Failure, List<AdminCourse>>> call() => _r.getCourses();
}
