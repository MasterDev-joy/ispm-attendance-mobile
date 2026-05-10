// lib/features/users_management/domain/repositories/user_repository.dart
//
// ✅ AVANT : Future<void> — throw si erreur
//    APRÈS : Either<Failure, T> — pas de throw, erreurs typées
// ─────────────────────────────────────────────────────────────────────────────
import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failures.dart';
import '../entities/admin_user.dart';

abstract class UserRepository {
  Future<Either<Failure, List<AdminUser>>> getUsers();
  Future<Either<Failure, void>> toggleUser(String id);
  Future<Either<Failure, void>> saveUser({
    String? id, // null = création
    required String firstName,
    required String lastName,
    required String email,
    required String role,
  });
}
