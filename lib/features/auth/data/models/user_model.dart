import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

class RoleConverter implements JsonConverter<UserRole, String> {
  const RoleConverter();

  @override
  UserRole fromJson(String json) {
    switch (json.toUpperCase()) {
      case 'ADMIN':
        return UserRole.admin;
      case 'PROFESSOR':
        return UserRole.professor;
      case 'SUPERVISOR':
        return UserRole.supervisor;
      default:
        return UserRole.unknown;
    }
  }

  @override
  String toJson(UserRole object) {
    // Si un jour vous devez envoyer le rôle à l'API (ex: updateProfile)
    return object.name.toUpperCase();
  }
}

// DTO : ne doit JAMAIS hériter de l'entity User
// Sa seule responsabilité : désérialiser le JSON et fournir toEntity()
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._(); // nécessaire pour définir des méthodes custom

  const factory UserModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    @RoleConverter() required UserRole role,
    @Default(false) bool isFirstLogin,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Conversion DTO → Entity (la seule dépendance autorisée vers domain/)
  User toEntity() => User(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    role: role,
    isFirstLogin: isFirstLogin,
  );
}
