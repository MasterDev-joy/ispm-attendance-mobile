// lib/features/profile/presentation/blocs/profile_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../auth/domain/entities/user.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart'; // Pour GetProfile (ou un usecase dédié)

// Inclusion des fichiers "parts"
part 'profile_event.dart';
part 'profile_state.dart';

// Génération Freezed unique
part 'profile_bloc.freezed.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;

  ProfileBloc(this._getProfile, this._updateProfile)
    : super(const ProfileState.initial()) {
    on<GetProfileRequested>(_onGetProfile);
    on<UpdateProfileRequested>(_onUpdateProfile);
  }

  Future<void> _onGetProfile(
    GetProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.loading());

    final result = await _getProfile();

    result.fold(
      (failure) => emit(ProfileState.error(failure.toString())),
      (user) => emit(ProfileState.loaded(user: user)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    // Affiche un état de chargement spécifique pour la mise à jour (ex: loader sur le bouton)
    emit(currentState.copyWith(isUpdating: true));

    final result = await _updateProfile(
      firstName: event.firstName,
      lastName: event.lastName,
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isUpdating: false));
        // Optionnel : émettre une erreur temporaire ou un message via un listener
      },
      (updatedUser) =>
          emit(ProfileState.loaded(user: updatedUser, isUpdating: false)),
    );
  }
}
