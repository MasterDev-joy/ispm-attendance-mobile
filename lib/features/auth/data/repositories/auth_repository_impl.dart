import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl(this._remote, this._local);

  // ─── Helper : convertit DioException → Failure ───────────────────────────

  Failure _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) return const Failure.unauthorized();
    final msg =
        (e.response?.data as Map?)?['error']?.toString() ??
        e.message ??
        'Erreur réseau';
    return Failure.server(msg);
  }

  // ─── Login ────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final result = await _remote.login(email, password);
      await _local.saveToken(result.token);
      return Right(result.user.toEntity());
    } on DioException catch (e) {
      debugPrint("ERREUR CACHÉE : ${e.error}");
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  // ─── Check current user ───────────────────────────────────────────────────

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final token = await _local.getToken();
      if (token == null) return const Right(null);

      final result = await _remote.getCurrentUser(token);
      await _local.saveIsFirstLogin(result.user.isFirstLogin);
      return Right(result.user.toEntity());
    } on DioException catch (e) {
      // Token expiré → nettoyage silencieux
      if (e.response?.statusCode == 401) {
        await _local.deleteToken();
        return const Right(null);
      }
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  // ─── Change password ──────────────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> updatePassword(
    String userId,
    String newPassword,
  ) async {
    try {
      final token = await _local.getToken();
      if (token == null) return const Left(Failure.unauthorized());

      await _remote.updatePassword(userId, newPassword, token);
      await _local.saveIsFirstLogin(false);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  // ─── Logout ───────────────────────────────────────────────────────────────

  @override
  Future<void> logout() => _local.deleteToken();

  // ─── Biométrie (non implémentée) ──────────────────────────────────────────

  @override
  Future<Either<Failure, User>> loginWithBiometrics() async =>
      const Left(Failure.unknown('Biométrie non encore implémentée'));
}
