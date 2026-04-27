// lib/features/schedule/data/repositories/schedule_repository_impl.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ispm_attendance/core/config/app_config.dart';
import '../../../auth/data/daos/auth_local_dao.dart';
import '../models/course_model.dart';
import '../../domain/entities/course.dart';

class ScheduleRepositoryImpl {
  final http.Client client;
  final AuthLocalDao localDao;

  ScheduleRepositoryImpl({required this.client, required this.localDao});

  Future<List<Course>> getMyCourses() async {
    // 1. On récupère le "passeport" (Token) du professeur
    final token = await localDao.getToken();

    // 2. On fait la requête au serveur
    final response = await client.get(
      Uri.parse('${AppConfig.baseUrl}/api/courses/my-schedule'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('--- DEBUG SCHEDULE ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    // 3. On traite la réponse
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CourseModel.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des cours');
    }
  }
}