// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<({UserModel user, String token})> login(String email, String password);
  Future<({UserModel user, String token})> getCurrentUser(String token);
  Future<void> updatePassword(String userId, String newPassword, String token);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<({UserModel user, String token})> login(
    String email,
    String password,
  ) async {
    final response = await _dio.post(
      '/api/auth/login',
      data: {'email': email, 'password': password},
    );
    return (
      user: UserModel.fromJson(response.data['user'] as Map<String, dynamic>),
      token: response.data['token'] as String,
    );
  }

  @override
  Future<({UserModel user, String token})> getCurrentUser(String token) async {
    final response = await _dio.get(
      '/api/auth/me',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (
      user: UserModel.fromJson(response.data['user'] as Map<String, dynamic>),
      token: token,
    );
  }

  @override
  Future<void> updatePassword(
    String userId,
    String newPassword,
    String token,
  ) async {
    await _dio.post(
      '/api/auth/change-password',
      data: {'newPassword': newPassword},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
