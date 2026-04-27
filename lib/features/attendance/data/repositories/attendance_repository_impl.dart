import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ispm_attendance/core/config/app_config.dart';
import '../../domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {

  final FlutterSecureStorage secureStorage;

  AttendanceRepositoryImpl({required this.secureStorage});

  @override
  Future<Map<String, dynamic>> validateAttendance({
    required String token,
    required String professorId,
    required String courseId,
  }) async {
    // 1. On récupère le "badge" (JWT) du surveillant connecté
    final jwtToken = await secureStorage.read(key: 'jwt_token');

    if (jwtToken == null) {
      throw Exception('Surveillant non authentifié');
    }

    // 2. On prépare la requête vers Node.js
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/api/attendance/validate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      // 3. On envoie les 3 morceaux découpés du QR Code
      body: jsonEncode({
        'token': token,
        'professorId': professorId,
        'courseId': courseId,
      }),
    );

    // 4. On analyse la réponse du serveur
    if (response.statusCode == 201 || response.statusCode == 200) {
      // Succès ! Le serveur renvoie le nom et la photo du prof pour la validation visuelle
      return jsonDecode(response.body);
    } else {
      // Erreur (QR code expiré, déjà validé, etc.)
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Erreur lors de la validation');
    }
  }
}