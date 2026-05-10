// lib/features/admin/users/data/models/admin_user_model.dart
//
// ✅ AVANT : classe simple avec factory fromJson + toEntity()
//    APRÈS : @freezed abstract class + @JsonSerializable + toEntity()
// ─────────────────────────────────────────────────────────────────────────────
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/admin_user.dart';

part 'admin_user_model.freezed.dart';
part 'admin_user_model.g.dart';

@freezed
abstract class AdminUserModel with _$AdminUserModel {
  const AdminUserModel._();

  const factory AdminUserModel({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String role,
    @Default(true) bool isActive,
  }) = _AdminUserModel;

  factory AdminUserModel.fromJson(Map<String, dynamic> json) =>
      _$AdminUserModelFromJson(json);

  Map<String, dynamic> toCreateJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'role': role,
  };

  AdminUser toEntity() => AdminUser(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    role: role,
    isActive: isActive,
  );
}
