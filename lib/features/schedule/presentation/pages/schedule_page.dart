// lib/features/schedule/presentation/pages/schedule_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../attendance/presentation/pages/qr_generator_page.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_event.dart';
import '../../../auth/presentation/blocs/auth_state.dart';
import '../blocs/schedule_bloc.dart';
import '../blocs/schedule_event.dart';
import '../blocs/schedule_state.dart';
import '../../domain/entities/course.dart';
import '../../../../core/theme/app_theme.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _selectedTab = 0; // 0 = Emploi du temps, 1 = Profil

  @override
  void initState() {
    super.initState();
    context.read<ScheduleBloc>().add(LoadScheduleEvent());
  }

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  String _formatDate() {
    final now = DateTime.now();
    const days = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi',
      'Vendredi', 'Samedi', 'Dimanche'
    ];
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]}';
  }

  bool _isCurrent(Course course) {
    final now = DateTime.now();
    return now.isAfter(course.startTime) && now.isBefore(course.endTime);
  }

  bool _isPast(Course course) {
    return DateTime.now().isAfter(course.endTime);
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Déconnexion',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Voulez-vous vraiment vous déconnecter ?',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler',
                style: TextStyle(fontFamily: 'Poppins', color: ISPMColors.grey400)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(LogoutRequestedEvent());
              Navigator.of(context).pushReplacementNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ISPMColors.error,
              minimumSize: const Size(80, 38),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Quitter',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final isInvigilator =
            authState is AuthAuthenticated && authState.user.role == 'INVIGILATOR';
        final userName = authState is AuthAuthenticated
            ? authState.user.name
            : 'Utilisateur';

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8F6),
          body: IndexedStack(
            index: _selectedTab,
            children: [
              _ScheduleTab(
                userName: userName,
                formatDate: _formatDate,
                formatTime: _formatTime,
                isCurrent: _isCurrent,
                isPast: _isPast,
                authState: authState,
                onLogout: () => _logout(context),
              ),
              _ProfileTab(
                userName: userName,
                authState: authState,
                onLogout: () => _logout(context),
              ),
            ],
          ),
          // ── Bottom Navigation Bar ──
          bottomNavigationBar: _ISPMBottomNav(
            selectedIndex: _selectedTab,
            isInvigilator: isInvigilator,
            onTap: (index) {
              if (index == 1 && isInvigilator) {
                // Bouton scanner central
                Navigator.pushNamed(context, '/scanner');
              } else {
                setState(() => _selectedTab = isInvigilator ? (index == 2 ? 1 : 0) : index);
              }
            },
          ),
        );
      },
    );
  }
}

// ── Onglet emploi du temps ───────────────────────────────────────────
class _ScheduleTab extends StatelessWidget {
  final String userName;
  final String Function() formatDate;
  final String Function(DateTime) formatTime;
  final bool Function(Course) isCurrent;
  final bool Function(Course) isPast;
  final AuthState authState;
  final VoidCallback onLogout;

