import '../entities/user.dart';

abstract class AuthRepository {
  // Connexion classique
  Future<User> login(String email, String password);

  // Connexion biométrique (Empreinte/FaceID)
  Future<User> loginWithBiometrics();

  // Pour la sécurité : changer le mot de passe temporaire
  Future<void> updatePassword(String userId, String newPassword);

  Future<User?> getCurrentUser();

  Future<void> logout();
}