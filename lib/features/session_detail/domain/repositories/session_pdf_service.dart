// lib/features/session_detail/domain/repositories/session_pdf_service.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../usecases/export_session_pdf_params.dart';

abstract class SessionPdfService {
  Future<Either<Failure, Unit>> generateAndSharePdf(
    ExportSessionPdfParams params,
  );
}
