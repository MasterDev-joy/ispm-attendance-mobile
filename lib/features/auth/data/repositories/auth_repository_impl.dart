import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ispm_attendance/core/config/app_config.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../daos/auth_local_dao.dart';

class AuthRepositoryImpl implements AuthRepository {
  final http.Client client;
  final AuthLocalDao localDao;
  AuthRepositoryImpl({required this.client, required this.localDao});

  @override
  Future<User> login(String email, String password) async {
    // 1. Appel au serveur Node.js
    final response = await client.post(
      Uri.parse('${AppConfig.baseUrl}/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // 2. Sauvegarde du token avec notre nouveau DAO
      await localDao.saveToken(data['token']);

      // 3. Retourne l'utilisateur formaté
      return UserModel.fromJson(data['user']);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Erreur de connexion');
    }
  }

  @override
  Future<void> updatePassword(String userId, String newPassword) async {
    final token = await localDao.getToken();
    final response = await client.put(
      Uri.parse('${AppConfig.baseUrl}/api/auth/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'newPassword': newPassword}),
    );

    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Erreur de changement de mot de passe');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    // Si on a un token, on considère que l'utilisateur est connecté.
    // (Dans un projet plus avancé, on appellerait une route /me sur le serveur pour revérifier le token)
    final token = await localDao.getToken();
    if (token != null) {
      // Retourne un utilisateur "bouchon" juste pour passer le Splash Screen
      return const UserModel(id: '1', email: '', name: 'Professeur', role: 'PROFESSOR', isFirstLogin: false);
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await localDao.deleteToken();
  }

  @override
  Future<User> loginWithBiometrics() async {
    throw UnimplementedError('La biométrie sera implémentée plus tard');
  }
}