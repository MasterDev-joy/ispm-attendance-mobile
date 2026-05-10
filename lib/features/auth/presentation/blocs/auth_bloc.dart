import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../../../core/error/failures.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _login;
  final CheckAuthStatusUseCase _checkAuthStatus;
  final ChangePasswordUseCase _changePassword;
  final LogoutUseCase _logout;

  AuthBloc(
    this._login,
    this._checkAuthStatus,
    this._changePassword,
    this._logout,
  ) : super(const AuthState.initial()) {
    on<_CheckAuthStatus>(_onCheckAuthStatus);
    on<_LoginRequested>(_onLoginRequested);
    on<_ChangePasswordRequested>(_onChangePasswordRequested);
    on<_LogoutRequested>(_onLogoutRequested);
  }

  // ─── Check Auth Status ────────────────────────────────────────────────────

  Future<void> _onCheckAuthStatus(
    _CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _checkAuthStatus();
    result.fold((failure) => emit(const AuthState.unauthenticated()), (user) {
      if (user == null) return emit(const AuthState.unauthenticated());
      if (user.isFirstLogin)
        return emit(AuthState.requiresPasswordChange(user));
      emit(AuthState.authenticated(user));
    });
  }

  // ─── Login ────────────────────────────────────────────────────────────────

  Future<void> _onLoginRequested(
    _LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _login(event.email, event.password);
    result.fold(
      (failure) => failure.when(
        server: (msg) => emit(AuthState.error(msg)),
        network: () => emit(const AuthState.error('Pas de connexion réseau')),
        unauthorized: () =>
            emit(const AuthState.error('Email ou mot de passe incorrect')),
        forbidden: () => emit(const AuthState.error('Accès refusé')),
        cache: (msg) => emit(AuthState.error(msg)),
        unknown: (msg) => emit(AuthState.error(msg)),
      ),
      (user) {
        if (user.isFirstLogin)
          return emit(AuthState.requiresPasswordChange(user));
        emit(AuthState.authenticated(user));
      },
    );
  }

  // ─── Change Password ──────────────────────────────────────────────────────

  Future<void> _onChangePasswordRequested(
    _ChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    // On récupère l'user depuis l'état courant pour le réemettre après
    final currentUser = state.whenOrNull(
      requiresPasswordChange: (user) => user,
    );
    if (currentUser == null) return;

    emit(const AuthState.loading());
    final result = await _changePassword(event.userId, event.newPassword);
    result.fold(
      (failure) => failure.when(
        server: (msg) => emit(AuthState.error(msg)),
        network: () => emit(const AuthState.error('Pas de connexion réseau')),
        unauthorized: () => emit(const AuthState.error('Session expirée')),
        forbidden: () => emit(const AuthState.error('Accès refusé')),
        cache: (msg) => emit(AuthState.error(msg)),
        unknown: (msg) => emit(AuthState.error(msg)),
      ),
      (_) => emit(
        AuthState.authenticated(currentUser.copyWith(isFirstLogin: false)),
      ),
    );
  }

  // ─── Logout ───────────────────────────────────────────────────────────────

  Future<void> _onLogoutRequested(
    _LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    await _logout();
    emit(const AuthState.unauthenticated());
  }
}
