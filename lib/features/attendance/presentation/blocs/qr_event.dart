part of 'qr_bloc.dart';

@freezed
abstract class QrEvent with _$QrEvent {
  const factory QrEvent.generate(String courseId) = _Generate;
}
