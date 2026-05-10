import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

// DTO : ne doit JAMAIS hériter de l'entity User
// Sa seule responsabilité : désérialiser le JSON et fournir toEntity()
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._(); // nécessaire pour définir des méthodes custom

  const factory UserModel({
    required String id,
    required String email,
    @JsonKey(name: 'firstName') required String firstName,
    @JsonKey(name: 'lastName') required String lastName,
    required String role,
    @Default(false) bool isFirstLogin,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Conversion DTO → Entity (la seule dépendance autorisée vers domain/)
  User toEntity() => User(
    id: id,
    email: email,
    name: '$firstName $lastName',
    role: role,
    isFirstLogin: isFirstLogin,
    hasBiometricsEnabled: false,
  );
}
