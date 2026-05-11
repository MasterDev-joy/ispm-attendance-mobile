// lib/features/profile/data/datasources/profile_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/data/models/user_model.dart'; // On réutilise le Model de l'Auth

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
  });
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<UserModel> getProfile() async {
    // Appel de la route getMe que j'ai vue dans votre auth.controller.ts
    final response = await _dio.get('/api/auth/me');
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    // Si cette route n'existe pas encore dans le backend, il faudra l'ajouter !
    // ex: router.put('/api/users/me', updateProfileController);
    final response = await _dio.put(
      '/api/users/me',
      data: {'firstName': firstName, 'lastName': lastName},
    );
    return UserModel.fromJson(response.data);
  }
}
