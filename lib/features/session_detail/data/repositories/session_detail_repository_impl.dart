// lib/features/session_detail/data/repositories/session_detail_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/dio_failure_mapper.dart'; // Votre mapper
import '../../../../core/error/failures.dart';
import '../../domain/entities/session_attendance.dart';
import '../../domain/repositories/session_detail_repository.dart';
import '../datasources/session_detail_remote_datasource.dart';

@LazySingleton(as: SessionDetailRepository)
class SessionDetailRepositoryImpl implements SessionDetailRepository {
  final SessionDetailRemoteDataSource _remoteDataSource;

  SessionDetailRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, SessionAttendance>> getSessionDetails(
    String sessionId,
  ) async {
    try {
      // Appel du DataSource épuré
      final sessionModel = await _remoteDataSource.getSessionDetails(sessionId);
      // Conversion réussie vers l'Entité pure
      return Right(sessionModel.toEntity());
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
