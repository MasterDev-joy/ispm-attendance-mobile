// lib/core/error/dio_failure_mapper.dart
//
// Utilitaire partagé : convertit une DioException en Failure.
// À importer dans tous les RepositoryImpl.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:dio/dio.dart';
import 'failures.dart';

Failure mapDioFailure(DioException e) {
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    return const Failure.network();
  }
  final status = e.response?.statusCode;
  if (status == 401) return const Failure.unauthorized();
  if (status == 403) return const Failure.forbidden();

  final msg =
      (e.response?.data as Map?)?['error']?.toString() ??
      e.message ??
      'Erreur réseau';
  return Failure.server(msg);
}
