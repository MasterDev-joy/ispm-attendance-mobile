// lib/features/courses_management/domain/usecases/save_course_usecases.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../entities/admin_course.dart';
import '../repositories/course_repository.dart';

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
