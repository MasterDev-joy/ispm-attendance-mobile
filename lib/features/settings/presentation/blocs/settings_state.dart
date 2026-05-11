import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/server_status.dart';
part 'settings_state.freezed.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool isCheckingServer,
    @Default(false) bool isResetting,
    ServerStatus? serverStatus,
    @Default(true) bool qrRotationEnabled,
    @Default(14) int qrDurationSec,
    @Default(false) bool requireBiometrics,
    @Default(false) bool maintenanceMode,
    String? errorMessage,
  }) = _SettingsState;
}
