// lib/features/admin/courses/domain/usecases/course_usecases.dart
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

@lazySingleton
class SaveCourse {
  final CourseRepository _r;
  const SaveCourse(this._r);
  Future<Either<Failure, void>> call({
    String? id,
    required String title,
    required String fieldOfStudy,
    required String professorId,
    required DateTime startTime,
    required DateTime endTime,
  }) => _r.saveCourse(
    id: id,
    title: title,
    fieldOfStudy: fieldOfStudy,
    professorId: professorId,
    startTime: startTime,
    endTime: endTime,
  );
}

@lazySingleton
class DeleteCourse {
  final CourseRepository _r;
  const DeleteCourse(this._r);
  Future<Either<Failure, void>> call(String id) => _r.deleteCourse(id);
}
