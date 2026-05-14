// lib/features/admin/reports/data/datasources/report_remote_datasource.dart
//
// ✅ http.Client + FlutterSecureStorage → DioClient centralisé
//    Le token JWT est injecté automatiquement par l'intercepteur du DioClient.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/dio_client.dart';
import '../models/report_model.dart';

abstract class ReportRemoteDataSource {
  Future<GlobalReportModel> fetchReports({required String period});
  Future<String> fetchExportCsv({required String period});
  Future<String> fetchExportPdf({required String period});
}

@LazySingleton(as: ReportRemoteDataSource)
class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final Dio _dio;
  ReportRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<GlobalReportModel> fetchReports({required String period}) async {
    final res = await _dio.get(
      '/api/reports',
      queryParameters: {'period': period},
    );
    return GlobalReportModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<String> fetchExportCsv({required String period}) async {
    final res = await _dio.get(
      '/api/reports/export',
      queryParameters: {'format': 'csv', 'period': period},
    );
    return res.data as String;
  }

  @override
  Future<String> fetchExportPdf({required String period}) async {
    final res = await _dio.get(
      '/api/reports/export',
      queryParameters: {'format': 'pdf', 'period': period},
    );
    return res.data as String;
  }
}
