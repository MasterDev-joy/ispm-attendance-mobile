//  lib/features/profile/presentation/blocs/profile_state.dart
part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;

  /// État quand le profil est chargé avec succès
  const factory ProfileState.loaded({
    required User user,
    @Default(false) bool isUpdating,
  }) = ProfileLoaded;

  const factory ProfileState.error(String message) = _Error;
}
