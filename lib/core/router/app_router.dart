// lib/core/router/app_router.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:ispm_attendance/features/auth/domain/entities/user.dart';
import 'package:ispm_attendance/features/schedule/domain/entities/course.dart';

import '../../features/attendance/presentation/pages/qr_generator_page.dart';
import '../../features/attendance/presentation/pages/validation_success_page.dart';
import '../../features/auth/presentation/blocs/auth_bloc.dart';
import '../../features/courses_management/presentation/blocs/course_bloc.dart';
import '../../features/profile/presentation/blocs/profile_bloc.dart';
import '../../features/reports/presentation/blocs/report_bloc.dart';
import '../../features/schedule/presentation/blocs/schedule_bloc.dart';
import '../../features/settings/presentation/blocs/settings_cubit.dart';
import '../../features/stats/presentation/blocs/stats_bloc.dart';
import '../../features/users_management/presentation/blocs/user_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/courses_management/presentation/pages/courses_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/schedule/presentation/pages/schedule_page.dart';
import '../../features/session_detail/presentation/blocs/session_detail_bloc.dart';
import '../../features/session_detail/presentation/pages/session_detail_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/stats/presentation/pages/stats_page.dart';
import '../../features/users_management/presentation/pages/users_page.dart';
import '../di/injection_container.dart';

@singleton
class AppRouter {
  final AuthBloc _authBloc;

  // On injecte directement l'AuthBloc via injectable
  AppRouter(this._authBloc);

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',

    // 🟢 CRUCIAL : Permet au routeur de redéclencher le redirect
    // à chaque fois que l'état de l'AuthBloc change.
    refreshListenable: _BlocStreamListenable(_authBloc.stream),

    redirect: _guard,

    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => buildIspmTransition(
          context: context,
          state: state,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: '/change-password/:userId',
        name: 'change-password',
        pageBuilder: (context, state) {
          return buildIspmTransition(
            context: context,
            state: state,
            child: ChangePasswordPage(user: state.extra as User),
          );
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => buildIspmTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (_) => sl<ScheduleBloc>(),
            child: const HomePage(),
          ),
        ),
      ),
      GoRoute(
        path: '/session/:id',
        name: 'session-detail',
        pageBuilder: (context, state) {
          return buildIspmTransition(
            context: context,
            state: state,
            child: BlocProvider(
              create: (_) => sl<SessionDetailBloc>(),
              child: SessionDetailPage(course: state.extra as Course),
            ),
          );
        },
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        pageBuilder: (context, state) => buildIspmTransition(
          context: context,
          state: state,
          child: const NotificationsPage(),
        ),
      ),
      GoRoute(
        path: '/qr-generator/:id',
        name: 'qr-generator',
        pageBuilder: (context, state) {
          return buildIspmTransition(
            context: context,
            state: state,
            child: QrGeneratorPage(course: state.extra as Course),
          );
        },
      ),
      GoRoute(
        path: '/validation-success/:id',
        name: 'validation-success',
        pageBuilder: (context, state) {
          return buildIspmTransition(
            context: context,
            state: state,
            child: ValidationSuccessPage(
              validationData: state.extra as Map<String, dynamic>,
            ),
          );
        },
      ),
      GoRoute(
        path: '/courses',
        name: 'courses',
        pageBuilder: (context, state) => buildIspmTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (_) => sl<CourseBloc>(),
            child: const CoursesPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/schedule',
        name: 'schedule',
        pageBuilder: (context, state) => buildIspmTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (_) => sl<ScheduleBloc>(),
            child: const SchedulePage(),
          ),
        ),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) => buildIspmTransition(
          context: context,
          state: state,
          child: const ProfilePage(),
        ),
      ),
      GoRoute(
        path: '/reports',
        name: 'reports',
        pageBuilder: (context, state) => buildIspmTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (_) => sl<ReportBloc>(),
            child: const ReportsPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => buildIspmTransition(
          context: context,
          state: state,
          child: const SettingsPage(),
        ),
      ),
      GoRoute(
        path: '/stats',
        name: 'stats',
        pageBuilder: (context, state) => buildIspmTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (_) => sl<StatsBloc>(),
            child: const StatsPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/users',
        name: 'users',
        pageBuilder: (context, state) => buildIspmTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (_) => sl<UserBloc>(),
            child: const UsersPage(),
          ),
        ),
      ),
    ],
  );

  /// 🛡️ Logique de protection des routes
  String? _guard(BuildContext context, GoRouterState state) {
    final authState = _authBloc.state;
    debugPrint("--- ROUTER GUARD : État actuel = $authState ---");

    final bool isLoggingIn = state.matchedLocation == '/login';
    final bool isSplashing = state.matchedLocation == '/splash';
    final bool isChangingPassword = state.matchedLocation.startsWith(
      '/change-password',
    );

    return authState.maybeWhen(
      // 1. Utilisateur connecté
      authenticated: (user) {
        // Si l'utilisateur est sur Splash, Login ou ChangePassword, on l'envoie vers Home
        if (isLoggingIn || isSplashing || isChangingPassword) {
          return '/home';
        }
        // Sinon, on le laisse là où il est (null = pas de redirection)
        return null;
      },

      // 2. Doit changer son mot de passe
      requiresPasswordChange: (user) {
        // Si on n'est pas déjà sur la page de changement, on y force l'accès
        if (!isChangingPassword) {
          return '/change-password/${user.id}';
        }
        return null;
      },

      // 3. Non authentifié (déconnexion ou erreur)
      unauthenticated: () {
        // Si on n'est pas sur login et qu'on n'est plus en train de charger (splash), direction login
        if (!isLoggingIn) return '/login';
        return null;
      },

      // 4. Cas d'erreur (souvent traité comme non authentifié)
      error: (_) {
        if (!isLoggingIn) return '/login';
        return null;
      },

      // 5. Loading / Initial
      orElse: () {
        // On reste sur le Splash pendant le chargement initial
        if (!isSplashing) return '/splash';
        return null;
      },
    );
  }
}

/// 💡 Utilitaire pour convertir le Stream du BLoC en Listenable pour GoRouter
class _BlocStreamListenable extends ChangeNotifier {
  late final StreamSubscription _subscription;

  _BlocStreamListenable(Stream stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// 🌀 Transition personnalisée pour les pages (optionnel, mais ça rend l'app plus fluide)
CustomTransitionPage buildIspmTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final slide = Tween<Offset>(
        begin: const Offset(0.04, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}
