// lib/features/attendance/data/datasources/attendance_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/dio_client.dart';
import '../../domain/entities/attendance_result.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceResult> validateAttendance({
    required String token,
    required String professorId,
    required String courseId,
  });
  Future<Set<String>> getTodayValidatedCourseIds();
  Future<String> fetchQrPayload(String courseId);
}

@LazySingleton(as: AttendanceRemoteDataSource)
class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final Dio _dio;
  AttendanceRemoteDataSourceImpl(DioClient client) : _dio = client.dio;

  @override
  Future<AttendanceResult> validateAttendance({
    required String token,
    required String professorId,
    required String courseId,
  }) async {
    final res = await _dio.post(
      '/api/attendance/validate',
      data: {'token': token, 'professorId': professorId, 'courseId': courseId},
    );
    return AttendanceResult.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<Set<String>> getTodayValidatedCourseIds() async {
    try {
      final res = await _dio.get('/api/attendance/today');
      return Set<String>.from(
          (res.data['validatedCourseIds'] as List? ?? []));
    } catch (_) {
      return {};
    }
  }

  @override
  Future<String> fetchQrPayload(String courseId) async {
    final res = await _dio.get('/api/qr/$courseId');
    return res.data['qrPayload'] as String;
  }
}
