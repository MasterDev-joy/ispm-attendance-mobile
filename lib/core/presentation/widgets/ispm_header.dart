// lib/core/presentation/widgets/ispm_header.dart
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'ispm_animated_logo.dart';

class IspmHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double logoSize;

  const IspmHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.logoSize = 130,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        IspmAnimatedLogo(size: 130, borderThickness: 5),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: ISPMColors.white,
            letterSpacing: -0.3,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: ISPMColors.white.withOpacity(0.45),
              fontSize: 13,
            ),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}