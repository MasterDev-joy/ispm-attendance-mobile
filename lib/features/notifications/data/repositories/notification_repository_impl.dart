// lib/features/notifications/data/repositories/notification_repository_impl.dart

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

/// Implémentation concrète du contrat NotificationRepository.
///
/// Règles respectées :
/// - Ne throw jamais : convertit les exceptions en Left(Failure).
/// - Délègue les appels réseau à NotificationRemoteDataSource.
/// - Mappe les DTOs en entités via .toEntity().
@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remote;

  const NotificationRepositoryImpl(this._remote);

  // ── GET /api/notifications ─────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications() async {
    try {
      final models = await _remote.getNotifications();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.server(e.toString()));
    }
  }

  // ── PATCH /api/notifications/:id/read ──────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> markAsRead(String notificationId) async {
    try {
      await _remote.markAsRead(notificationId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.server(e.toString()));
    }
  }

  // ── PATCH /api/notifications/read-all ─────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> markAllRead() async {
    try {
      await _remote.markAllRead();
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.server(e.toString()));
    }
  }

  // ── DELETE /api/notifications/:id ─────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> deleteNotification(String notificationId) async {
    try {
      await _remote.deleteNotification(notificationId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.server(e.toString()));
    }
  }

  // ── Conversion DioException → Failure ─────────────────────────────────────

  Failure _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      return const Failure.unauthorized();
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const Failure.network();
    }
    return Failure.server(
      e.response?.data?['message'] as String? ?? e.message ?? 'Erreur serveur',
    );
  }
}
