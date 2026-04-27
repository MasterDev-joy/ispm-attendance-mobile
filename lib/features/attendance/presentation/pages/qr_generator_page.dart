// lib/features/attendance/presentation/pages/qr_generator_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../schedule/domain/entities/course.dart';
import '../../data/repositories/qr_repository_impl.dart';
import '../../../../core/theme/app_theme.dart';

class QrGeneratorPage extends StatefulWidget {
  final Course course;

  const QrGeneratorPage({
    super.key,
    required this.course,
  });

  @override
  State<QrGeneratorPage> createState() => _QrGeneratorPageState();
}

class _QrGeneratorPageState extends State<QrGeneratorPage>
    with SingleTickerProviderStateMixin {
  String _qrData = '';
  bool _isLoading = true;
  String? _errorMessage;
  late Timer _timer;
  late Timer _countdownTimer;
  int _secondsLeft = 14;

  late final QrRepositoryImpl _qrRepository;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _qrRepository =
        QrRepositoryImpl(secureStorage: const FlutterSecureStorage());

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fetchQrFromServer();

    _timer = Timer.periodic(const Duration(seconds: 14), (_) {
      _fetchQrFromServer();
      setState(() => _secondsLeft = 14);
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          if (_secondsLeft > 0) _secondsLeft--;
        });
      }
    });
  }

  Future<void> _fetchQrFromServer() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final payload = await _qrRepository.fetchQrPayload(widget.course.id);
      if (mounted) {
        setState(() {
          _qrData = payload;
          _isLoading = false;
          _secondsLeft = 14;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _countdownTimer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ISPMColors.black,
      body: Stack(
        children: [
          // Cercle décoratif
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ISPMColors.green.withOpacity(0.06),
              ),
            ),
          ),
          // Contenu principal
          SafeArea(
            child: Column(
              children: [
                // ── App bar custom ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ISPMColors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: ISPMColors.white,
                          ),
                        ),
                      ),
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
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // ── Infos du cours ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ISPMColors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ISPMColors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: ISPMColors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.class_rounded,
                            color: ISPMColors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.course.title,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: ISPMColors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${widget.course.fieldOfStudy} · ${_formatTime(widget.course.startTime)} – ${_formatTime(widget.course.endTime)}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: ISPMColors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── QR Code zone ──
                Expanded(
                  child: Center(
                    child: _isLoading
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: ISPMColors.green,
                          strokeWidth: 2.5,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Génération du code…',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: ISPMColors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    )
                        : _errorMessage != null
                        ? Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              color: ISPMColors.errorSoft,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.wifi_off_rounded,
                              size: 32,
                              color: ISPMColors.error,
                            ),
                          ),
                          const SizedBox(height: 16),
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
                            'Vérifiez votre connexion au réseau ISPM.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: ISPMColors.white.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _fetchQrFromServer,
                            icon: const Icon(Icons.refresh_rounded,
                                size: 18),
                            label: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    )
                        : ScaleTransition(
                      scale: _pulseAnim,
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: ISPMColors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color:
                              ISPMColors.green.withOpacity(0.25),
                              blurRadius: 40,
                              spreadRadius: 0,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: _qrData,
                          version: QrVersions.auto,
                          size: 220,
                          backgroundColor: ISPMColors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Footer : countdown ──
                if (!_isLoading && _errorMessage == null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: Column(
                      children: [
                        Text(
                          'Présentez ce code au surveillant',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: ISPMColors.white.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Barre de progression
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: ISPMColors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: ISPMColors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                size: 16,
                                color: ISPMColors.green,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: _secondsLeft / 14,
                                    backgroundColor:
                                    ISPMColors.white.withOpacity(0.1),
                                    color: _secondsLeft <= 3
                                        ? ISPMColors.error
                                        : ISPMColors.green,
                                    minHeight: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 24,
                                child: Text(
                                  '$_secondsLeft',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _secondsLeft <= 3
                                        ? ISPMColors.error
                                        : ISPMColors.white,
                                  ),
                                ),
                              ),
                              Text(
                                's',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: ISPMColors.white.withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
