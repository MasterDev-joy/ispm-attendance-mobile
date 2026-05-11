import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/server_status.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_datasource.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource _remote;
  const SettingsRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, ServerStatus>> checkServerHealth() async {
    try {
      final data = await _remote.checkHealth();
      return Right(
        ServerStatus(
          isOnline: true,
          message: data['message'] as String? ?? 'Opérationnel',
          baseUrl: AppConfig.baseUrl,
        ),
      );
    } catch (_) {
      return Right(
        ServerStatus(
          isOnline: false,
          message: 'Hors ligne',
          baseUrl: AppConfig.baseUrl,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> resetAttendance() async {
    try {
      await _remote.resetAttendance();
      return const Right(unit);
    } on DioException catch (e) {
      return Left(Failure.server(e.message ?? 'Erreur réseau'));
    }
  }
}
