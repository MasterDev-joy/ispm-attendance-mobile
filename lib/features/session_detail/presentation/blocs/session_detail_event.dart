part of 'session_detail_bloc.dart';

@freezed
class SessionDetailEvent with _$SessionDetailEvent {
  // L'événement déclenché au chargement de la page
  const factory SessionDetailEvent.loadSessionDetail({
    required String sessionId,
    required String courseTitle, // ← passés depuis la page
    required String fieldOfStudy,
    required DateTime startTime,
    required DateTime endTime,
  }) = LoadSessionDetailEvent;

  // L'événement déclenché lors du clic sur le bouton PDF
  const factory SessionDetailEvent.exportPdf() = ExportPdfEvent;
}
