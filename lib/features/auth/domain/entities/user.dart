import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String role;
  final bool isFirstLogin;
  final bool hasBiometricsEnabled;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.isFirstLogin = false,
    this.hasBiometricsEnabled = false,
  });

  @override
  List<Object?> get props => [id, email, name, role, isFirstLogin, hasBiometricsEnabled];
}