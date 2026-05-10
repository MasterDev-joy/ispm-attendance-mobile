// lib/features/admin/users/data/repositories/user_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/dio_failure_mapper.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remote;
  UserRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<AdminUser>>> getUsers() async {
    try {
      final models = await _remote.fetchUsers();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleUser(String id) async {
    try {
      await _remote.toggleUser(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveUser({
    String? id,
    required String firstName,
    required String lastName,
    required String email,
    required String role,
  }) async {
    try {
      await _remote.saveUser(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        role: role,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
