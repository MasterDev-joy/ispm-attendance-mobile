import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/server_status.dart';

abstract class SettingsRepository {
  Future<Either<Failure, ServerStatus>> checkServerHealth();
  Future<Either<Failure, Unit>> resetAttendance();
}
