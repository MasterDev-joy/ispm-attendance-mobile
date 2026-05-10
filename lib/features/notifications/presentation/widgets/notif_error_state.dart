// lib/features/notifications/presentation/widgets/notif_error_state.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NotifErrorState extends StatelessWidget {
  final String message;
  final Color accent;
  final VoidCallback onRetry;

  const NotifErrorState({
    super.key,
    required this.message,
    required this.accent,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: ISPMColors.error.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ISPMColors.error.withOpacity(0.28)),
          ),
          child: const Icon(Icons.wifi_off_rounded,
              size: 28, color: ISPMColors.error),
        ),
        const SizedBox(height: 18),
        const Text('Impossible de charger',
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 16,
                fontWeight: FontWeight.w600, color: ISPMColors.white)),
        const SizedBox(height: 8),
        Text(message,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 12,
                color: ISPMColors.white.withOpacity(0.38), height: 1.5)),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: onRetry,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.13),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accent.withOpacity(0.35)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.refresh_rounded, size: 15, color: accent),
              const SizedBox(width: 8),
              Text('Réessayer',
                  style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 13,
                      fontWeight: FontWeight.w600, color: accent)),
            ]),
          ),
        ),
      ]),
    ));
  }
}
