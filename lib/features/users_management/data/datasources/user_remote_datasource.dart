// lib/features/admin/users/data/datasources/user_remote_datasource.dart
//
// ✅ AVANT : http.Client + FlutterSecureStorage manuels
//    APRÈS : DioClient centralisé (token JWT injecté automatiquement)
// ─────────────────────────────────────────────────────────────────────────────
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../models/admin_user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<AdminUserModel>> fetchUsers();
  Future<void> toggleUser(String id);
  Future<void> saveUser({
    String? id,
    required String firstName,
    required String lastName,
    required String email,
    required String role,
  });
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;
  UserRemoteDataSourceImpl(this._dio);

  @override
  Future<List<AdminUserModel>> fetchUsers() async {
    final res = await _dio.get('/api/admin/users');
    return (res.data as List)
        .map((j) => AdminUserModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> toggleUser(String id) =>
      _dio.patch('/api/admin/users/$id/toggle');

  @override
  Future<void> saveUser({
    String? id,
    required String firstName,
    required String lastName,
    required String email,
    required String role,
  }) async {
    final body = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
    };
    if (id != null) {
      await _dio.put('/api/admin/users/$id', data: body);
    } else {
      await _dio.post('/api/admin/users', data: body);
    }
  }
}
