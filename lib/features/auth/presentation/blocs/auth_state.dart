import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

// Pendant que l'application vérifie le mot de passe (pour afficher un loader)
class AuthLoading extends AuthState {}

// Si la connexion réussit
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

// Si la connexion échoue (mauvais mot de passe, etc.)
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

// Si la connexion réussit MAIS que c'est le premier login
class AuthRequiresPasswordChange extends AuthState {
  final User user;

  const AuthRequiresPasswordChange(this.user);

  @override
  List<Object> get props => [user];
}

// Si l'utilisateur n'est pas connecté
class AuthUnauthenticated extends AuthState {}