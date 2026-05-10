// lib/features/notifications/domain/repositories/notification_repository.dart

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_notification.dart';

/// Contrat abstrait — la couche data doit l'implémenter.
/// Toutes les méthodes retournent Either<Failure, T> (jamais de throw).
abstract class NotificationRepository {
  /// Récupère toutes les notifications de l'utilisateur connecté.
  Future<Either<Failure, List<AppNotification>>> getNotifications();

  /// Marque une notification comme lue.
  Future<Either<Failure, Unit>> markAsRead(String notificationId);

  /// Marque toutes les notifications comme lues.
  Future<Either<Failure, Unit>> markAllRead();

  /// Supprime une notification.
  Future<Either<Failure, Unit>> deleteNotification(String notificationId);
}
