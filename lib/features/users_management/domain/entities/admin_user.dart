// lib/features/users_management/domain/entities/admin_user.dart
//
// ✅ AVANT : importait Flutter (Color) et ISPMColors
//    APRÈS : entité pure — roleColor déplacé dans _UserCard (présentation)
// ─────────────────────────────────────────────────────────────────────────────
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_user.freezed.dart';

@freezed
abstract class AdminUser with _$AdminUser {
  const AdminUser._();

  const factory AdminUser({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String role,
    required bool isActive,
  }) = _AdminUser;

  // ── Computed — logique métier pure, sans UI ───────────────────────────────
  String get fullName => '$firstName $lastName';
  String get initial => firstName.isNotEmpty ? firstName[0].toUpperCase() : '?';
  bool get isProfessor => role.toLowerCase() == 'professor';
  bool get isSupervisor =>
      role.toLowerCase() == 'supervisor' || role.toLowerCase() == 'superviseur';
  String get roleLabel => isProfessor ? 'Professeur' : 'Superviseur';
}
