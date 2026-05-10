// lib/features/attendance/domain/repositories/attendance_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failures.dart';
import '../entities/attendance_result.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, AttendanceResult>> validateAttendance({
    required String token,
    required String professorId,
    required String courseId,
  });

  Future<Either<Failure, Set<String>>> getTodayValidatedCourseIds();
}

// lib/features/attendance/domain/repositories/qr_repository.dart
abstract class QrRepository {
  Future<Either<Failure, String>> fetchQrPayload(String courseId);
}
