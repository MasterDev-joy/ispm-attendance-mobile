import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDao {
  final FlutterSecureStorage storage;

  AuthLocalDao({required this.storage});

  // Sauvegarde le Token JWT de manière sécurisée
  Future<void> saveToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  // Récupère le Token JWT (utile pour les requêtes futures)
  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  // Supprime le Token (pour la déconnexion)
  Future<void> deleteToken() async {
    await storage.delete(key: 'jwt_token');
  }
}