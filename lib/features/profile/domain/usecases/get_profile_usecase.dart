// lib/features/profile/domain/usecases/get_profile_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class GetProfileUseCase {
  final ProfileRepository _repository;
  GetProfileUseCase(this._repository);

  Future<Either<Failure, User>> call() => _repository.getProfile();
}
