// lib/features/attendance/presentation/pages/qr_generator_page.dart
//
// Page QR de présence — Professeur uniquement.
// Génère un QR rotatif (refresh toutes les 14s) via QrBloc (freezed).
//
// ⚠️  CORRECTION : add() retourne void → on ne peut pas stocker sa valeur.
//     La donnée QR est lue depuis le state via BlocListener/BlocBuilder.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import '../../../schedule/domain/entities/course.dart';
import '../../presentation/blocs/qr_bloc.dart';

const _kQrDuration = 14;

class QrGeneratorPage extends StatefulWidget {
  final Course course;
  const QrGeneratorPage({super.key, required this.course});

  @override
  State<QrGeneratorPage> createState() => _QrGeneratorPageState();
}

class _QrGeneratorPageState extends State<QrGeneratorPage>
    with TickerProviderStateMixin {
  int _secondsLeft = _kQrDuration;

  Timer? _refreshTimer;
  Timer? _countdownTimer;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.975,
      end: 1.025,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    // Premier chargement
    _dispatchGenerate();

    // Refresh automatique toutes les _kQrDuration secondes
    _refreshTimer = Timer.periodic(const Duration(seconds: _kQrDuration), (_) {
      _dispatchGenerate();
      setState(() => _secondsLeft = _kQrDuration);
    });

    // Compte à rebours
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _secondsLeft > 0) setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _countdownTimer?.cancel();
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  // ── Dispatch l'event — add() retourne void, on ne stocke rien ────────────
  void _dispatchGenerate() {
    context.read<QrBloc>().add(QrEvent.generate(widget.course.id));
    setState(() => _secondsLeft = _kQrDuration);
  }

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Color _countdownColor(int secondsLeft) {
    if (secondsLeft <= 3) return ISPMColors.error;
    if (secondsLeft <= 7) return const Color(0xFFF57C00);
    return ISPMColors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ISPMColors.black,
      // ── BlocListener : réagit aux changements d'état ───────────────────
      body: BlocListener<QrBloc, QrState>(
        listener: (context, state) {
          state.whenOrNull(
            // Payload reçu → on lance l'animation d'apparition
            success: (_) {
              _fadeCtrl.reset();
              _fadeCtrl.forward();
            },
          );
        },
        child: Stack(
          children: [
            Positioned(
              top: -100,
              left: -80,
              child: IspmGlowBlob.circle(
                radius: 220,
                primaryColor: ISPMColors.greenDark.withOpacity(0.10),
                secondaryColor: Colors.transparent,
              ),
            ),
            Positioned(
              bottom: -80,
              right: -60,
              child: IspmGlowBlob.circle(
                radius: 160,
                primaryColor: ISPMColors.greenDark.withOpacity(0.07),
                secondaryColor: Colors.transparent,
              ),
            ),
            const Positioned.fill(child: IspmMeshGrid()),

            SafeArea(
              child: Column(
                children: [
                  _AppBar(
                    onBack: () => context.pop(),
                    onRefresh: _dispatchGenerate,
                  ),
                  const SizedBox(height: 16),
                  _CourseInfoCard(course: widget.course, fmt: _fmt),

                  // ── BlocBuilder : construit le QR selon l'état ─────────
                  Expanded(
                    child: BlocBuilder<QrBloc, QrState>(
                      builder: (context, state) => state.when(
                        initial: () => const SizedBox.shrink(),
                        loading: () => _buildLoading(),
                        success: (payload) => _buildQr(payload),
                        error: (message) => _buildError(message),
                      ),
                    ),
                  ),

                  // Footer compte à rebours — visible seulement si QR affiché
                  BlocBuilder<QrBloc, QrState>(
                    builder: (context, state) {
                      final isLoaded =
                          state.whenOrNull(success: (_) => true) ?? false;
                      if (!isLoaded) return const SizedBox.shrink();
                      return _CountdownFooter(
                        secondsLeft: _secondsLeft,
                        totalSeconds: _kQrDuration,
                        color: _countdownColor(_secondsLeft),
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Widgets d'état ────────────────────────────────────────────────────────

  Widget _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            color: ISPMColors.green,
            strokeWidth: 2.5,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Génération du code…',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: ISPMColors.white.withOpacity(0.45),
          ),
        ),
      ],
    );
  }

  Widget _buildError(String message) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: ISPMColors.error.withOpacity(0.10),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: ISPMColors.error.withOpacity(0.30)),
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              size: 32,
              color: ISPMColors.error,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Impossible de générer le code',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ISPMColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message.isNotEmpty
                ? message
                : 'Vérifiez votre connexion au réseau ISPM.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: ISPMColors.white.withOpacity(0.40),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _dispatchGenerate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: ISPMColors.green.withOpacity(0.13),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ISPMColors.green.withOpacity(0.35)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    size: 16,
                    color: ISPMColors.green,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Réessayer',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: ISPMColors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQr(String payload) {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _pulseAnim,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ISPMColors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: ISPMColors.green.withOpacity(0.25),
                  blurRadius: 55,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImageView(
                  data: payload,
                  version: QrVersions.auto,
                  size: 210,
                  backgroundColor: ISPMColors.white,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: ISPMColors.black,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: ISPMColors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: ISPMColors.green.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 12,
                        color: ISPMColors.green,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Code sécurisé ISPM',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: ISPMColors.greenDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SOUS-WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onRefresh;
  const _AppBar({required this.onBack, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _NavBtn(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
          const Expanded(
            child: Text(
              'Code de présence',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ISPMColors.white,
              ),
            ),
          ),
          _NavBtn(icon: Icons.refresh_rounded, onTap: onRefresh),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: ISPMColors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ISPMColors.white.withOpacity(0.09)),
        ),
        child: Icon(icon, size: 16, color: ISPMColors.white.withOpacity(0.80)),
      ),
    );
  }
}

class _CourseInfoCard extends StatelessWidget {
  final Course course;
  final String Function(DateTime) fmt;
  const _CourseInfoCard({required this.course, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ISPMColors.grey900,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ISPMColors.green.withOpacity(0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: ISPMColors.green.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: ISPMColors.green.withOpacity(0.13),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ISPMColors.green.withOpacity(0.30)),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 20,
                color: ISPMColors.green,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ISPMColors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${course.fieldOfStudy}  ·  ${fmt(course.startTime)} – ${fmt(course.endTime)}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: ISPMColors.white.withOpacity(0.40),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ISPMColors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'EN COURS',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: ISPMColors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountdownFooter extends StatelessWidget {
  final int secondsLeft;
  final int totalSeconds;
  final Color color;
  const _CountdownFooter({
    required this.secondsLeft,
    required this.totalSeconds,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Column(
        children: [
          Text(
            'Présentez ce code au superviseur',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: ISPMColors.white.withOpacity(0.50),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: ISPMColors.grey900,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ISPMColors.white.withOpacity(0.07)),
            ),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, size: 15, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: secondsLeft / totalSeconds,
                      backgroundColor: ISPMColors.white.withOpacity(0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  child: Text('$secondsLeft'),
                ),
                Text(
                  's',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: ISPMColors.white.withOpacity(0.30),
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
