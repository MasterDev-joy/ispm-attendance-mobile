// lib/features/admin/users/presentation/blocs/user_state.dart
//
// ✅ AVANT : enum UserStatus + copyWith + plusieurs champs optionnels
//    APRÈS : sealed class freezed — each state carries only what it needs
//
// Usage dans la page :
//   state.when(
//     initial: () => ...,
//     loading: () => ...,
//     saving: () => ...,
//     saveDone: () => ...,
//     loaded: (users, filtered, filter, query) => ...,
//     error: (message) => ...,
//   )
//
// Computed (professorCount / supervisorCount) :
//   state.whenOrNull(loaded: (users, ...) => users.where((u) => u.isProfessor).length)
// ─────────────────────────────────────────────────────────────────────────────
part of 'user_bloc.dart';

@freezed
abstract class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.saving() = _Saving;
  const factory UserState.saveDone() = _SaveDone;
  const factory UserState.loaded({
    required List<AdminUser> users,
    required List<AdminUser> filtered,
    required String filter,
    required String query,
  }) = _Loaded;
  const factory UserState.error(String message) = _Error;
}
