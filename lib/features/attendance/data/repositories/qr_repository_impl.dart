// lib/features/attendance/data/repositories/qr_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ispm_attendance/core/config/app_config.dart';
import '../../domain/repositories/qr_repository.dart';

/// ✅ Repository responsable de récupérer le payload QR depuis le serveur.
/// Le secret HMAC ne quitte JAMAIS le backend — Flutter reçoit seulement le résultat.
class QrRepositoryImpl implements QrRepository {
  final FlutterSecureStorage secureStorage;

  QrRepositoryImpl({required this.secureStorage});

  /// Appelle GET /api/qr/:courseId et retourne le payload QR à afficher.
  /// Le payload a le format : "token|professorId|courseId"
  @override
  Future<String> fetchQrPayload(String courseId) async {
    final jwtToken = await secureStorage.read(key: 'jwt_token');

    if (jwtToken == null) {
      throw Exception('Professeur non authentifié');
    }

    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/qr/$courseId'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['qrPayload'] as String;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Impossible de récupérer le QR code');
    }
  }
}
