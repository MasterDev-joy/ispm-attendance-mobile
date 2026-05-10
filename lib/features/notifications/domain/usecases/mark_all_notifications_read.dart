// lib/features/notifications/domain/usecases/mark_all_notifications_read.dart

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/notification_repository.dart';

@lazySingleton
class MarkAllNotificationsRead {
  final NotificationRepository _repository;
  const MarkAllNotificationsRead(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.markAllRead();
}
