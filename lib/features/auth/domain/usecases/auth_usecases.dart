// lib/features/auth/domain/usecases/auht_usecases.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

// ─── Login ────────────────────────────────────────────────────────────────────

@lazySingleton
class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<Either<Failure, User>> call(String email, String password) =>
      _repository.login(email, password);
}

// ─── Check Auth Status ────────────────────────────────────────────────────────

@lazySingleton
class CheckAuthStatusUseCase {
  final AuthRepository _repository;
  CheckAuthStatusUseCase(this._repository);

  Future<Either<Failure, User?>> call() => _repository.getCurrentUser();
}

// ─── Change Password ──────────────────────────────────────────────────────────

@lazySingleton
class ChangePasswordUseCase {
  final AuthRepository _repository;
  ChangePasswordUseCase(this._repository);

  Future<Either<Failure, void>> call(String userId, String newPassword) =>
      _repository.updatePassword(userId, newPassword);
}

// ─── Logout ───────────────────────────────────────────────────────────────────

@lazySingleton
class LogoutUseCase {
  final AuthRepository _repository;
  LogoutUseCase(this._repository);

  Future<void> call() => _repository.logout();
}
