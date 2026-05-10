// lib/features/users_management/domain/usecases/saver_user_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../entities/admin_user.dart';
import '../repositories/user_repository.dart';

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
