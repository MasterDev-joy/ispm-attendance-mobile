// lib/features/session_detail/presentation/blocs/session_detail_state.dart
import 'package:equatable/equatable.dart';
import 'package:ispm_attendance/features/schedule/domain/entities/course.dart';
import '../../domain/entities/session_attendance.dart';

abstract class SessionDetailState extends Equatable {
  const SessionDetailState();
  @override
  List<Object?> get props => [];
}

class SessionDetailInitial extends SessionDetailState {}

class SessionDetailLoading extends SessionDetailState {}

class SessionDetailLoaded extends SessionDetailState {
  final Course course;
  final SessionAttendance? attendance; // null = pas encore scanné
  final bool isExporting;

  const SessionDetailLoaded({
    required this.course,
    required this.attendance,
    this.isExporting = false,
  });

  SessionDetailLoaded copyWith({
    SessionAttendance? attendance,
    bool? isExporting,
  }) {
    return SessionDetailLoaded(
      course: course,
      attendance: attendance ?? this.attendance,
      isExporting: isExporting ?? this.isExporting,
    );
  }

  @override
  List<Object?> get props => [course, attendance, isExporting];
}

class SessionDetailError extends SessionDetailState {
  final String message;
  const SessionDetailError(this.message);
  @override
  List<Object?> get props => [message];
}

class SessionDetailPdfReady extends SessionDetailState {
  final String filePath;
  const SessionDetailPdfReady(this.filePath);
  @override
  List<Object?> get props => [filePath];
}
