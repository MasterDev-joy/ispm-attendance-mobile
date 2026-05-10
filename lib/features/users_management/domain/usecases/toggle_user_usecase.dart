// lib/features/users_management/domain/usecases/toggle_user_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../entities/admin_user.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class ToggleUser {
  final UserRepository _r;
  const ToggleUser(this._r);
  Future<Either<Failure, void>> call(String id) => _r.toggleUser(id);
}
