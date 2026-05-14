// lib/features/courses_management/data/datasources/course_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/dio_client.dart';
import '../models/admin_course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<AdminCourseModel>> fetchCourses();
  Future<void> saveCourse({
    String? id,
    required String title,
    required String fieldOfStudy,
    required String professorId,
    required DateTime startTime,
    required DateTime endTime,
  });
  Future<void> deleteCourse(String id);
}

@LazySingleton(as: CourseRemoteDataSource)
class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final Dio _dio;
  CourseRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<List<AdminCourseModel>> fetchCourses() async {
    final res = await _dio.get('/api/admin/courses');
    final list = (res.data as List)
        .map((j) => AdminCourseModel.fromJson(j as Map<String, dynamic>))
        .toList();
    list.sort((a, b) => a.startTime.compareTo(b.startTime));
    return list;
  }

  @override
  Future<void> saveCourse({
    String? id,
    required String title,
    required String fieldOfStudy,
    required String professorId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final body = {
      'title': title,
      'fieldOfStudy': fieldOfStudy,
      'professorId': professorId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
    if (id != null) {
      await _dio.put('/api/admin/courses/$id', data: body);
    } else {
      await _dio.post('/api/admin/courses', data: body);
    }
  }

  @override
  Future<void> deleteCourse(String id) => _dio.delete('/api/admin/courses/$id');
}
