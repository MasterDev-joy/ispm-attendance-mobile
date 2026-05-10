// lib/features/notifications/domain/usecases/mark_notification_as_read.dart

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/notification_repository.dart';

@lazySingleton
class MarkNotificationAsRead {
  final NotificationRepository _repository;
  const MarkNotificationAsRead(this._repository);

  Future<Either<Failure, Unit>> call(String notificationId) =>
      _repository.markAsRead(notificationId);
}
