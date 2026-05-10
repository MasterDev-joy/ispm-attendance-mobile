// lib/features/admin/courses/domain/repositories/course_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failures.dart';
import '../entities/admin_course.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<AdminCourse>>> getCourses();
  Future<Either<Failure, void>> saveCourse({
    String? id,
    required String title,
    required String fieldOfStudy,
    required String professorId,
    required DateTime startTime,
    required DateTime endTime,
  });
  Future<Either<Failure, void>> deleteCourse(String id);
}
