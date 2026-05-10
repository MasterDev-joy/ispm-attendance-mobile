// lib/features/auth/domain/usecases/check_auth_status_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class CheckAuthStatusUseCase {
  final AuthRepository _repository;
  CheckAuthStatusUseCase(this._repository);

  Future<Either<Failure, User?>> call() => _repository.getCurrentUser();
}
