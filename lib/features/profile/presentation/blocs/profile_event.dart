// lib/features/profile/presentation/blocs/profile_event.dart
part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  /// Charger les informations du profil
  const factory ProfileEvent.getProfileRequested() = GetProfileRequested;

  /// Mettre à jour les informations du profil
  const factory ProfileEvent.updateProfileRequested({
    required String firstName,
    required String lastName,
  }) = UpdateProfileRequested;
}
