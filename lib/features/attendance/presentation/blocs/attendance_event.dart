import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class ValidateQrEvent extends AttendanceEvent {
  final String token;
  final String professorId;
  final String courseId;

  const ValidateQrEvent({
    required this.token,
    required this.professorId,
    required this.courseId,
  });

  @override
  List<Object?> get props => [token, professorId, courseId];
}