import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/error/failures.dart'; // ServerException

abstract class SettingsRemoteDataSource {
  Future<Map<String, dynamic>> checkHealth();
  Future<void> resetAttendance();
}

@LazySingleton(as: SettingsRemoteDataSource)
class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  const SettingsRemoteDataSourceImpl(this._dio, this._storage);

  @override
  Future<Map<String, dynamic>> checkHealth() async {
    final response = await _dio
        .get('${AppConfig.baseUrl}/api/health')
        .timeout(const Duration(seconds: 5));
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> resetAttendance() async {
    final token = await _storage.read(key: 'jwt_token');
    await _dio.delete(
      '${AppConfig.baseUrl}/api/admin/reset-attendance',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
