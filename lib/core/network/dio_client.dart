// lib/core/network/dio_client.dart
//
// Client Dio centralisé — remplace tous les http.Client dispersés.
// L'intercepteur injecte automatiquement le token JWT sur chaque requête.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../config/app_config.dart';

@lazySingleton
class DioClient {
  late final Dio dio;

  DioClient(FlutterSecureStorage storage) {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Intercepteur JWT — injecté automatiquement sur toutes les requêtes
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read(key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }
}
