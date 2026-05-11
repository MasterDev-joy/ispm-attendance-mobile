import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/server_status.dart';
import '../repositories/settings_repository.dart';

@lazySingleton
class CheckServerHealth {
  final SettingsRepository _repository;
  const CheckServerHealth(this._repository);

  Future<Either<Failure, ServerStatus>> call() =>
      _repository.checkServerHealth();
}
