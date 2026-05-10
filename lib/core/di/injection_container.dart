// lib/core/di/injection_container.dart
//
// Changements vs version originale :
//   - http.Client supprimé → DioClient centralisé
//   - AuthLocalDao supprimé (auth non modifiée dans cette passe)
//   - Tous les BLoCs reçoivent leurs UseCases (plus de repository direct)
//   - ScheduleBloc reçoit GetMyCourses au lieu de ScheduleRepositoryImpl
//   - AttendanceBloc reçoit AttendanceRepository (via DI)
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

// ── Core ──────────────────────────────────────────────────────────────────────
import '../network/dio_client.dart';

// ── Auth (inchangée — sera refactorisée séparément) ──────────────────────────
import 'package:http/http.dart' as http;
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/blocs/auth_bloc.dart';

// ── Attendance ────────────────────────────────────────────────────────────────
import '../../features/attendance/data/datasources/attendance_remote_datasource.dart';
import '../../features/attendance/data/repositories/attendance_repository_impl.dart';
import '../../features/attendance/domain/repositories/repositories.dart';
import '../../features/attendance/presentation/blocs/attendance_bloc.dart';

// ── Schedule ──────────────────────────────────────────────────────────────────
import '../../features/schedule/data/datasources/schedule_remote_datasource.dart';
import '../../features/schedule/data/repositories/schedule_repository_impl.dart';
import '../../features/schedule/domain/repositories/schedule_repository.dart';
import '../../features/schedule/domain/usecases/get_my_courses.dart';
import '../../features/schedule/presentation/blocs/schedule_bloc.dart';

// ── Notifications (inchangées) ────────────────────────────────────────────────
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/presentation/blocs/notification_bloc.dart';

// ── Stats ─────────────────────────────────────────────────────────────────────
import '../../features/stats/data/datasources/stats_remote_datasource.dart';
import '../../features/stats/data/repositories/stats_repository_impl.dart';
import '../../features/stats/domain/repositories/stats_repository.dart';
import '../../features/stats/domain/usecases/get_stats.dart';
import '../../features/stats/presentation/blocs/stats_bloc.dart';

// ── Admin / Reports ───────────────────────────────────────────────────────────
import '../../features/reports/data/datasources/report_remote_datasource.dart';
import '../../features/reports/data/repositories/report_repositories_impl.dart';
import '../../features/reports/domain/repositories/report_repository.dart';
import '../../features/reports/domain/usecases//report_usecases.dart';
import '../../features/reports/presentation/blocs/report_bloc.dart';

// ── Admin / Users ─────────────────────────────────────────────────────────────
import '../../features/users_management/domain/repositories/user_repository.dart';
import '../../features/users_management/domain/usecases/user_usecases.dart';
import '../../features/users_management/presentation/blocs/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── 1. Packages externes ────────────────────────────────────────────────────
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // ── 2. Core réseau ──────────────────────────────────────────────────────────
  //    DioClient remplace tous les http.Client dispersés dans les datasources
  sl.registerLazySingleton(() => DioClient(sl()));

  // ── 3. Auth — conservée telle quelle (refacto séparée) ─────────────────────
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => AuthLocalDao(storage: sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(client: sl(), localDao: sl()),
  );

  // ── 4. Datasources ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<StatsRemoteDataSource>(
    () => StatsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AdminUserRemoteDataSource>(
    () => AdminUserRemoteDataSourceImpl(sl()),
  );

  // ── 5. Repositories ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<QrRepository>(() => QrRepositoryImpl(sl()));
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<StatsRepository>(() => StatsRepositoryImpl(sl()));
  sl.registerLazySingleton<ReportRepository>(() => ReportRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(storage: sl()),
  );

  // ── 6. UseCases ─────────────────────────────────────────────────────────────
  // Schedule
  sl.registerLazySingleton(() => GetMyCourses(sl()));
  // Stats
  sl.registerLazySingleton(() => GetStats(sl()));
  // Reports
  sl.registerLazySingleton(() => GetReports(sl()));
  sl.registerLazySingleton(() => ExportCsv(sl()));
  sl.registerLazySingleton(() => ExportPdf(sl()));
  // Users
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => ToggleUser(sl()));
  sl.registerLazySingleton(() => SaveUser(sl()));

  // ── 7. BLoCs — registerFactory → nouvelle instance à chaque push ────────────
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => ScheduleBloc(sl())); // reçoit GetMyCourses
  sl.registerFactory(() => AttendanceBloc(sl())); // reçoit AttendanceRepository
  sl.registerFactory(() => NotificationBloc(repository: sl()));
  sl.registerFactory(() => StatsBloc(sl())); // reçoit GetStats
  sl.registerFactory(
    () => ReportBloc(sl(), sl(), sl()), // GetReports, ExportCsv, ExportPdf
  );
  sl.registerFactory(
    () => UserBloc(sl(), sl(), sl()), // GetUsers, ToggleUser, SaveUser
  );
}
