// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> loginWithBiometrics();
  Future<Either<Failure, void>> updatePassword(
    String userId,
    String newPassword,
  );
  Future<Either<Failure, User?>> getCurrentUser();
  Future<void> logout();
}
