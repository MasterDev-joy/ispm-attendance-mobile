// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/attendance/data/repositories/attendance_repository_impl.dart';
import '../../features/attendance/data/repositories/qr_repository_impl.dart';
import '../../features/attendance/domain/repositories/attendance_repository.dart';
import '../../features/attendance/domain/repositories/qr_repository.dart';
import '../../features/attendance/presentation/blocs/attendance_bloc.dart';

import '../../features/auth/data/daos/auth_local_dao.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/blocs/auth_bloc.dart';

import '../../features/notifications/presentation/blocs/notification_bloc.dart';

import '../../features/schedule/data/repositories/schedule_repository_impl.dart';
import '../../features/schedule/presentation/blocs/schedule_bloc.dart';

import '../../features/stats/presentation/blocs/stats_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── 1. Packages externes ──────────────────────────────────────────────────
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // ── 2. DAOs ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => AuthLocalDao(storage: sl()));

  // ── 3. Repositories ───────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(client: sl(), localDao: sl()),
  );
  sl.registerLazySingleton(
        () => ScheduleRepositoryImpl(client: sl(), localDao: sl()),
  );
  sl.registerLazySingleton<AttendanceRepository>(
        () => AttendanceRepositoryImpl(secureStorage: sl()),
  );
  sl.registerLazySingleton<QrRepository>(
        () => QrRepositoryImpl(secureStorage: sl()),
  );

  // ── 4. BLoCs — registerFactory → nouvelle instance à chaque push ─────────
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => ScheduleBloc(repository: sl()));
  sl.registerFactory(() => AttendanceBloc(repository: sl()));

  // NotificationBloc — pas de dépendance repo pour l'instant (mock interne)
  sl.registerFactory(() => NotificationBloc());

  // StatsBloc — pas de dépendance repo pour l'instant (mock interne)
  sl.registerFactory(() => StatsBloc());
}