part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.checkAuthStatus() = _CheckAuthStatus;
  const factory AuthEvent.loginRequested(String email, String password) =
      _LoginRequested;
  const factory AuthEvent.changePasswordRequested({
    required String userId,
    required String newPassword,
  }) = _ChangePasswordRequested;
  const factory AuthEvent.logoutRequested() = _LogoutRequested;
}
