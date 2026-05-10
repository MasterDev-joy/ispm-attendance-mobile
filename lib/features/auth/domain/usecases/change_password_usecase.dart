// lib/features/auth/domain/usecases/change_password_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class ChangePasswordUseCase {
  final AuthRepository _repository;
  ChangePasswordUseCase(this._repository);

  Future<Either<Failure, void>> call(String userId, String newPassword) =>
      _repository.updatePassword(userId, newPassword);
}
