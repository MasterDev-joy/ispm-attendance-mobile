import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/settings_repository.dart';

@lazySingleton
class ResetAttendance {
  final SettingsRepository _repository;
  const ResetAttendance(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.resetAttendance();
}
