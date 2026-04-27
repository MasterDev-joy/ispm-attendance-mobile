import 'package:equatable/equatable.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceValidationSuccess extends AttendanceState {
  final Map<String, dynamic> validationData; // Contient le nom du prof renvoyé par le backend

  const AttendanceValidationSuccess(this.validationData);

  @override
  List<Object?> get props => [validationData];
}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}