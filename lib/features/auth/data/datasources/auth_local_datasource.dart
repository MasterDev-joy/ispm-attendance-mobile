import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<void> saveIsFirstLogin(bool value);
  Future<bool?> getIsFirstLogin();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;
  AuthLocalDataSourceImpl(this._storage);

  static const _tokenKey = 'jwt_token';
  static const _firstLoginKey = 'isFirstLogin';

  @override
  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  @override
  Future<String?> getToken() => _storage.read(key: _tokenKey);

  @override
  Future<void> deleteToken() => _storage.delete(key: _tokenKey);

  @override
  Future<void> saveIsFirstLogin(bool value) =>
      _storage.write(key: _firstLoginKey, value: value.toString());

  @override
  Future<bool?> getIsFirstLogin() async {
    final raw = await _storage.read(key: _firstLoginKey);
    if (raw == null) return null;
    return raw == 'true';
  }
}
