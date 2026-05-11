// lib/features/notifications/data/datasources/notification_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/dio_client.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllRead();
  Future<void> deleteNotification(String notificationId);
}

@LazySingleton(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio _dio;
  NotificationRemoteDataSourceImpl(this._dio);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final res = await _dio.get('/api/notifications');
    return (res.data as List)
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> markAsRead(String notificationId) =>
      _dio.patch('/api/notifications/$notificationId/read');

  @override
  Future<void> markAllRead() => _dio.patch('/api/notifications/read-all');

  @override
  Future<void> deleteNotification(String notificationId) =>
      _dio.delete('/api/notifications/$notificationId');
}
