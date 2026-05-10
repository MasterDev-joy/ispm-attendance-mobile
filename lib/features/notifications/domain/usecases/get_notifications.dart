// lib/features/notifications/domain/usecases/get_notifications.dart

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_notification.dart';
import '../repositories/notification_repository.dart';

/// Récupère la liste complète des notifications de l'utilisateur.
@lazySingleton
class GetNotifications {
  final NotificationRepository _repository;
  const GetNotifications(this._repository);

  Future<Either<Failure, List<AppNotification>>> call() =>
      _repository.getNotifications();
}
