// lib/features/schedule/domain/usecases/get_my_courses.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../entities/course.dart';
import '../repositories/schedule_repository.dart';

@lazySingleton
class GetMyCourses {
  final ScheduleRepository _repository;
  const GetMyCourses(this._repository);

  Future<Either<Failure, List<Course>>> call() => _repository.getMyCourses();
}
