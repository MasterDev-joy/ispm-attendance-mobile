// lib/features/notifications/domain/usecases/delete_notification.dart

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/notification_repository.dart';

@lazySingleton
class DeleteNotification {
  final NotificationRepository _repository;
  const DeleteNotification(this._repository);

  Future<Either<Failure, Unit>> call(String notificationId) =>
      _repository.deleteNotification(notificationId);
}
