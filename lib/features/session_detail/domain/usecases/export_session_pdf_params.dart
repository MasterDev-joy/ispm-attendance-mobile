// lib/features/session_detail/domain/usecases/export_session_pdf_params.dart
import '../entities/session_attendance.dart';

class ExportSessionPdfParams {
  final String courseTitle;
  final String fieldOfStudy;
  final DateTime startTime;
  final DateTime endTime;
  final SessionAttendance? attendance;

  const ExportSessionPdfParams({
    required this.courseTitle,
    required this.fieldOfStudy,
    required this.startTime,
    required this.endTime,
    this.attendance,
  });
}
