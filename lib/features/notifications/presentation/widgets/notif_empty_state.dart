// lib/features/notifications/presentation/widgets/notif_empty_state.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NotifEmptyState extends StatelessWidget {
  final Color accent;
  const NotifEmptyState({super.key, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: accent.withOpacity(0.10),
            shape: BoxShape.circle,
            border: Border.all(color: accent.withOpacity(0.25)),
          ),
          child: Icon(Icons.notifications_none_rounded,
              size: 36, color: accent),
        ),
        const SizedBox(height: 20),
        const Text('Tout est à jour',
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 18,
                fontWeight: FontWeight.w700, color: ISPMColors.white)),
        const SizedBox(height: 8),
        Text('Aucune notification pour le moment.',
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 13,
                color: ISPMColors.white.withOpacity(0.40))),
      ],
    ));
  }
}
