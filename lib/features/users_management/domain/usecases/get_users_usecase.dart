// lib/features/users_management/domain/usecases/get_users_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../entities/admin_user.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetUsers {
  final UserRepository _r;
  const GetUsers(this._r);
  Future<Either<Failure, List<AdminUser>>> call() => _r.getUsers();
}
