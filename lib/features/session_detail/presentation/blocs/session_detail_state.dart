part of 'session_detail_bloc.dart';

@freezed
abstract class SessionDetailState with _$SessionDetailState {
  const factory SessionDetailState.initial() = _Initial;
  const factory SessionDetailState.loading() = _Loading;
  const factory SessionDetailState.loaded({
    required String courseTitle,
    required String fieldOfStudy,
    required DateTime startTime,
    required DateTime endTime,
    required SessionAttendance attendance,
    @Default(false) bool isExporting,
  }) = _Loaded;
  const factory SessionDetailState.error(String message) = _Error;
}
