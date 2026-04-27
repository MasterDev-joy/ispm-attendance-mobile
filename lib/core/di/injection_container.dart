import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/attendance/data/repositories/attendance_repository_impl.dart';
import '../../features/attendance/domain/repositories/attendance_repository.dart';
import '../../features/attendance/presentation/blocs/attendance_bloc.dart';
import '../../features/auth/data/daos/auth_local_dao.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

import '../../features/auth/presentation/blocs/auth_bloc.dart';
import '../../features/schedule/data/repositories/schedule_repository_impl.dart';
import '../../features/schedule/presentation/blocs/schedule_bloc.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // 1. Packages externes (Ceux qui font le travail technique)
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // 2. DAOs (Gestion des données locales)
  sl.registerLazySingleton(() => AuthLocalDao(storage: sl()));

  // 3. Repositories (La logique métier qui lie l'API et le DAO)
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(client: sl(), localDao: sl()));
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerLazySingleton(() => ScheduleRepositoryImpl(client: sl(), localDao: sl()));
  sl.registerFactory(() => ScheduleBloc(repository: sl()));

  // Attendance
  sl.registerLazySingleton<AttendanceRepository>(
        () => AttendanceRepositoryImpl(secureStorage: sl()),
  );
  // Attendance BLoC
  sl.registerFactory(() => AttendanceBloc(repository: sl()));
}