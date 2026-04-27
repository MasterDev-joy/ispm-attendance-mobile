// lib/features/attendance/presentation/pages/attendance_scanner_page.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/attendance_bloc.dart';
import '../blocs/attendance_event.dart';
import '../blocs/attendance_state.dart';
import 'validation_success_page.dart';
import '../../../../core/theme/app_theme.dart';

class AttendanceScannerPage extends StatefulWidget {
  const AttendanceScannerPage({super.key});

  @override
  State<AttendanceScannerPage> createState() => _AttendanceScannerPageState();
}

class _AttendanceScannerPageState extends State<AttendanceScannerPage>
    with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  late AnimationController _scanLineCtrl;
  late Animation<double> _scanLine;

  @override
  void initState() {
    super.initState();
    _scanLineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanLine = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanLineCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceValidationSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ValidationSuccessPage(
                  validationData: state.validationData,
                ),
              ),
            );
          } else if (state is AttendanceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.message,
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
            setState(() => _isProcessing = false);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // ── Caméra plein écran ──
              MobileScanner(
                onDetect: (capture) {
                  if (_isProcessing) return;
                  for (final barcode in capture.barcodes) {
                    final rawValue = barcode.rawValue;
                    if (rawValue != null && rawValue.contains('|')) {
                      setState(() => _isProcessing = true);
                      final parts = rawValue.split('|');
                      if (parts.length == 3) {
                        context.read<AttendanceBloc>().add(
                          ValidateQrEvent(
                            token: parts[0],
                            professorId: parts[1],
                            courseId: parts[2],
                          ),
                        );
                      } else {
                        setState(() => _isProcessing = false);
                      }
                      break;
                    }
                  }
                },
              ),

              // ── Overlay sombre avec découpe ──
              _ScannerOverlay(scanLine: _scanLine),

              // ── UI par-dessus ──
              SafeArea(
                child: Column(
                  children: [
                    // App bar custom
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 16,
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
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Texte bas
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                      child: Column(
                        children: [
                          if (state is AttendanceLoading ||
                              (_isProcessing && state is! AttendanceError)) ...[
                            const SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                color: ISPMColors.green,
                                strokeWidth: 2.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Vérification en cours…',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(24),
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
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Overlay avec cadre de scan et ligne animée ───────────────────────
class _ScannerOverlay extends StatelessWidget {
  final Animation<double> scanLine;
  const _ScannerOverlay({required this.scanLine});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OverlayPainter(scanLine: scanLine),
      child: Container(),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final Animation<double> scanLine;

  _OverlayPainter({required this.scanLine}) : super(repaint: scanLine);

  @override
  void paint(Canvas canvas, Size size) {
    final cutoutSize = size.width * 0.72;
    final cutoutLeft = (size.width - cutoutSize) / 2;
    final cutoutTop = (size.height - cutoutSize) / 2 - 20;
    final cutoutRect = Rect.fromLTWH(
        cutoutLeft, cutoutTop, cutoutSize, cutoutSize);

    // Assombrir le fond
    final bgPaint = Paint()..color = Colors.black.withOpacity(0.6);
    final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final path = Path()
      ..addRect(fullRect)
      ..addRRect(RRect.fromRectAndRadius(
          cutoutRect, const Radius.circular(20)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, bgPaint);

    // Coins du cadre
    final cornerPaint = Paint()
      ..color = ISPMColors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    const cL = 28.0; // longueur des coins
    final r = const Radius.circular(20);

    // Coin haut-gauche
    canvas.drawPath(
      Path()
        ..moveTo(cutoutLeft, cutoutTop + cL)
        ..arcToPoint(Offset(cutoutLeft + cL, cutoutTop),
            radius: r, clockwise: true),
      cornerPaint,
    );
    // Coin haut-droit
    canvas.drawPath(
      Path()
        ..moveTo(cutoutLeft + cutoutSize - cL, cutoutTop)
        ..arcToPoint(Offset(cutoutLeft + cutoutSize, cutoutTop + cL),
            radius: r, clockwise: false),
      cornerPaint,
    );
    // Coin bas-gauche
    canvas.drawPath(
      Path()
        ..moveTo(cutoutLeft, cutoutTop + cutoutSize - cL)
        ..arcToPoint(Offset(cutoutLeft + cL, cutoutTop + cutoutSize),
            radius: r, clockwise: false),
      cornerPaint,
    );
    // Coin bas-droit
    canvas.drawPath(
      Path()
        ..moveTo(cutoutLeft + cutoutSize - cL, cutoutTop + cutoutSize)
        ..arcToPoint(
            Offset(cutoutLeft + cutoutSize, cutoutTop + cutoutSize - cL),
            radius: r,
            clockwise: true),
      cornerPaint,
    );

    // Ligne de scan animée
    final lineY = cutoutTop + cutoutSize * scanLine.value;
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          ISPMColors.green.withOpacity(0),
          ISPMColors.green.withOpacity(0.9),
          ISPMColors.green.withOpacity(0),
        ],
      ).createShader(Rect.fromLTWH(cutoutLeft, lineY, cutoutSize, 2));

    canvas.drawLine(
      Offset(cutoutLeft + 10, lineY),
      Offset(cutoutLeft + cutoutSize - 10, lineY),
      linePaint..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
