// lib/features/session_detail/domain/repositories/session_detail_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/session_attendance.dart';

abstract class SessionDetailRepository {
  /// Récupère les détails de présence pour une session spécifique.
  Future<Either<Failure, SessionAttendance>> getSessionDetails(
    String sessionId,
  );
}
