// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/attendance/data/datasources/attendance_remote_datasource.dart'
    as _i425;
import '../../features/attendance/data/repositories/attendance_repository_impl.dart'
    as _i719;
import '../../features/attendance/domain/repositories/attendance_repository.dart'
    as _i477;
import '../../features/attendance/domain/usecases/get_qr_payload.dart' as _i461;
import '../../features/attendance/presentation/blocs/attendance_bloc.dart'
    as _i367;
import '../../features/attendance/presentation/blocs/qr_bloc.dart' as _i726;
import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/change_password_usecase.dart'
    as _i788;
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart'
    as _i52;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/presentation/blocs/auth_bloc.dart' as _i85;
import '../../features/courses_management/data/datasources/course_remote_datasource.dart'
    as _i275;
import '../../features/courses_management/data/repositories/course_repository_impl.dart'
    as _i133;
import '../../features/courses_management/domain/repositories/course_repository.dart'
    as _i1065;
import '../../features/courses_management/domain/usecases/delete_course_usecase.dart'
    as _i4;
import '../../features/courses_management/domain/usecases/get_courses_usecase.dart'
    as _i640;
import '../../features/courses_management/domain/usecases/save_course_usecase.dart'
    as _i868;
import '../../features/courses_management/presentation/blocs/course_bloc.dart'
    as _i597;
import '../../features/notifications/data/datasources/notification_remote_datasource.dart'
    as _i923;
import '../../features/notifications/data/repositories/notification_repository_impl.dart'
    as _i361;
import '../../features/notifications/domain/repositories/notification_repository.dart'
    as _i367;
import '../../features/notifications/domain/usecases/delete_notification.dart'
    as _i826;
import '../../features/notifications/domain/usecases/get_notifications.dart'
    as _i163;
import '../../features/notifications/domain/usecases/mark_all_notifications_read.dart'
    as _i852;
import '../../features/notifications/domain/usecases/mark_notification_as_read.dart'
    as _i713;
import '../../features/notifications/presentation/blocs/notification_bloc.dart'
    as _i159;
import '../../features/profile/data/datasources/profile_remote_datasource.dart'
    as _i327;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/usecases/get_profile_usecase.dart'
    as _i965;
import '../../features/profile/domain/usecases/update_profile_usecase.dart'
    as _i478;
import '../../features/profile/presentation/blocs/profile_bloc.dart' as _i133;
import '../../features/reports/data/datasources/report_remote_datasource.dart'
    as _i995;
import '../../features/reports/data/repositories/report_repository_impl.dart'
    as _i246;
import '../../features/reports/domain/repositories/report_repository.dart'
    as _i939;
import '../../features/reports/domain/usecases/export_csv.dart' as _i859;
import '../../features/reports/domain/usecases/export_pdf.dart' as _i400;
import '../../features/reports/domain/usecases/get_reports_usecase.dart'
    as _i369;
import '../../features/reports/presentation/blocs/report_bloc.dart' as _i826;
import '../../features/schedule/data/datasources/schedule_remote_datasource.dart'
    as _i115;
import '../../features/schedule/data/repositories/schedule_repository_impl.dart'
    as _i688;
import '../../features/schedule/domain/repositories/schedule_repository.dart'
    as _i736;
import '../../features/schedule/domain/usecases/get_my_courses.dart' as _i375;
import '../../features/schedule/presentation/blocs/schedule_bloc.dart' as _i112;
import '../../features/session_detail/data/datasources/session_detail_remote_datasource.dart'
    as _i1069;
import '../../features/session_detail/data/repositories/session_detail_repository_impl.dart'
    as _i924;
import '../../features/session_detail/data/repositories/session_pdf_service_impl.dart'
    as _i124;
import '../../features/session_detail/domain/repositories/session_detail_repository.dart'
    as _i94;
import '../../features/session_detail/domain/repositories/session_pdf_service.dart'
    as _i262;
import '../../features/session_detail/domain/usecases/export_session_pdf_usecase.dart'
    as _i788;
import '../../features/session_detail/domain/usecases/get_session_details_usecase.dart'
    as _i370;
import '../../features/session_detail/presentation/blocs/session_detail_bloc.dart'
    as _i33;
import '../../features/settings/data/datasources/settings_remote_datasource.dart'
    as _i140;
import '../../features/settings/data/repositories/settings_repository_impl.dart'
    as _i955;
import '../../features/settings/domain/repositories/settings_repository.dart'
    as _i674;
import '../../features/settings/domain/usecases/check_server_health.dart'
    as _i819;
import '../../features/settings/domain/usecases/reset_attendance.dart' as _i342;
import '../../features/settings/presentation/blocs/settings_cubit.dart'
    as _i573;
import '../../features/stats/data/datasources/stats_remote_datasource.dart'
    as _i720;
import '../../features/stats/data/repositories/stats_repository_impl.dart'
    as _i845;
