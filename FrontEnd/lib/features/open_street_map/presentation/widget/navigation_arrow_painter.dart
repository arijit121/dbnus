import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Custom painter for a Google Maps-style directional navigation arrow.
/// Draws a pointed teardrop/chevron shape indicating travel direction.
class NavigationArrowPainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  NavigationArrowPainter({
    required this.color,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.35;

    // Draw a navigation arrow: pointed top, rounded bottom
    final path = ui.Path();
    // Tip of the arrow (pointing up = forward)
    path.moveTo(cx, cy - r * 1.4);
    // Right curve
    path.quadraticBezierTo(cx + r * 1.1, cy + r * 0.2, cx + r * 0.5, cy + r);
    // Bottom center curve
    path.quadraticBezierTo(cx, cy + r * 0.5, cx - r * 0.5, cy + r);
    // Left curve back to tip
    path.quadraticBezierTo(cx - r * 1.1, cy + r * 0.2, cx, cy - r * 1.4);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    // Inner white dot
    canvas.drawCircle(
      Offset(cx, cy + r * 0.1),
      r * 0.22,
      Paint()..color = borderColor,
    );
  }

  @override
  bool shouldRepaint(covariant NavigationArrowPainter oldDelegate) =>
      color != oldDelegate.color || borderColor != oldDelegate.borderColor;
}
