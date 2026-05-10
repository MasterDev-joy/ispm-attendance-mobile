// lib/features/auth/presentation/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/ispm_animated_logo.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import '../blocs/auth_bloc.dart';
import '../../../../core/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeIn),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _controller.forward().then((_) => _tryNavigate());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Navigation selon l'état freezed ───────────────────────────────────────
  void _tryNavigate() {
    if (!mounted) return;
    final state = context.read<AuthBloc>().state;

    // On attend que l'état soit résolu (pas initial ni loading)
    state.whenOrNull(
      initial: () => null, // pas encore résolu → on attend le BlocListener
      loading: () => null, // en cours → on attend le BlocListener
      authenticated: (_) {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      requiresPasswordChange: (user) {
        Navigator.of(
          context,
        ).pushReplacementNamed('/change-password', arguments: user);
      },
      unauthenticated: () {
        Navigator.of(context).pushReplacementNamed('/login');
      },
      error: (_) {
        Navigator.of(context).pushReplacementNamed('/login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // Le listener réagit quand l'état arrive APRÈS la fin de l'animation
      listener: (context, state) {
        if (_controller.isCompleted) _tryNavigate();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1210),
        body: Stack(
          fit: StackFit.expand,
          children: [
            const _SplashBackground(),
            Center(
              child: _SplashContent(
                fadeAnimation: _fadeAnim,
                scaleAnimation: _scaleAnim,
              ),
            ),
            _SplashLoader(fadeAnimation: _fadeAnim),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BACKGROUND
// ─────────────────────────────────────────────────────────────────────────────

class _SplashBackground extends StatelessWidget {
  const _SplashBackground();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFF0D1210)),
        Center(
          child: IspmGlowBlob(
            width: size.width * 0.85,
            height: size.height * 0.5,
            primaryColor: ISPMColors.greenDark.withOpacity(0.18),
          ),
        ),
        Positioned(
          top: -60,
          left: -40,
          child: IspmGlowBlob(
            width: 220,
            height: 220,
            primaryColor: ISPMColors.green.withOpacity(0.10),
          ),
        ),
        const Positioned.fill(child: IspmMeshGrid()),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTENT
// ─────────────────────────────────────────────────────────────────────────────

class _SplashContent extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  const _SplashContent({
    required this.fadeAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: const IspmAnimatedLogo(size: 160.0, borderThickness: 5.0),
          ),
        ),
        const SizedBox(height: 32),
        FadeTransition(opacity: fadeAnimation, child: const _SplashTitle()),
        const SizedBox(height: 10),
        FadeTransition(opacity: fadeAnimation, child: const _SplashSubtitle()),
      ],
    );
  }
}

class _SplashTitle extends StatelessWidget {
  const _SplashTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'ISPM',
      style: TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: 10,
        fontFamily: 'Poppins',
        height: 1,
      ),
    );
  }
}

class _SplashSubtitle extends StatelessWidget {
  const _SplashSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Gestion des présences',
      style: TextStyle(
        fontSize: 12,
        color: Colors.white.withOpacity(0.5),
        letterSpacing: 2.5,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOADER
// ─────────────────────────────────────────────────────────────────────────────

class _SplashLoader extends StatelessWidget {
  final Animation<double> fadeAnimation;
  const _SplashLoader({required this.fadeAnimation});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 56,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: const Center(
          child: SizedBox(
            width: 48,
            child: LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Colors.transparent,
              color: ISPMColors.green,
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          ),
        ),
      ),
    );
  }
}
