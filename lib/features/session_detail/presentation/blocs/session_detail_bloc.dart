// lib/features/session_detail/presentation/blocs/session_detail_bloc.dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/session_attendance.dart';
import 'session_detail_event.dart';
import 'session_detail_state.dart';

class SessionDetailBloc
    extends Bloc<SessionDetailEvent, SessionDetailState> {
  SessionDetailBloc() : super(SessionDetailInitial()) {
    on<LoadSessionDetailEvent>(_onLoad);
    on<ExportPdfEvent>(_onExportPdf);
  }

  Future<void> _onLoad(
      LoadSessionDetailEvent event, Emitter<SessionDetailState> emit) async {
    emit(SessionDetailLoading());
    try {
      // TODO: Remplacer par → GET /api/attendance/course/:courseId
      // Réponse attendue : { id, status, scanTime, invigilator: { name, email } }
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock : simule un scan ON_TIME
      final attendance = SessionAttendance(
        id: 'att-001',
        status: AttendanceStatus.onTime,
        scanTime: event.course.startTime.add(const Duration(minutes: 3)),
        invigilatorName: 'Jean Rakoto',
        invigilatorEmail: 'j.rakoto@ispm.mg',
      );

      emit(SessionDetailLoaded(course: event.course, attendance: attendance));
    } catch (e) {
      emit(SessionDetailError('Impossible de charger la séance : $e'));
    }
  }

  Future<void> _onExportPdf(
      ExportPdfEvent event, Emitter<SessionDetailState> emit) async {
    final current = state;
    if (current is! SessionDetailLoaded) return;

    emit(current.copyWith(isExporting: true));

    try {
      final pdf = pw.Document();
      final course = current.course;
      final att = current.attendance;
      final fmt = DateFormat('dd/MM/yyyy HH:mm');
      final dateOnly = DateFormat('dd MMMM yyyy', 'fr_FR');

      final statusLabel = att == null
          ? 'Non scanné'
          : att.status == AttendanceStatus.onTime
              ? 'Présent (à l\'heure)'
              : 'Absent';

      final statusColor = att == null
          ? PdfColors.grey
          : att.status == AttendanceStatus.onTime
              ? PdfColors.green700
              : PdfColors.red700;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (ctx) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // En-tête
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('ISPM — PV de présence',
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    dateOnly.format(DateTime.now()),
                    style: const pw.TextStyle(
                        fontSize: 11, color: PdfColors.grey600),
                  ),
                ],
              ),
              pw.Divider(height: 24, color: PdfColors.grey300),

              // Infos cours
              pw.Text('Informations de la séance',
                  style: pw.TextStyle(
                      fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              _pdfRow('Cours', course.title),
              _pdfRow('Filière', course.fieldOfStudy),
              _pdfRow('Début', fmt.format(course.startTime)),
              _pdfRow('Fin', fmt.format(course.endTime)),
              pw.SizedBox(height: 20),

              // Présence
              pw.Text('Présence du professeur',
                  style: pw.TextStyle(
                      fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(statusLabel,
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: statusColor)),
                    pw.SizedBox(height: 6),
                    if (att?.scanTime != null)
                      _pdfRow('Heure de scan', fmt.format(att!.scanTime!)),
                    if (att?.invigilatorName != null)
                      _pdfRow('Validé par', att!.invigilatorName!),
                    if (att?.invigilatorEmail != null)
                      _pdfRow('Contact', att!.invigilatorEmail!),
                    if (att == null)
                      pw.Text('Aucun enregistrement de scan pour cette séance.',
                          style: const pw.TextStyle(
                              fontSize: 11, color: PdfColors.grey600)),
                  ],
                ),
              ),

              pw.Spacer(),
              pw.Divider(color: PdfColors.grey300),
              pw.Text(
                'Document généré automatiquement par l\'application ISPM Présence',
                style: const pw.TextStyle(
                    fontSize: 9, color: PdfColors.grey500),
              ),
            ],
          ),
        ),
      );

      // Sauvegarde et partage
      final dir = await getTemporaryDirectory();
      final safeName =
          course.title.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      final file =
          File('${dir.path}/PV_${safeName}_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'PV de présence — ${course.title}',
      );

      emit(current.copyWith(isExporting: false));
    } catch (e) {
      emit(current.copyWith(isExporting: false));
      emit(SessionDetailError('Erreur export PDF : $e'));
    }
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(label,
                style: const pw.TextStyle(
                    fontSize: 11, color: PdfColors.grey700)),
          ),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 11, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}
