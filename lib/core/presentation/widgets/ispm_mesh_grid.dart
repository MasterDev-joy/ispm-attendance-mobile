import 'package:flutter/material.dart';

class IspmMeshGrid extends StatelessWidget {
  final double opacity;

  // Opacité par défaut à 0.025
  const IspmMeshGrid({super.key, this.opacity = 0.025});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MeshPainter(opacity: opacity),
      // Prend toute la place disponible
      child: const SizedBox.expand(),
    );
  }
}

class _MeshPainter extends CustomPainter {
  final double opacity;

  _MeshPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..strokeWidth = 0.5;

    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MeshPainter oldDelegate) {
    // Ne redessine que si l'opacité change
    return oldDelegate.opacity != opacity;
  }
}