import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    super.isFirstLogin,
    super.hasBiometricsEnabled,
  });

  // Convertit le JSON du serveur Node.js en objet Dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      name: "${json['firstName']} ${json['lastName']}", // Concaténation du nom et prénom
      role: json['role'],
      isFirstLogin: json['isFirstLogin'] ?? false,
      hasBiometricsEnabled: false,
    );
  }
}