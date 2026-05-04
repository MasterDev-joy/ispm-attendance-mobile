import 'package:flutter/material.dart';

class IspmGlowBlob extends StatelessWidget {
  final double width;
  final double height;
  final Color primaryColor;
  final Color secondaryColor;

  const IspmGlowBlob({
    super.key,
    required this.width,
    required this.height,
    required this.primaryColor,
    this.secondaryColor = Colors.transparent,
  });

  // Un constructeur "factory" pratique si tu préfères utiliser un rayon (comme dans LoginPage)
  factory IspmGlowBlob.circle({
    Key? key,
    required double radius,
    required Color primaryColor,
    Color secondaryColor = Colors.transparent,
  }) {
    return IspmGlowBlob(
      key: key,
      width: radius * 2,
      height: radius * 2,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [primaryColor, secondaryColor],
        ),
      ),
    );
  }
}