// lib/features/attendance/presentation/pages/attendance_scanner_page.dart
//
// Page Scanner QR — Superviseur uniquement.
// Scanne le QR affiché par le professeur et valide via AttendanceBloc.
// Style dark avec accent bleu superviseur, overlay amélioré.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../blocs/attendance_bloc.dart';
import 'validation_success_page.dart';

const _kBlue = Color(0xFF378ADD);

class AttendanceScannerPage extends StatefulWidget {
  const AttendanceScannerPage({super.key});

  @override
  State<AttendanceScannerPage> createState() => _AttendanceScannerPageState();
}

class _AttendanceScannerPageState extends State<AttendanceScannerPage>
    with TickerProviderStateMixin {
  bool _isProcessing = false;

  // Ligne de scan animée
  late AnimationController _scanLineCtrl;
  late Animation<double> _scanLine;

  // Pulse sur le cadre quand scan en cours
  late AnimationController _processingCtrl;
  late Animation<double> _processingAnim;

  // Entrée fade de la page
  late AnimationController _entryCtrl;
  late Animation<double> _entryAnim;

  final MobileScannerController _cameraCtrl = MobileScannerController();

  @override
  void initState() {
    super.initState();

    _scanLineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scanLine = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scanLineCtrl, curve: Curves.easeInOut));

    _processingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _processingAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _processingCtrl, curve: Curves.easeInOut),
    );

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _entryAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _scanLineCtrl.dispose();
    _processingCtrl.dispose();
    _entryCtrl.dispose();
    _cameraCtrl.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw != null && raw.contains('|')) {
        final parts = raw.split('|');
        if (parts.length == 3) {
          setState(() => _isProcessing = true);
          context.read<AttendanceBloc>().add(
            AttendanceEvent.validateQr(
              token: parts[0],
              professorId: parts[1],
              courseId: parts[2],
            ),
          );
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          // Utilisation du pattern matching de Freezed spécialement pour les listeners
          state.whenOrNull(
            success: (result) {
              // On utilise GoRouter au lieu de Navigator
              // (N'oublie pas de définir cette route dans ton routeur avec le paramètre 'extra')
              context.go('/validation-success', extra: result);
            },
            error: (message) {
              setState(() => _isProcessing = false);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          message, // Directement extrait par Freezed
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: ISPMColors.error,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          );
        },
        builder: (context, state) {
          final isLoading =
              state.maybeWhen(loading: () => true, orElse: () => false) ||
              _isProcessing;

          return Stack(
            children: [
              // ── Caméra plein écran ─────────────────────────────────
              MobileScanner(controller: _cameraCtrl, onDetect: _onDetect),

              // ── Overlay personnalisé ────────────────────────────────
              AnimatedBuilder(
                animation: _scanLine,
                builder: (_, __) => CustomPaint(
                  painter: _ScannerOverlayPainter(
                    scanLineValue: _scanLine.value,
                    isProcessing: isLoading,
                    frameColor: isLoading ? _kBlue : ISPMColors.green,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),

              // ── Blob bleu coin haut ────────────────────────────────
              Positioned(
                top: -60,
                right: -60,
                child: IspmGlowBlob.circle(
                  radius: 160,
                  primaryColor: _kBlue.withOpacity(0.12),
                  secondaryColor: Colors.transparent,
                ),
              ),

              // ── UI SafeArea ────────────────────────────────────────
              SafeArea(
                child: FadeTransition(
                  opacity: _entryAnim,
                  child: Column(
                    children: [
                      // AppBar
                      _buildAppBar(),

                      const Spacer(),

                      // Zone cadre centrale — indicateur
                      if (isLoading)
                        _ProcessingIndicator(anim: _processingAnim)
                      else
                        const _ScanHint(),

                      const SizedBox(height: 48),

                      // Footer info rôle
                      _buildFooter(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          // Bouton retour
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Scanner un professeur',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          // Bouton torche
          GestureDetector(
            onTap: () => _cameraCtrl.toggleTorch(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Icon(
                Icons.flashlight_on_rounded,
                size: 18,
                color: Colors.white.withOpacity(0.80),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBlue.withOpacity(0.30)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _kBlue.withOpacity(0.20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              size: 16,
              color: _kBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mode Superviseur',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Validez la présence du professeur',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.45),
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

// ── Hint scan ─────────────────────────────────────────────────────────────────

class _ScanHint extends StatelessWidget {
  const _ScanHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.50),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.qr_code_scanner_rounded,
            size: 16,
            color: ISPMColors.green,
          ),
          SizedBox(width: 8),
          Text(
            'Pointez la caméra vers le QR code',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Indicateur traitement ─────────────────────────────────────────────────────

class _ProcessingIndicator extends StatelessWidget {
  final Animation<double> anim;
  const _ProcessingIndicator({required this.anim});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: anim,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: _kBlue.withOpacity(0.18),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _kBlue.withOpacity(0.40)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(color: _kBlue, strokeWidth: 2.2),
            ),
            SizedBox(width: 12),
            Text(
              'Vérification en cours…',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Painter overlay ───────────────────────────────────────────────────────────

class _ScannerOverlayPainter extends CustomPainter {
  final double scanLineValue;
  final bool isProcessing;
  final Color frameColor;

  const _ScannerOverlayPainter({
    required this.scanLineValue,
    required this.isProcessing,
    required this.frameColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cutoutW = size.width * 0.74;
    final cutoutH = cutoutW;
    final cutoutLeft = (size.width - cutoutW) / 2;
    final cutoutTop = (size.height - cutoutH) / 2 - 24;
    final cutoutRect = Rect.fromLTWH(cutoutLeft, cutoutTop, cutoutW, cutoutH);
    const radius = Radius.circular(22);

    // Fond sombre avec découpe
    final bgPaint = Paint()..color = Colors.black.withOpacity(0.62);
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(cutoutRect, radius))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, bgPaint);

    // Coins animés
    final cornerPaint = Paint()
      ..color = frameColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    const cL = 30.0;

    void _drawCorner(Offset start, Offset end, Offset arc, bool cw) {
      canvas.drawPath(
        Path()
          ..moveTo(start.dx, start.dy)
          ..arcToPoint(arc, radius: radius, clockwise: cw)
          ..lineTo(end.dx, end.dy),
        cornerPaint,
      );
    }

    // Haut-gauche
    _drawCorner(
      Offset(cutoutLeft, cutoutTop + cL),
      Offset(cutoutLeft + cL, cutoutTop),
      Offset(cutoutLeft + cL, cutoutTop),
      true,
    );
    canvas.drawLine(
      Offset(cutoutLeft, cutoutTop + cL),
      Offset(cutoutLeft, cutoutTop + 1),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutoutLeft, cutoutTop),
      Offset(cutoutLeft + cL, cutoutTop),
      cornerPaint,
    );

    // Haut-droit
    canvas.drawLine(
      Offset(cutoutLeft + cutoutW, cutoutTop + cL),
      Offset(cutoutLeft + cutoutW, cutoutTop + 1),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutoutLeft + cutoutW, cutoutTop),
      Offset(cutoutLeft + cutoutW - cL, cutoutTop),
      cornerPaint,
    );

    // Bas-gauche
    canvas.drawLine(
      Offset(cutoutLeft, cutoutTop + cutoutH - cL),
      Offset(cutoutLeft, cutoutTop + cutoutH - 1),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutoutLeft, cutoutTop + cutoutH),
      Offset(cutoutLeft + cL, cutoutTop + cutoutH),
      cornerPaint,
    );

    // Bas-droit
    canvas.drawLine(
      Offset(cutoutLeft + cutoutW, cutoutTop + cutoutH - cL),
      Offset(cutoutLeft + cutoutW, cutoutTop + cutoutH - 1),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutoutLeft + cutoutW, cutoutTop + cutoutH),
      Offset(cutoutLeft + cutoutW - cL, cutoutTop + cutoutH),
      cornerPaint,
    );

    // Ligne de scan (uniquement si pas en traitement)
    if (!isProcessing) {
      final lineY = cutoutTop + cutoutH * scanLineValue;
      final linePaint = Paint()
        ..shader = LinearGradient(
          colors: [
            frameColor.withOpacity(0),
            frameColor.withOpacity(0.90),
            frameColor.withOpacity(0),
          ],
        ).createShader(Rect.fromLTWH(cutoutLeft, lineY, cutoutW, 2))
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(cutoutLeft + 12, lineY),
        Offset(cutoutLeft + cutoutW - 12, lineY),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ScannerOverlayPainter old) =>
      old.scanLineValue != scanLineValue ||
      old.isProcessing != isProcessing ||
      old.frameColor != frameColor;
}