import '../../features/stats/domain/repositories/stats_repository.dart'
    as _i804;
import '../../features/stats/domain/usecases/get_stats.dart' as _i356;
import '../../features/stats/presentation/blocs/stats_bloc.dart' as _i981;
import '../../features/users_management/data/datasources/user_remote_datasource.dart'
    as _i898;
import '../../features/users_management/data/repositories/user_repository_impl.dart'
    as _i747;
import '../../features/users_management/domain/repositories/user_repository.dart'
    as _i32;
import '../../features/users_management/domain/usecases/get_users_usecase.dart'
    as _i712;
import '../../features/users_management/domain/usecases/save_user_usecase.dart'
    as _i733;
import '../../features/users_management/domain/usecases/toggle_user_usecase.dart'
    as _i524;
import '../../features/users_management/presentation/blocs/user_bloc.dart'
    as _i347;
import '../network/dio_client.dart' as _i667;
import '../router/app_router.dart' as _i81;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i262.SessionPdfService>(
      () => _i124.SessionPdfServiceImpl(),
    );
    gh.lazySingleton<_i667.DioClient>(
      () => _i667.DioClient(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i425.AttendanceRemoteDataSource>(
      () => _i425.AttendanceRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i995.ReportRemoteDataSource>(
      () => _i995.ReportRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i477.QrRepository>(
      () => _i719.QrRepositoryImpl(gh<_i425.AttendanceRemoteDataSource>()),
    );
    gh.lazySingleton<_i992.AuthLocalDataSource>(
      () => _i992.AuthLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i720.StatsRemoteDataSource>(
      () => _i720.StatsRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i477.AttendanceRepository>(
      () => _i719.AttendanceRepositoryImpl(
        gh<_i425.AttendanceRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i898.UserRemoteDataSource>(
      () => _i898.UserRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i275.CourseRemoteDataSource>(
      () => _i275.CourseRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i923.NotificationRemoteDataSource>(
      () => _i923.NotificationRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i1065.CourseRepository>(
      () => _i133.CourseRepositoryImpl(gh<_i275.CourseRemoteDataSource>()),
    );
    gh.lazySingleton<_i788.ExportSessionPdfUsecase>(
      () => _i788.ExportSessionPdfUsecase(gh<_i262.SessionPdfService>()),
    );
    gh.lazySingleton<_i804.StatsRepository>(
      () => _i845.StatsRepositoryImpl(gh<_i720.StatsRemoteDataSource>()),
    );
    gh.lazySingleton<_i367.NotificationRepository>(
      () => _i361.NotificationRepositoryImpl(
        gh<_i923.NotificationRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1069.SessionDetailRemoteDataSource>(
      () => _i1069.SessionDetailRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i327.ProfileRemoteDataSource>(
      () => _i327.ProfileRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i140.SettingsRemoteDataSource>(
      () => _i140.SettingsRemoteDataSourceImpl(
        gh<_i667.DioClient>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i356.GetStats>(
      () => _i356.GetStats(gh<_i804.StatsRepository>()),
    );
    gh.lazySingleton<_i94.SessionDetailRepository>(
      () => _i924.SessionDetailRepositoryImpl(
        gh<_i1069.SessionDetailRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i4.DeleteCourse>(
      () => _i4.DeleteCourse(gh<_i1065.CourseRepository>()),
    );
    gh.lazySingleton<_i640.GetCourses>(
      () => _i640.GetCourses(gh<_i1065.CourseRepository>()),
    );
    gh.lazySingleton<_i868.SaveCourse>(
      () => _i868.SaveCourse(gh<_i1065.CourseRepository>()),
    );
    gh.factory<_i367.AttendanceBloc>(
      () => _i367.AttendanceBloc(gh<_i477.AttendanceRepository>()),
    );
    gh.lazySingleton<_i32.UserRepository>(
      () => _i747.UserRepositoryImpl(gh<_i898.UserRemoteDataSource>()),
    );
    gh.factory<_i981.StatsBloc>(() => _i981.StatsBloc(gh<_i356.GetStats>()));
    gh.factory<_i461.GetQrPayload>(
      () => _i461.GetQrPayload(gh<_i477.QrRepository>()),
    );
    gh.lazySingleton<_i115.ScheduleRemoteDataSource>(
      () => _i115.ScheduleRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i939.ReportRepository>(
      () => _i246.ReportRepositoryImpl(gh<_i995.ReportRemoteDataSource>()),
    );
    gh.lazySingleton<_i894.ProfileRepository>(
      () => _i334.ProfileRepositoryImpl(gh<_i327.ProfileRemoteDataSource>()),
    );
    gh.lazySingleton<_i965.GetProfileUseCase>(
      () => _i965.GetProfileUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.lazySingleton<_i478.UpdateProfileUseCase>(
      () => _i478.UpdateProfileUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.lazySingleton<_i370.GetSessionDetailsUseCase>(
      () => _i370.GetSessionDetailsUseCase(gh<_i94.SessionDetailRepository>()),
    );
    gh.factory<_i33.SessionDetailBloc>(
      () => _i33.SessionDetailBloc(
        gh<_i370.GetSessionDetailsUseCase>(),
        gh<_i788.ExportSessionPdfUsecase>(),
      ),
    );
    gh.factory<_i726.QrBloc>(() => _i726.QrBloc(gh<_i461.GetQrPayload>()));
    gh.factory<_i597.CourseBloc>(
      () => _i597.CourseBloc(
        gh<_i640.GetCourses>(),
        gh<_i868.SaveCourse>(),
        gh<_i4.DeleteCourse>(),
      ),
    );
    gh.lazySingleton<_i736.ScheduleRepository>(
      () => _i688.ScheduleRepositoryImpl(gh<_i115.ScheduleRemoteDataSource>()),
    );
    gh.lazySingleton<_i859.ExportCsv>(
      () => _i859.ExportCsv(gh<_i939.ReportRepository>()),
    );
    gh.lazySingleton<_i400.ExportPdf>(
      () => _i400.ExportPdf(gh<_i939.ReportRepository>()),
    );
    gh.lazySingleton<_i369.GetReports>(
      () => _i369.GetReports(gh<_i939.ReportRepository>()),
    );
    gh.lazySingleton<_i826.DeleteNotification>(
      () => _i826.DeleteNotification(gh<_i367.NotificationRepository>()),
    );
    gh.lazySingleton<_i163.GetNotifications>(
      () => _i163.GetNotifications(gh<_i367.NotificationRepository>()),
    );
    gh.lazySingleton<_i852.MarkAllNotificationsRead>(
      () => _i852.MarkAllNotificationsRead(gh<_i367.NotificationRepository>()),
    );
    gh.lazySingleton<_i713.MarkNotificationAsRead>(
      () => _i713.MarkNotificationAsRead(gh<_i367.NotificationRepository>()),
    );
    gh.factory<_i133.ProfileBloc>(
      () => _i133.ProfileBloc(
        gh<_i965.GetProfileUseCase>(),
        gh<_i478.UpdateProfileUseCase>(),
      ),
    );
    gh.lazySingleton<_i712.GetUsers>(
      () => _i712.GetUsers(gh<_i32.UserRepository>()),
    );
    gh.lazySingleton<_i733.SaveUser>(
      () => _i733.SaveUser(gh<_i32.UserRepository>()),
    );
    gh.lazySingleton<_i524.ToggleUser>(
      () => _i524.ToggleUser(gh<_i32.UserRepository>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i161.AuthRemoteDataSource>(),
        gh<_i992.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i674.SettingsRepository>(
      () => _i955.SettingsRepositoryImpl(gh<_i140.SettingsRemoteDataSource>()),
    );
    gh.factory<_i826.ReportBloc>(
      () => _i826.ReportBloc(
        gh<_i369.GetReports>(),
        gh<_i859.ExportCsv>(),
        gh<_i400.ExportPdf>(),
      ),
    );
    gh.factory<_i347.UserBloc>(
      () => _i347.UserBloc(
        gh<_i712.GetUsers>(),
        gh<_i524.ToggleUser>(),
        gh<_i733.SaveUser>(),
      ),
    );
    gh.factory<_i159.NotificationBloc>(
      () => _i159.NotificationBloc(
        gh<_i163.GetNotifications>(),
        gh<_i713.MarkNotificationAsRead>(),
        gh<_i852.MarkAllNotificationsRead>(),
        gh<_i826.DeleteNotification>(),
      ),
    );
    gh.lazySingleton<_i819.CheckServerHealth>(
      () => _i819.CheckServerHealth(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i342.ResetAttendance>(
      () => _i342.ResetAttendance(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i375.GetMyCourses>(
      () => _i375.GetMyCourses(gh<_i736.ScheduleRepository>()),
    );
    gh.lazySingleton<_i788.ChangePasswordUseCase>(
      () => _i788.ChangePasswordUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i52.CheckAuthStatusUseCase>(
      () => _i52.CheckAuthStatusUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i48.LogoutUseCase>(
      () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i573.SettingsCubit>(
      () => _i573.SettingsCubit(
        gh<_i819.CheckServerHealth>(),
        gh<_i342.ResetAttendance>(),
      ),
    );
    gh.factory<_i112.ScheduleBloc>(
      () => _i112.ScheduleBloc(gh<_i375.GetMyCourses>()),
    );
    gh.lazySingleton<_i85.AuthBloc>(
      () => _i85.AuthBloc(
        gh<_i188.LoginUseCase>(),
        gh<_i52.CheckAuthStatusUseCase>(),
        gh<_i788.ChangePasswordUseCase>(),
        gh<_i48.LogoutUseCase>(),
      ),
    );
    gh.singleton<_i81.AppRouter>(() => _i81.AppRouter(gh<_i85.AuthBloc>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
