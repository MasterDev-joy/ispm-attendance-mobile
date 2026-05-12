// lib/features/session_detail/domain/usecases/export_session_pdf_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/session_pdf_service.dart';
import 'export_session_pdf_params.dart';

@lazySingleton
class ExportSessionPdfUsecase {
  final SessionPdfService _pdfService;

  ExportSessionPdfUsecase(this._pdfService);

  Future<Either<Failure, Unit>> call(ExportSessionPdfParams params) {
    return _pdfService.generateAndSharePdf(params);
  }
}