  const _ScheduleTab({
    required this.userName,
    required this.formatDate,
    required this.formatTime,
    required this.isCurrent,
    required this.isPast,
    required this.authState,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            // ── SliverAppBar avec en-tête riche ──
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              backgroundColor: ISPMColors.black,
              surfaceTintColor: Colors.transparent,
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: ISPMColors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.logout_rounded,
                        size: 18, color: ISPMColors.white),
                  ),
                  onPressed: onLogout,
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: ISPMColors.black,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: ISPMColors.green,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                userName.isNotEmpty
                                    ? userName[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: ISPMColors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bonjour,',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  color: ISPMColors.white.withOpacity(0.5),
                                ),
                              ),
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ISPMColors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        formatDate(),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: ISPMColors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Emploi du temps du jour',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: ISPMColors.white.withOpacity(0.45),
                        ),
                      ),
                    ],
                  ),
                ),
                titlePadding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                title: Text(
                  formatDate(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ISPMColors.white,
                  ),
                ),
              ),
            ),

            // ── Corps ──
            if (state is ScheduleLoading || state is ScheduleInitial)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: ISPMColors.green),
                ),
              )
            else if (state is ScheduleError)
              SliverFillRemaining(
                child: _ErrorState(
                  message: state.message,
                  onRetry: () =>
                      context.read<ScheduleBloc>().add(LoadScheduleEvent()),
                ),
              )
            else if (state is ScheduleLoaded && state.courses.isEmpty)
                const SliverFillRemaining(child: _EmptyState())
              else if (state is ScheduleLoaded) ...[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          const Text(
                            'Cours du jour',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ISPMColors.black,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: ISPMColors.greenSoft,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${state.courses.length}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ISPMColors.greenDark,
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => context
                                .read<ScheduleBloc>()
                                .add(LoadScheduleEvent()),
                            child: const Row(
                              children: [
                                Icon(Icons.refresh_rounded,
                                    size: 16, color: ISPMColors.grey400),
                                SizedBox(width: 4),
                                Text(
                                  'Actualiser',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: ISPMColors.grey400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (ctx, i) {
                          final course = state.courses[i];
                          final current = isCurrent(course);
                          final past = isPast(course);
                          return _CourseCard(
                            course: course,
                            isCurrent: current,
                            isPast: past,
                            formatTime: formatTime,
                            onTap: () {
                              if (authState is AuthAuthenticated && !past) {
                                Navigator.push(
                                  ctx,
                                  MaterialPageRoute(
                                    builder: (_) => QrGeneratorPage(
                                      course: course,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                        childCount: state.courses.length,
                      ),
                    ),
                  ),
                ],
          ],
        );
      },
    );
  }
}

// ── Carte cours ──────────────────────────────────────────────────────
class _CourseCard extends StatelessWidget {
  final Course course;
  final bool isCurrent;
  final bool isPast;
  final String Function(DateTime) formatTime;
  final VoidCallback onTap;

  const _CourseCard({
    required this.course,
    required this.isCurrent,
    required this.isPast,
    required this.formatTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isCurrent ? ISPMColors.black : ISPMColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCurrent
                ? ISPMColors.green
                : const Color(0xFFEAEAE4),
            width: isCurrent ? 1.5 : 1,
          ),
          boxShadow: isCurrent
              ? [
            BoxShadow(
              color: ISPMColors.green.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 6),
            )
          ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              // Indicateur heure gauche
              Column(
                children: [
                  Text(
                    formatTime(course.startTime),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isCurrent
                          ? ISPMColors.green
                          : isPast
                          ? ISPMColors.grey400
                          : ISPMColors.black,
                    ),
                  ),
                  Container(
                    width: 1.5,
                    height: 24,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isCurrent
                        ? ISPMColors.green.withOpacity(0.4)
                        : ISPMColors.grey200,
                  ),
                  Text(
                    formatTime(course.endTime),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: isCurrent
                          ? ISPMColors.white.withOpacity(0.5)
                          : ISPMColors.grey400,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Contenu cours
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isCurrent)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: ISPMColors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'EN COURS',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: ISPMColors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    Text(
                      course.title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isCurrent
                            ? ISPMColors.white
                            : isPast
                            ? ISPMColors.grey400
                            : ISPMColors.black,
                        decoration: isPast
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: 13,
                          color: isCurrent
                              ? ISPMColors.white.withOpacity(0.5)
                              : ISPMColors.grey400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course.fieldOfStudy,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: isCurrent
                                ? ISPMColors.white.withOpacity(0.5)
                                : ISPMColors.grey400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Flèche QR
              if (!isPast)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? ISPMColors.green.withOpacity(0.2)
                        : ISPMColors.greenSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.qr_code_rounded,
                    size: 20,
                    color: isCurrent ? ISPMColors.green : ISPMColors.greenDark,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Onglet profil ────────────────────────────────────────────────────
class _ProfileTab extends StatelessWidget {
  final String userName;
  final AuthState authState;
  final VoidCallback onLogout;

  const _ProfileTab({
    required this.userName,
    required this.authState,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final userEmail = authState is AuthAuthenticated
        ? (authState as AuthAuthenticated).user.email
        : '';
    final userRole = authState is AuthAuthenticated
        ? (authState as AuthAuthenticated).user.role
        : '';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mon profil',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: ISPMColors.black,
              ),
            ),
            const SizedBox(height: 24),
            // Carte profil
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ISPMColors.black, ISPMColors.grey800],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: ISPMColors.green,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: ISPMColors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: ISPMColors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          userEmail,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: ISPMColors.white.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: ISPMColors.green.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: ISPMColors.green.withOpacity(0.4)),
                          ),
                          child: Text(
                            userRole == 'INVIGILATOR'
                                ? 'Surveillant'
                                : 'Professeur',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: ISPMColors.greenLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Options
            _ProfileSection(title: 'Compte'),
            _ProfileTile(
              icon: Icons.lock_outline_rounded,
              label: 'Changer le mot de passe',
              onTap: () {
                if (authState is AuthAuthenticated) {
                  Navigator.of(context).pushNamed(
                    '/change-password',
                    arguments: (authState as AuthAuthenticated).user,
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            _ProfileSection(title: 'Application'),
            _ProfileTile(
              icon: Icons.info_outline_rounded,
              label: 'À propos de l\'application',
              trailing: Text('v1.0.0',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: ISPMColors.grey400)),
              onTap: null,
            ),
            const SizedBox(height: 28),
            // Bouton déconnexion
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout_rounded,
                    size: 18, color: ISPMColors.error),
                label: const Text(
                  'Se déconnecter',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ISPMColors.error,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  side: const BorderSide(color: ISPMColors.error, width: 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  const _ProfileSection({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: ISPMColors.grey400,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        color: ISPMColors.white,
        borderRadius: BorderRadius.circular(14),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFEAEAE4)),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: ISPMColors.grey100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: ISPMColors.grey600),
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ISPMColors.black,
          ),
        ),
        trailing: trailing ??
            (onTap != null
                ? const Icon(Icons.chevron_right_rounded,
                color: ISPMColors.grey400)
                : null),
      ),
    );
  }
}

// ── Bottom navigation bar ISPM ──────────────────────────────────────
class _ISPMBottomNav extends StatelessWidget {
  final int selectedIndex;
  final bool isInvigilator;
  final void Function(int) onTap;

  const _ISPMBottomNav({
    required this.selectedIndex,
    required this.isInvigilator,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ISPMColors.white,
        border: const Border(top: BorderSide(color: Color(0xFFEAEAE4))),
        boxShadow: [
          BoxShadow(
            color: ISPMColors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: isInvigilator
              ? Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.calendar_today_rounded,
                  label: 'Planning',
                  selected: selectedIndex == 0,
                  onTap: () => onTap(0),
                ),
              ),
              // Bouton scanner central surélevé
              GestureDetector(
                onTap: () => onTap(1),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: ISPMColors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ISPMColors.green.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: ISPMColors.white,
                    size: 26,
                  ),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profil',
                  selected: selectedIndex == 1,
                  onTap: () => onTap(2),
                ),
              ),
            ],
          )
              : Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.calendar_today_rounded,
                  label: 'Planning',
                  selected: selectedIndex == 0,
                  onTap: () => onTap(0),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profil',
                  selected: selectedIndex == 1,
                  onTap: () => onTap(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? ISPMColors.greenSoft : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 22,
              color: selected ? ISPMColors.green : ISPMColors.grey400,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? ISPMColors.green : ISPMColors.grey400,
            ),
          ),
        ],
      ),
    );
  }
}

// ── États vides / erreur ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ISPMColors.greenSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_available_rounded,
                size: 36,
                color: ISPMColors.green,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aucun cours aujourd\'hui',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: ISPMColors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Votre emploi du temps est libre.\nProfitez de cette journée !',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: ISPMColors.grey400,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: ISPMColors.errorSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 36,
                color: ISPMColors.error,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Connexion impossible',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: ISPMColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: ISPMColors.grey400,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                minimumSize: const Size(0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
