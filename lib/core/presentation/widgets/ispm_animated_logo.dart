import 'package:flutter/material.dart';
import 'package:zo_animated_border/zo_animated_border.dart';

class IspmAnimatedLogo extends StatelessWidget {
  final double size;
  final double borderThickness;
  final Duration animationDuration;

  const IspmAnimatedLogo({
    super.key,
    this.size = 120.0, // Taille par défaut
    this.borderThickness = 4.0,
    this.animationDuration = const Duration(seconds: 4),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ZoAnimatedGradientBorder(
        // On divise par 2 pour avoir un cercle parfait
        borderRadius: size / 2,
        borderThickness: borderThickness,
        animationDuration: animationDuration,
        // Utilisation des couleurs du thème (Vert ISPM)
        gradientColor: [
          Theme.of(context).colorScheme.primary,
          Colors.white,
          Theme.of(context).colorScheme.primary.withOpacity(0.5),
          Colors.white,
        ],
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white, // Fond blanc derrière le logo
          ),
          child: Padding(
            // Marge pour que le logo respire à l'intérieur de la bordure
            padding: const EdgeInsets.all(6.0),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo_ispm.jpg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}