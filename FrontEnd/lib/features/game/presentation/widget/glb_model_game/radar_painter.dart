import 'package:flutter/material.dart';
import 'package:three_js/three_js.dart' as three;

class GlbGameRadar extends StatelessWidget {
  final double playerX;
  final List<three.Mesh> obstacles;
  final List<three.Mesh> collectibles;
  final List<three.Mesh> lasers;

  const GlbGameRadar({
    super.key,
    required this.playerX,
    required this.obstacles,
    required this.collectibles,
    required this.lasers,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      left: 20,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xBB03030c),
          shape: BoxShape.circle,
          border: Border.all(
              color: const Color(0xFF00FF66).withValues(alpha: 0.35),
              width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00FF66).withValues(alpha: 0.15),
              blurRadius: 8,
            ),
          ],
        ),
        child: ClipOval(
          child: CustomPaint(
            painter: RadarPainter(
              playerX: playerX,
              obstacles: obstacles,
              collectibles: collectibles,
              lasers: lasers,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter representing standard 2D top-down circular sweep scan radar
class RadarPainter extends CustomPainter {
  final double playerX;
  final List<three.Mesh> obstacles;
  final List<three.Mesh> collectibles;
  final List<three.Mesh> lasers;

  RadarPainter({
    required this.playerX,
    required this.obstacles,
    required this.collectibles,
    required this.lasers,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height - 12;
    final double radius = size.width / 2;

    final circlePaint = Paint()
      ..color = const Color(0xFF00FF66).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(Offset(cx, cy), radius * 0.4, circlePaint);
    canvas.drawCircle(Offset(cx, cy), radius * 0.75, circlePaint);
    canvas.drawCircle(Offset(cx, cy), radius * 1.1, circlePaint);

    canvas.drawLine(Offset(cx, cy - radius * 1.2), Offset(cx, cy), circlePaint);
    canvas.drawLine(
        Offset(cx - radius * 0.8, cy), Offset(cx + radius * 0.8, cy), circlePaint);

    final scanPaint = Paint()
      ..color = const Color(0xFF00FF66).withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    final Path sweepPath = Path()
      ..moveTo(cx, cy)
      ..relativeLineTo(-radius * 0.8, -radius * 1.0)
      ..arcToPoint(Offset(cx + radius * 0.8, cy - radius * 1.0),
          radius: Radius.circular(radius * 1.2))
      ..close();
    canvas.drawPath(sweepPath, scanPaint);

    final shipPaint = Paint()
      ..color = const Color(0xFF00FFFF)
      ..style = PaintingStyle.fill;
    final Path shipPath = Path()
      ..moveTo(cx, cy - 5)
      ..lineTo(cx - 4, cy + 3)
      ..lineTo(cx + 4, cy + 3)
      ..close();
    canvas.drawPath(shipPath, shipPaint);

    final laserPaint = Paint()
      ..color = const Color(0xFFFFAA00)
      ..style = PaintingStyle.fill;
    for (var laser in lasers) {
      final double zVal = laser.position.z;
      if (zVal < 0.0 && zVal > -320.0) {
        final double ry = cy - ((zVal / -320.0) * (size.height - 24));
        final double rx = cx + ((laser.position.x) / 16.0) * (size.width * 0.4);
        canvas.drawCircle(Offset(rx, ry), 1.5, laserPaint);
      }
    }

    final obsPaint = Paint()
      ..color = const Color(0xFFFF0055)
      ..style = PaintingStyle.fill;
    for (var obs in obstacles) {
      final double zVal = obs.position.z;
      if (zVal < 0.0 && zVal > -320.0) {
        final double ry = cy - ((zVal / -320.0) * (size.height - 24));
        final double rx = cx + ((obs.position.x) / 16.0) * (size.width * 0.4);
        canvas.drawCircle(Offset(rx, ry), 2.5, obsPaint);
      }
    }

    final colPaint = Paint()
      ..color = const Color(0xFF00FF66)
      ..style = PaintingStyle.fill;
    for (var col in collectibles) {
      final double zVal = col.position.z;
      if (zVal < 0.0 && zVal > -320.0) {
        final double ry = cy - ((zVal / -320.0) * (size.height - 24));
        final double rx = cx + ((col.position.x) / 16.0) * (size.width * 0.4);
        canvas.drawCircle(Offset(rx, ry), 2.5, colPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) => true;
}
