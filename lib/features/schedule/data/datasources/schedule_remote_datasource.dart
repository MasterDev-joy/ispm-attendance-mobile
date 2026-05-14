// lib/features/schedule/data/datasources/schedule_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/dio_client.dart';
import '../models/course_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<List<CourseModel>> fetchMyCourses();
}

@LazySingleton(as: ScheduleRemoteDataSource)
class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final Dio _dio;
  ScheduleRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<List<CourseModel>> fetchMyCourses() async {
    final res = await _dio.get('/api/courses/my-schedule');
    return (res.data as List)
        .map((j) => CourseModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
