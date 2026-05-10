import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../entities/admin_course.dart';
import '../repositories/course_repository.dart';

@lazySingleton
class DeleteCourse {
  final CourseRepository _r;
  const DeleteCourse(this._r);
  Future<Either<Failure, void>> call(String id) => _r.deleteCourse(id);
}
