// lib/features/session_detail/presentation/blocs/session_detail_event.dart
import 'package:equatable/equatable.dart';
import 'package:ispm_attendance/features/schedule/domain/entities/course.dart';

abstract class SessionDetailEvent extends Equatable {
  const SessionDetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadSessionDetailEvent extends SessionDetailEvent {
  final Course course;
  const LoadSessionDetailEvent(this.course);
  @override
  List<Object?> get props => [course];
}

class ExportPdfEvent extends SessionDetailEvent {
  const ExportPdfEvent();
}
