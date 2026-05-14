// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

// Blocs
import 'features/attendance/presentation/blocs/attendance_bloc.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/notifications/presentation/blocs/notification_bloc.dart';
import 'features/schedule/presentation/blocs/schedule_bloc.dart';
import 'features/courses_management/presentation/pages/courses_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/reports/presentation/blocs/report_bloc.dart';
import 'features/stats/presentation/blocs/stats_bloc.dart';

// Pages Auth
import 'features/auth/domain/entities/user.dart';
import 'features/auth/presentation/pages/change_password_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';

// Pages Home
import 'features/home/presentation/pages/home_page.dart';

// Pages Attendance
import 'features/attendance/presentation/pages/attendance_scanner_page.dart';
import 'features/attendance/presentation/pages/qr_generator_page.dart';

// Pages Schedule
import 'features/schedule/presentation/pages/schedule_page.dart';

// Pages Stats
import 'features/reports/presentation/pages/reports_page.dart';
import 'features/stats/presentation/pages/stats_page.dart';

// Pages Notifications
import 'features/notifications/presentation/pages/notifications_page.dart';

// Pages Profile
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/users_management/presentation/pages/users_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Barre système — transparente, icônes claires (dark app)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: ISPMColors.grey900,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Portrait uniquement
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  configureDependencies();
  runApp(const ISPMApp());
}

// ─────────────────────────────────────────────────────────────────────────────

class ISPMApp extends StatelessWidget {
  const ISPMApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Récupération des instances uniques (Singletons) depuis GetIt
    final authBloc = sl<AuthBloc>();
    final appRouter = sl<AppRouter>();
    return MultiBlocProvider(
      providers: [
        // Auth — singleton global + vérification session au démarrage
        BlocProvider.value(value: authBloc),

        // Notifications — chargé automatiquement au démarrage et disponible partout
        BlocProvider(
          create: (_) =>
              sl<NotificationBloc>()
                ..add(const NotificationEvent.loadNotifications()),
        ),
      ],
      child: MaterialApp.router(
        title: 'ISPM Présence',
        debugShowCheckedModeBanner: false,

        // ── Thème dark pour toute l'app ─────────────────────────────
        theme: ISPMTheme.dark,

        // ── Page d'entrée ───────────────────────────────────────────
        routerConfig: appRouter.router,
      ),
    );
  }
}
