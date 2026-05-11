//lib/features/session_detail/data/datasources/session_detail_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/session_attendance_model.dart';

abstract class SessionDetailRemoteDataSource {
  Future<SessionAttendanceModel> getSessionDetails(String sessionId);
}

@LazySingleton(as: SessionDetailRemoteDataSource)
class SessionDetailRemoteDataSourceImpl
    implements SessionDetailRemoteDataSource {
  final Dio _dio;
  SessionDetailRemoteDataSourceImpl(this._dio);

  @override
  Future<SessionAttendanceModel> getSessionDetails(String sessionId) async {
    // Appelle l'API pour récupérer les détails de présence de la session
    final response = await _dio.get('/api/attendance/sessions/$sessionId');
    // On suppose que la réponse contient directement les données de présence de la session
    return SessionAttendanceModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
