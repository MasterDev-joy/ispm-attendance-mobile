import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {

    // Enregistrement des gestionnaires d'événements
    on<LoginRequestedEvent>(_onLoginRequested);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LogoutRequestedEvent>(_onLogoutRequested);
    on<ChangePasswordRequestedEvent>(_onChangePasswordRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequestedEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(event.email, event.password);

      // 🚀 NOUVEAU : On vérifie si c'est la première connexion
      if (user.isFirstLogin) {
        emit(AuthRequiresPasswordChange(user));
      } else {
        emit(AuthAuthenticated(user));
      }

    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.getCurrentUser();
      if (user == null) {
        emit(AuthUnauthenticated());
      } else if (user.isFirstLogin) {
        emit(AuthRequiresPasswordChange(user));
      } else {
        emit(AuthAuthenticated(user));
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onChangePasswordRequested(
      ChangePasswordRequestedEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      // On appelle l'API Node.js pour mettre à jour le mot de passe
      await _authRepository.updatePassword(event.user.id, event.newPassword);

      // Si ça réussit, le professeur est officiellement authentifié et prêt
      emit(AuthAuthenticated(event.user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequestedEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }
}