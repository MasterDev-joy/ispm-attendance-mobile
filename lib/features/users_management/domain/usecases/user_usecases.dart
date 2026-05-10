// lib/features/user_management/users/domain/usecases/user_usecases.dart
//
// ✅ AVANT : pas d'annotation injectable, pas de Either
//    APRÈS : @lazySingleton + Either<Failure, T>
// ─────────────────────────────────────────────────────────────────────────────
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../entities/admin_user.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetUsers {
  final UserRepository _r;
  const GetUsers(this._r);
  Future<Either<Failure, List<AdminUser>>> call() => _r.getUsers();
}

@lazySingleton
class ToggleUser {
  final UserRepository _r;
  const ToggleUser(this._r);
  Future<Either<Failure, void>> call(String id) => _r.toggleUser(id);
}

@lazySingleton
class SaveUser {
  final UserRepository _r;
  const SaveUser(this._r);

  // ✅ AVANT : logique if/else createUser vs updateUser dans le UseCase
  //    APRÈS : le repository gère la distinction — UseCase reste mince
  Future<Either<Failure, void>> call({
    String? id,
    required String firstName,
    required String lastName,
    required String email,
    required String role,
  }) => _r.saveUser(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    role: role,
  );
}
