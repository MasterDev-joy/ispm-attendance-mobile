// lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/extensions/user_role_ext.dart.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../home/presentation/widgets/shared/home_logout_dialog.dart';
import '../blocs/profile_bloc.dart';

const _kBlue = Color(0xFF378ADD);
const _kAmber = Color(0xFFBA7517);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // ✅ Injection via get_it + déclenchement immédiat du chargement
      create: (_) =>
          GetIt.I<ProfileBloc>()..add(const ProfileEvent.getProfileRequested()),
      child: const _ProfileView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Color _accentFor(UserRole role) => switch (role) {
    UserRole.professor => ISPMColors.green,
    UserRole.supervisor => _kBlue,
    UserRole.admin => _kAmber,
    UserRole.unknown => Colors.grey,
  };

  Widget _stagger(int i, Widget child) {
    final start = (0.10 * i).clamp(0.0, 0.8);
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animCtrl,
        curve: Interval(start, 1.0, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animCtrl,
                curve: Interval(start, 1.0, curve: Curves.easeOutCubic),
              ),
            ),
        child: child,
      ),
    );
  }

  void _logout(BuildContext context) {
    showLogoutDialog(
      context,
      onConfirm: () {
        context.read<AuthBloc>().add(AuthEvent.logoutRequested());
        context.go('/login'); // ✅ GoRouter
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (ctx, state) {
        state.whenOrNull(
          error: (message) => ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              backgroundColor: ISPMColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
      builder: (ctx, state) {
        return state.when(
          initial: () =>
              _scaffold(accent: ISPMColors.green, child: _loadingBody()),
          loading: () =>
              _scaffold(accent: ISPMColors.green, child: _loadingBody()),
          error: (_) =>
              _scaffold(accent: ISPMColors.green, child: _loadingBody()),
          loaded: (user, isUpdating) {
            final accent = _accentFor(user.role);
            return _scaffold(
              accent: accent,
              child: _body(ctx, user, accent, isUpdating),
            );
          },
        );
      },
    );
  }

  Widget _loadingBody() => const Center(
    child: CircularProgressIndicator(color: ISPMColors.green, strokeWidth: 2.5),
  );

  Widget _scaffold({required Color accent, required Widget child}) {
    return Scaffold(
      backgroundColor: ISPMColors.black,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: IspmGlowBlob.circle(
              radius: 200,
              primaryColor: accent.withOpacity(0.09),
              secondaryColor: Colors.transparent,
            ),
          ),
          Positioned(
            bottom: -80,
            left: -40,
            child: IspmGlowBlob.circle(
              radius: 160,
              primaryColor: accent.withOpacity(0.06),
              secondaryColor: Colors.transparent,
            ),
          ),
          const Positioned.fill(child: IspmMeshGrid()),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _ProfileAppBar(
                  accent: accent,
                  onBack: () => context.pop(), // ✅ GoRouter
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, User user, Color accent, bool isUpdating) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
      physics: const BouncingScrollPhysics(),
      children: [
        _stagger(0, _IdentityCard(user: user, accent: accent)),
        const SizedBox(height: 24),
        _stagger(1, _RoleMetrics(role: user.role, accent: accent)),
        const SizedBox(height: 24),
        _stagger(2, const _SectionLabel(label: 'Compte')),
        const SizedBox(height: 10),
        _stagger(
          3,
          _ProfileMenuItem(
            icon: Icons.lock_outline_rounded,
            label: 'Changer le mot de passe',
            accent: accent,
            // ✅ GoRouter
            onTap: () => context.push('/change-password', extra: user),
          ),
        ),
        _stagger(
          4,
          _ProfileMenuToggle(
            icon: Icons.fingerprint_rounded,
            label: 'Authentification biométrique',
            subtitle: 'Empreinte digitale / Face ID',
            accent: accent,
            value: _biometricsEnabled,
            onChanged: (v) {
              setState(() => _biometricsEnabled = v);
              HapticFeedback.selectionClick();
              // TODO: persister dans SharedPreferences
            },
          ),
        ),
        const SizedBox(height: 20),
        _stagger(5, const _SectionLabel(label: 'Préférences')),
        const SizedBox(height: 10),
        _stagger(
          6,
          _ProfileMenuToggle(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            subtitle: 'Alertes cours & présences',
            accent: accent,
            value: _notificationsEnabled,
            onChanged: (v) {
              setState(() => _notificationsEnabled = v);
              HapticFeedback.selectionClick();
            },
          ),
        ),
        _stagger(
          7,
          _ProfileMenuItem(
            icon: Icons.info_outline_rounded,
            label: 'À propos de l\'application',
            accent: accent,
            trailing: Text(
              'v1.0.0',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: ISPMColors.white.withOpacity(0.30),
              ),
            ),
            onTap: () => _showAboutDialog(context, accent),
          ),
        ),
        const SizedBox(height: 28),
        _stagger(8, _LogoutButton(onTap: () => _logout(context))),
        const SizedBox(height: 16),
        _stagger(
          9,
          Center(
            child: Text(
              'ID: ${user.id}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: ISPMColors.white.withOpacity(0.18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAboutDialog(BuildContext context, Color accent) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.60),
      builder: (_) => Dialog(
        backgroundColor: ISPMColors.grey900,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: accent.withOpacity(0.30)),
                ),
                child: Icon(Icons.school_rounded, size: 30, color: accent),
              ),
              const SizedBox(height: 16),
              const Text(
                'ISPM Présence',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ISPMColors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: ISPMColors.white.withOpacity(0.40),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Système de gestion des présences du personnel de '
                'l\'Institut Supérieur Polytechnique de Madagascar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: ISPMColors.white.withOpacity(0.45),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => context.pop(), // ✅ GoRouter
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: accent.withOpacity(0.35)),
                  ),
                  child: Text(
                    'Fermer',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Widgets réutilisables — inchangés sauf user.name → user.fullName
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileAppBar extends StatelessWidget {
  final Color accent;
  final VoidCallback onBack;
  const _ProfileAppBar({required this.accent, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ISPMColors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ISPMColors.white.withOpacity(0.09)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: ISPMColors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Mon profil',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: ISPMColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityCard extends StatelessWidget {
  final User user;
  final Color accent;
  const _IdentityCard({required this.user, required this.accent});

  @override
  Widget build(BuildContext context) {
    // ✅ user.fullName via le getter, initiale depuis firstName
    final initial = user.firstName.trim().isNotEmpty
        ? user.firstName.trim()[0].toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.10),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accent.withOpacity(0.50),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.20),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: ISPMColors.grey900, width: 2),
                ),
                // ✅ user.role est maintenant un enum — roleIcon via extension
                child: Icon(
                  user.role.roleIcon,
                  size: 12,
                  color: ISPMColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // ✅ fullName au lieu de name
          Text(
            user.fullName,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: ISPMColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: ISPMColors.white.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.13),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withOpacity(0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(user.role.roleIcon, size: 13, color: accent),
                const SizedBox(width: 6),
                // ✅ roleLabel via extension sur UserRole
                Text(
                  user.role.roleLabel,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Métriques rapides par rôle
// ─────────────────────────────────────────────────────────────────────────────

class _RoleMetrics extends StatelessWidget {
  final UserRole role;
  final Color accent;
  const _RoleMetrics({required this.role, required this.accent});

  @override
  Widget build(BuildContext context) {
    final items = switch (role) {
      UserRole.professor => [
        _MetricItem(
          icon: Icons.calendar_today_rounded,
          value: '—',
          label: 'Cours cette semaine',
        ),
        _MetricItem(
          icon: Icons.check_circle_outline_rounded,
          value: '—',
          label: 'Taux de présence',
        ),
        _MetricItem(
          icon: Icons.qr_code_rounded,
          value: '—',
          label: 'QR générés',
        ),
      ],
      UserRole.supervisor => [
        _MetricItem(
          icon: Icons.qr_code_scanner_rounded,
          value: '—',
          label: 'Scans aujourd\'hui',
        ),
        _MetricItem(
          icon: Icons.verified_rounded,
          value: '—',
          label: 'Cours validés',
        ),
        _MetricItem(
          icon: Icons.warning_amber_rounded,
          value: '—',
          label: 'Non couverts',
        ),
      ],
      UserRole.admin => [
        _MetricItem(
          icon: Icons.group_rounded,
          value: '—',
          label: 'Utilisateurs',
        ),
        _MetricItem(
          icon: Icons.calendar_month_rounded,
          value: '—',
          label: 'Cours planifiés',
        ),
        _MetricItem(
          icon: Icons.trending_up_rounded,
          value: '—',
          label: 'Taux global',
        ),
      ],
      UserRole.unknown => [],
    };

    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: items.indexOf(item) == 0 ? 0 : 6,
                  right: items.indexOf(item) == items.length - 1 ? 0 : 6,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: ISPMColors.grey900,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ISPMColors.white.withOpacity(0.06)),
                ),
                child: Column(
                  children: [
                    Icon(item.icon, size: 20, color: accent),
                    const SizedBox(height: 7),
                    Text(
                      item.value,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 9,
                        color: ISPMColors.white.withOpacity(0.35),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MetricItem {
  final IconData icon;
  final String value;
  final String label;
  const _MetricItem({
    required this.icon,
    required this.value,
    required this.label,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
//  Label de section
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: ISPMColors.white.withOpacity(0.38),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Divider(
            color: ISPMColors.white.withOpacity(0.07),
            thickness: 0.5,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Item de menu standard
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback onTap;
  final Widget? trailing;
  final String? subtitle;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onTap,
    this.trailing,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: ISPMColors.grey900,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ISPMColors.white.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            // Icône
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.11),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: accent.withOpacity(0.22)),
              ),
              child: Icon(icon, size: 18, color: accent),
            ),
            const SizedBox(width: 13),

            // Label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ISPMColors.white,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: ISPMColors.white.withOpacity(0.35),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing ou chevron
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: ISPMColors.white.withOpacity(0.25),
                ),
          ],
        ),
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
//  Item de menu avec toggle Switch
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileMenuToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color accent;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ProfileMenuToggle({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.accent,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value
              ? accent.withOpacity(0.30)
              : ISPMColors.white.withOpacity(0.06),
          width: value ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          // Icône
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: (value ? accent : ISPMColors.white).withOpacity(0.10),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: (value ? accent : ISPMColors.white).withOpacity(0.18),
              ),
            ),
            child: Icon(
              icon,
              size: 18,
              color: value ? accent : ISPMColors.white.withOpacity(0.40),
            ),
          ),
          const SizedBox(width: 13),

          // Label + sous-titre
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ISPMColors.white.withOpacity(value ? 1.0 : 0.75),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: ISPMColors.white.withOpacity(0.35),
                  ),
                ),
              ],
            ),
          ),

          // Switch custom
          Transform.scale(
            scale: 0.85,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: accent,
              activeTrackColor: accent.withOpacity(0.35),
              inactiveThumbColor: ISPMColors.white.withOpacity(0.40),
              inactiveTrackColor: ISPMColors.white.withOpacity(0.10),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Bouton déconnexion
// ─────────────────────────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: ISPMColors.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ISPMColors.error.withOpacity(0.30),
            width: 1.5,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 18, color: ISPMColors.error),
            SizedBox(width: 10),
            Text(
              'Se déconnecter',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ISPMColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
