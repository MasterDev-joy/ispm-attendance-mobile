import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

// L'événement déclenché à l'ouverture de la page
class LoadScheduleEvent extends ScheduleEvent {}