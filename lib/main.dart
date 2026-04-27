// lib/main.dart — Version redesignée ISPM
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';

import 'features/attendance/presentation/blocs/attendance_bloc.dart';
import 'features/attendance/presentation/pages/attendance_scanner_page.dart';
import 'features/auth/domain/entities/user.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/auth/presentation/blocs/auth_event.dart';
import 'features/home/presentation/page/home_page.dart';
import 'features/notifications/presentation/pages/notifications_page.dart';
import 'features/schedule/presentation/blocs/schedule_bloc.dart';

import 'features/auth/presentation/pages/change_password_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/schedule/presentation/pages/schedule_page.dart';
import 'features/stats/presentation/pages/stats_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Barre système transparente
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  // Orientation portrait uniquement (app mobile)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await init();
  runApp(const ISPMApp());
}

class ISPMApp extends StatelessWidget {
  const ISPMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (_) => di.sl<ScheduleBloc>()),
        BlocProvider(create: (_) => di.sl<AttendanceBloc>()),
      ],
      child: MaterialApp(
        title: 'ISPM Présence',
        debugShowCheckedModeBanner: false,
        // ── Thème ISPM ──
        theme: ISPMTheme.light,
        home: const SplashPage(),
        routes: {
          '/login': (_) => const LoginPage(),
          '/change-password': (context) => ChangePasswordPage(
            user: ModalRoute.of(context)!.settings.arguments as User,
          ),
          '/home': (_) => const HomePage(),
          '/scanner': (_) => const AttendanceScannerPage(),
          '/notifications': (_) => const NotificationsPage(),
          '/stats': (_) => const StatsPage(),
        },
        // Transitions de pages fluides
        onGenerateRoute: (settings) {
          Widget? page;
          switch (settings.name) {
            case '/login':
              page = const LoginPage();
              break;
            case '/home':
              page = const HomePage();
              break;
            case '/scanner':
              page = const AttendanceScannerPage();
              break;
            case '/change-password':
              page = ChangePasswordPage(
                user: settings.arguments as User,
              );
              break;
          }
          if (page == null) return null;
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => page!,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.04, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  )),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),
    );
  }
}
