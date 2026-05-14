// lib/features/home/presentation/pages/home_page.dart
//
// ══════════════════════════════════════════════════════════════════════════════
//  ORCHESTRATEUR — HomePage
// ══════════════════════════════════════════════════════════════════════════════
//
// Responsabilités UNIQUEMENT :
//   1. Lire user.role depuis AuthBloc
//   2. Résoudre UserRole enum → couleur accent + nav items
//   3. Monter le bon body (Professor / Supervisor / Admin)
//   4. Composer HomeAppBar + HomeBottomNav + background (blobs + mesh)
//   5. Gérer le Timer horloge (now) partagé avec les body
//   6. Déclencher LoadScheduleEvent au démarrage
//
// Ce fichier ne contient AUCUNE logique d'affichage métier.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/extensions/user_role_ext.dart.dart';

// Core
import '../../../../core/theme/app_theme.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';

// Auth
import '../../../auth/presentation/blocs/auth_bloc.dart';

// Schedule
import '../../../schedule/presentation/blocs/schedule_bloc.dart';
// Shared widgets
import '../widgets/shared/home_app_bar.dart';
import '../widgets/shared/home_bottom_nav.dart';
import '../widgets/shared/home_logout_dialog.dart';

// Body pages par rôle
import 'professor_home_body.dart';
import 'supervisor_home_body.dart';
import 'admin_home_body.dart';

// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // ── Horloge ───────────────────────────────────────────────────────────────
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  // ── Animation d'entrée ────────────────────────────────────────────────────
  late AnimationController _animController;

  // ── Navigation ────────────────────────────────────────────────────────────
  int _selectedIndex = 0;

  // ─────────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    // Horloge — tick chaque seconde pour mettre à jour les progressions
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });

    // Animation staggerée d'entrée
    _animController = AnimationController(
      duration: const Duration(milliseconds: 950),
      vsync: this,
    )..forward();

    // Charger le planning dès l'ouverture
    context.read<ScheduleBloc>().add(ScheduleEvent.load());

    // Barre système — icônes claires sur fond sombre
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _animController.dispose();
    super.dispose();
  }

  // ── Tap navigation ────────────────────────────────────────────────────────

  void _onNavTap(int index, List<NavItem> items) {
    final item = items[index];

    setState(() => _selectedIndex = index);

    // Home → pas de navigation, juste sélection
    if (item.route == '/home') return;

    // Scanner → toujours push (pas de pop si déjà ouvert)
    if (item.isScanner) {
      context.push('/scanner');
      return;
    }

    context.push(item.route);
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  void _handleLogout() {
    showLogoutDialog(
      context,
      onConfirm: () {
        context.read<AuthBloc>().add(AuthEvent.logoutRequested());
      },
    );
  }

  // ── Build principal ───────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        // ── Extraction des données utilisateur ──────────────────────
        String userName = 'Utilisateur'; // Valeur par défaut
        UserRole role = UserRole.professor; // Valeur par défaut
        bool hasNotification = false; // Valeur par défaut

        // Utilisation de maybeWhen pour extraire proprement l'utilisateur
        authState.maybeWhen(
          authenticated: (user) {
            userName = user.fullName;
            role = user.role;
            hasNotification = false; // TODO: brancher NotificationBloc
          },
          orElse: () {
            // Fallback géré par les valeurs par défaut définies au-dessus!
          },
        );

        final accent = role.accentColor;
        final navItems = role.navItems;

        return Scaffold(
          backgroundColor: ISPMColors.black,
          extendBody: true,

          // ── Barre de navigation ──────────────────────────────────
          bottomNavigationBar: HomeBottomNav(
            items: navItems,
            selectedIndex: _selectedIndex,
            onTap: (i) => _onNavTap(i, navItems),
            activeColor: role.accentColor,
          ),

          body: Stack(
            children: [
              // ────────────────────────────────────────────────────
              //  BACKGROUND : blobs + mesh
              // ────────────────────────────────────────────────────
              Positioned(
                top: -100,
                left: -80,
                child: IspmGlowBlob.circle(
                  radius: 220,
                  primaryColor: accent.withOpacity(0.10),
                  secondaryColor: accent.withOpacity(0.05),
                ),
              ),
              Positioned(
                top: 300,
                right: -90,
                child: IspmGlowBlob.circle(
                  radius: 150,
                  primaryColor: accent.withOpacity(0.07),
                  secondaryColor: Colors.transparent,
                ),
              ),
              Positioned(
                bottom: -80,
                left: -40,
                child: IspmGlowBlob.circle(
                  radius: 170,
                  primaryColor: accent.withOpacity(0.06),
                  secondaryColor: Colors.transparent,
                ),
              ),
              const Positioned.fill(child: IspmMeshGrid()),

              // ────────────────────────────────────────────────────
              //  CONTENU PRINCIPAL
              // ────────────────────────────────────────────────────
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // ── AppBar ─────────────────────────────────────
                    _AnimatedAppBar(
                      animController: _animController,
                      child: HomeAppBar(
                        userName: userName,
                        role: role,
                        hasNotification: hasNotification,
                        onNotificationTap: () => context.push('/notifications'),
                        onLogoutTap: _handleLogout,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // ── Date + badge statut ────────────────────────
                    _AnimatedAppBar(
                      animController: _animController,
                      child: _DateRow(now: _now, icon: role),
                    ),

                    const SizedBox(height: 4),

                    // ── Body selon le rôle ─────────────────────────
                    Expanded(child: _buildBody(role)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Sélection du body selon le rôle ──────────────────────────────────────

  Widget _buildBody(UserRole role) {
    return switch (role) {
      UserRole.professor => ProfessorHomeBody(
        now: _now,
        animController: _animController,
      ),
      UserRole.supervisor => SupervisorHomeBody(
        now: _now,
        animController: _animController,
      ),
      UserRole.admin => AdminHomeBody(
        now: _now,
        animController: _animController,
      ),
      UserRole.unknown => const Center(child: Text('Rôle inconnu')),
    };
  }
}

// ── Widget date + pill rôle ───────────────────────────────────────────────────

class _DateRow extends StatelessWidget {
  final DateTime now;
  final UserRole icon;

  const _DateRow({required this.now, required this.icon});

  String get _dateText {
    const days = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];
    const months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];
    return '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Row(
        children: [
          Icon(
            icon.roleIcon,
            size: 13,
            color: ISPMColors.white.withOpacity(0.40),
          ),

          const SizedBox(width: 6),

          // Date
          Text(
            _dateText,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: ISPMColors.white.withOpacity(0.40),
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(width: 10),

          // Divider extensible
          const Expanded(
            child: Divider(
              color: Color(0x14FFFFFF), // white 8%
              thickness: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animation fade+slide de l'AppBar ─────────────────────────────────────────

class _AnimatedAppBar extends StatelessWidget {
  final AnimationController animController;
  final Widget child;

  const _AnimatedAppBar({required this.animController, required this.child});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -0.15), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: animController,
                curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
              ),
            ),
        child: child,
      ),
    );
  }
}
