import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Quand l'application s'ouvre, on vérifie s'il y a déjà une session
class CheckAuthStatusEvent extends AuthEvent {}

// Quand l'utilisateur clique sur le bouton "Se connecter"
class LoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginRequestedEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

// Quand l'utilisateur soumet son nouveau mot de passe
class ChangePasswordRequestedEvent extends AuthEvent {
  final String newPassword;
  final User user; // On garde l'utilisateur sous la main

  const ChangePasswordRequestedEvent({required this.newPassword, required this.user});

  @override
  List<Object> get props => [newPassword, user];
}

// Quand l'utilisateur clique sur "Déconnexion"
class LogoutRequestedEvent extends AuthEvent {}