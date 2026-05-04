// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';

// Blocs
import 'features/attendance/presentation/blocs/attendance_bloc.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/auth/presentation/blocs/auth_event.dart';
import 'features/notifications/presentation/blocs/notification_bloc.dart';
import 'features/notifications/presentation/blocs/notification_event.dart';
import 'features/schedule/presentation/blocs/schedule_bloc.dart';
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
import 'features/stats/presentation/pages/stats_page.dart';

// Pages Notifications
import 'features/notifications/presentation/pages/notifications_page.dart';

// Pages Profile
import 'features/profile/presentation/pages/profile_page.dart';

// Pages Admin (à créer)
// import 'features/admin/presentation/pages/users_page.dart';
// import 'features/admin/presentation/pages/courses_page.dart';
// import 'features/admin/presentation/pages/reports_page.dart';

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

  await di.init();
  runApp(const ISPMApp());
}

// ─────────────────────────────────────────────────────────────────────────────

class ISPMApp extends StatelessWidget {
  const ISPMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth — singleton global + vérification session au démarrage
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),

        // Schedule — partagé home + schedule page
        BlocProvider(create: (_) => di.sl<ScheduleBloc>()),

        // Attendance — partagé scanner + qr generator
        BlocProvider(create: (_) => di.sl<AttendanceBloc>()),

        // Notifications — chargé automatiquement au démarrage
        BlocProvider(
          create: (_) =>
          di.sl<NotificationBloc>()..add(LoadNotificationsEvent()),
        ),

        // Stats — chargé à la demande depuis StatsPage
        BlocProvider(create: (_) => di.sl<StatsBloc>()),
      ],
      child: MaterialApp(
        title: 'ISPM Présence',
        debugShowCheckedModeBanner: false,

        // ── Thème dark pour toute l'app ─────────────────────────────
        theme: ISPMTheme.dark,

        // ── Page d'entrée ───────────────────────────────────────────
        home: const SplashPage(),

        // ── Routes nommées ──────────────────────────────────────────
        // Note : onGenerateRoute ci-dessous prend la priorité pour
        // les routes avec arguments et les transitions custom.
        // On garde routes: comme fallback simple.
        routes: {
          '/login':         (_) => const LoginPage(),
          '/home':          (_) => const HomePage(),
          '/scanner':       (_) => const AttendanceScannerPage(),
          '/schedule':      (_) => const SchedulePage(),
          '/stats':         (_) => const StatsPage(),
          '/notifications': (_) => const NotificationsPage(),
          // Admin — commenté jusqu'à création des pages
          // '/users':    (_) => const UsersPage(),
          // '/courses':  (_) => const CoursesPage(),
          // '/reports':  (_) => const ReportsPage(),
          // '/settings': (_) => const SettingsPage(),
          // Profile — commenté jusqu'à création
          '/profile':  (_) => const ProfilePage(),
        },

        // ── Transitions fluides + routes avec arguments ─────────────
        onGenerateRoute: (settings) {
          Widget? page;

          switch (settings.name) {
          // ── Auth ────────────────────────────────────────────────
            case '/login':
              page = const LoginPage();

            case '/change-password':
              final user = settings.arguments as User?;
              if (user == null) return null;
              page = ChangePasswordPage(user: user);

          // ── App principale ──────────────────────────────────────
            case '/home':
              page = const HomePage();

            case '/schedule':
              page = const SchedulePage();

            case '/scanner':
              page = const AttendanceScannerPage();

            case '/stats':
              page = const StatsPage();

            case '/notifications':
              page = const NotificationsPage();

          // ── Admin (placeholder jusqu'à création des pages) ──────
            case '/users':
              page = _PlaceholderPage(
                title: 'Utilisateurs',
                icon: Icons.group_rounded,
                color: const Color(0xFFBA7517),
              );

            case '/courses':
              page = _PlaceholderPage(
                title: 'Tous les cours',
                icon: Icons.calendar_month_rounded,
                color: const Color(0xFFBA7517),
              );

            case '/reports':
              page = _PlaceholderPage(
                title: 'Rapports & exports',
                icon: Icons.insert_drive_file_rounded,
                color: const Color(0xFFBA7517),
              );

            case '/settings':
              page = _PlaceholderPage(
                title: 'Paramètres système',
                icon: Icons.settings_rounded,
                color: ISPMColors.grey400,
              );

          // ── Profile ──────────────────────────────────────────────
            case '/profile':
              page = const ProfilePage();

            default:
              return null;
          }

          return _ispmPageRoute(settings: settings, page: page);
        },
      ),
    );
  }
}

// ── Transition standard ISPM : fade + slide horizontal léger ─────────────────

PageRouteBuilder _ispmPageRoute({
  required RouteSettings settings,
  required Widget page,
}) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (_, animation, __, child) {
      final fade = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );
      final slide = Tween<Offset>(
        begin: const Offset(0.04, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

// ── Page placeholder — remplacée une fois les vraies pages créées ─────────────

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _PlaceholderPage({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ISPMColors.black,
      appBar: AppBar(
        backgroundColor: ISPMColors.grey900,
        surfaceTintColor: Colors.transparent,
        foregroundColor: ISPMColors.white,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ISPMColors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: color.withOpacity(0.30)),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ISPMColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Page en cours de développement',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: ISPMColors.white.withOpacity(0.38),
              ),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color.withOpacity(0.40)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Retour',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}