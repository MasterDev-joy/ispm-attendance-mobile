// lib/features/auth/domain/entities/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

enum UserRole { admin, professor, supervisor, unknown }

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required UserRole role,
    @Default(false) bool isFirstLogin,
  }) = _User;

  const User._();
  String get fullName => '$firstName $lastName';
}
