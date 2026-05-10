// lib/features/admin/users/presentation/blocs/user_event.dart
part of 'user_bloc.dart';

@freezed
abstract class UserEvent with _$UserEvent {
  const factory UserEvent.load() = _Load;
  const factory UserEvent.toggle(String userId) = _Toggle;
  const factory UserEvent.save({
    String? id,
    required String firstName,
    required String lastName,
    required String email,
    required String role,
  }) = _Save;
  const factory UserEvent.filterChanged({
    required String filter,
    required String query,
  }) = _FilterChanged;
}
