import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/check_server_health.dart';
import '../../domain/usecases/reset_attendance.dart';
import 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final CheckServerHealth _checkServerHealth;
  final ResetAttendance _resetAttendance;

  SettingsCubit(this._checkServerHealth, this._resetAttendance)
    : super(const SettingsState()) {
    checkServer();
  }

  Future<void> checkServer() async {
    emit(state.copyWith(isCheckingServer: true, errorMessage: null));
    final result = await _checkServerHealth();
    result.fold(
      (f) => emit(
        state.copyWith(isCheckingServer: false, errorMessage: f.toString()),
      ),
      (s) => emit(state.copyWith(isCheckingServer: false, serverStatus: s)),
    );
  }

  Future<void> resetAttendance() async {
    emit(state.copyWith(isResetting: true));
    final result = await _resetAttendance();
    result.fold(
      (f) =>
          emit(state.copyWith(isResetting: false, errorMessage: f.toString())),
      (_) => emit(state.copyWith(isResetting: false)),
    );
  }

  void toggleQrRotation(bool value) =>
      emit(state.copyWith(qrRotationEnabled: value));

  void setQrDuration(int seconds) =>
      emit(state.copyWith(qrDurationSec: seconds));

  void toggleBiometrics(bool value) =>
      emit(state.copyWith(requireBiometrics: value));

  void toggleMaintenance(bool value) =>
      emit(state.copyWith(maintenanceMode: value));
}
