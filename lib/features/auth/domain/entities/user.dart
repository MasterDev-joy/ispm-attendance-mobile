// lib/features/auth/domain/entities/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    required String role,
    @Default(false) bool isFirstLogin,
    @Default(false) bool hasBiometricsEnabled,
  }) = _User;
}
