part of 'qr_bloc.dart';

@freezed
class QrState with _$QrState {
  const factory QrState.initial() = _Initial;
  const factory QrState.loading() = _Loading;
  const factory QrState.success(String payload) = _Success;
  const factory QrState.error(String message) = _Error;
}
