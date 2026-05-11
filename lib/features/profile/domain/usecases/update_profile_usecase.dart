// lib/features/profile/domain/usecases/update_profile_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<Either<Failure, User>> call({
    required String firstName,
    required String lastName,
  }) {
    return _repository.updateProfile(firstName: firstName, lastName: lastName);
  }
}
