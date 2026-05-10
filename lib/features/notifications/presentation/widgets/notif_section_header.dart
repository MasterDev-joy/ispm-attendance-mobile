// lib/features/notifications/presentation/widgets/notif_section_header.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NotifSectionHeader extends StatelessWidget {
  final String label;
  final Color accent;
  final int? badge;

  const NotifSectionHeader({
    super.key,
    required this.label,
    required this.accent,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(label.toUpperCase(),
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 10,
              fontWeight: FontWeight.w600, letterSpacing: 0.8,
              color: ISPMColors.white.withOpacity(0.38))),
      if (badge != null && badge! > 0) ...[
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
              color: accent, borderRadius: BorderRadius.circular(20)),
          child: Text('$badge',
              style: const TextStyle(
                  fontFamily: 'Poppins', fontSize: 10,
                  fontWeight: FontWeight.w700, color: ISPMColors.white)),
        ),
      ],
      const SizedBox(width: 10),
      Expanded(child: Divider(
          color: ISPMColors.white.withOpacity(0.07), thickness: 0.5)),
    ]);
  }
}
