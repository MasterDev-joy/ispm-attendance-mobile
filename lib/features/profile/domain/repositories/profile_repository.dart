// lib/features/profile/domain/repositories/profile_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';

abstract class ProfileRepository {
  /// Récupère les informations fraîches du profil depuis le serveur
  Future<Either<Failure, User>> getProfile();

  /// Met à jour les informations de base de l'utilisateur
  Future<Either<Failure, User>> updateProfile({
    required String firstName,
    required String lastName,
  });
}
