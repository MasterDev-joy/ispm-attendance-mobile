// lib/features/auth/domain/usecases/logout_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class LogoutUseCase {
  final AuthRepository _repository;
  LogoutUseCase(this._repository);

  Future<void> call() => _repository.logout();
}
