// lib/features/schedule/domain/repositories/schedule_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failures.dart';
import '../entities/course.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, List<Course>>> getMyCourses();
}
