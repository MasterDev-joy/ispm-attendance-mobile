// lib/features/session_detail/data/datasources/session_pdf_service_impl.dart
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/session_attendance.dart';
import '../../domain/repositories/session_pdf_service.dart';
import '../../domain/usecases/export_session_pdf_params.dart';

@LazySingleton(as: SessionPdfService)
class SessionPdfServiceImpl implements SessionPdfService {
  @override
  Future<Either<Failure, Unit>> generateAndSharePdf(
    ExportSessionPdfParams params,
  ) async {
    try {
      final pdf = _buildDocument(params);

      final dir = await getTemporaryDirectory();
      final safeName = params.courseTitle.replaceAll(
        RegExp(r'[^a-zA-Z0-9]'),
        '_',
      );
      final file = File(
        '${dir.path}/PV_${safeName}_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([
        XFile(file.path),
      ], subject: 'PV de présence — ${params.courseTitle}');

      return right(unit);
    } catch (e) {
      return left(const Failure.cache('Erreur lors de l\'export PDF'));
    }
  }

  // ─── Builders privés ─────────────────────────────────────────────────

  pw.Document _buildDocument(ExportSessionPdfParams params) {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (ctx) => _buildPage(params),
      ),
    );
    return pdf;
  }

  pw.Widget _buildPage(ExportSessionPdfParams params) {
    final fmt = DateFormat('dd/MM/yyyy HH:mm');
    final dateOnly = DateFormat('dd MMMM yyyy', 'fr_FR');
    final att = params.attendance;

    final statusLabel = att == null
        ? 'Non scanné'
        : att.status == AttendanceStatus.onTime
        ? 'Présent (à l\'heure)'
        : 'ABSENT';

    final statusColor = att == null
        ? PdfColors.grey
        : att.status == AttendanceStatus.onTime
        ? PdfColors.green700
        : PdfColors.red700;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildHeader(dateOnly.format(DateTime.now())),
        pw.Divider(height: 24, color: PdfColors.grey300),
        _buildCourseSection(params, fmt),
        pw.SizedBox(height: 20),
        _buildAttendanceSection(att, statusLabel, statusColor, fmt),
        pw.Spacer(),
        pw.Divider(color: PdfColors.grey300),
        pw.Text(
          'Document généré automatiquement par l\'application ISPM Présence',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey500),
        ),
      ],
    );
  }

  pw.Widget _buildHeader(String date) => pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(
        'ISPM — PV de présence',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.Text(
        date,
        style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
      ),
    ],
  );

  pw.Widget _buildCourseSection(
    ExportSessionPdfParams params,
    DateFormat fmt,
  ) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'Informations de la séance',
        style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
      _pdfRow('Cours', params.courseTitle),
      _pdfRow('Filière', params.fieldOfStudy),
      _pdfRow('Début', fmt.format(params.startTime)),
      _pdfRow('Fin', fmt.format(params.endTime)),
    ],
  );

  pw.Widget _buildAttendanceSection(
    SessionAttendance? att,
    String statusLabel,
    PdfColor statusColor,
    DateFormat fmt,
  ) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'Présence du professeur',
        style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(14),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey100,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              statusLabel,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: statusColor,
              ),
            ),
            pw.SizedBox(height: 6),
            if (att?.scanTime != null)
              _pdfRow('Heure de scan', fmt.format(att!.scanTime!)),
            if (att?.supervisor?.name != null)
              _pdfRow('Validé par', att!.supervisor!.name),
            if (att?.supervisor?.email != null)
              _pdfRow('Contact', att!.supervisor!.email),
            if (att == null)
              pw.Text(
                'Aucun enregistrement de scan pour cette séance.',
                style: const pw.TextStyle(
                  fontSize: 11,
                  color: PdfColors.grey600,
                ),
              ),
          ],
        ),
      ),
    ],
  );

  pw.Widget _pdfRow(String label, String value) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 3),
    child: pw.Row(
      children: [
        pw.SizedBox(
          width: 120,
          child: pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
      ],
    ),
  );
}
