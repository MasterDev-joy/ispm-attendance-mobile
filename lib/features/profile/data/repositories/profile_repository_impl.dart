// lib/features/profile/data/repositories/profile_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/dio_failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      final userModel = await _remoteDataSource.getProfile();
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e, stacktrace) {
      // 👇 AJOUTEZ CES DEUX LIGNES POUR DÉBOGUER 👇
      print("🚨 ERREUR RÉELLE PROFIL : $e");
      print("📍 STACKTRACE : $stacktrace");
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    try {
      final userModel = await _remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
      );
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(mapDioFailure(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
