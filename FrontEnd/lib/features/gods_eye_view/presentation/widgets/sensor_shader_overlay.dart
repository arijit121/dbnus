import 'package:material_ui/material_ui.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/sensor_mode.dart';

/// Sensor shader overlay that simulates NVG, FLIR, CRT, Noir, and Snow
/// post-processing over the map and entities.
class SensorShaderOverlay extends StatelessWidget {
  final SensorMode mode;
  final Widget child;

  const SensorShaderOverlay({
    super.key,
    required this.mode,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (mode == SensorMode.normal) {
      return child;
    }

    Widget content = child;

    switch (mode) {
      case SensorMode.nvg:
        // Night Vision: Green phosphor matrix + scanline grid & vignette
        content = ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.1, 0.4, 0.1, 0.0, 0.0, // R
            0.3, 1.6, 0.3, 0.0, 30.0, // G (Boost phosphor green)
            0.1, 0.3, 0.1, 0.0, 0.0, // B
            0.0, 0.0, 0.0, 1.0, 0.0, // A
          ]),
          child: content,
        );
        break;

      case SensorMode.flir:
        // Thermal Ironbow: False-color thermal simulation
        content = ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            1.8, 0.2, -0.4, 0.0, 40.0, // High hot red
            -0.2, 1.2, 0.8, 0.0, 10.0, // Amber / Mid
            -0.5, -0.3, 1.9, 0.0, 20.0, // Cold deep blue
            0.0, 0.0, 0.0, 1.0, 0.0,
          ]),
          child: content,
        );
        break;

      case SensorMode.crt:
        // Retro phosphor surveillance CRT monitor
        content = ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.2, 0.6, 0.2, 0.0, 10.0,
            0.3, 1.4, 0.3, 0.0, 25.0,
            0.1, 0.4, 0.2, 0.0, 5.0,
            0.0, 0.0, 0.0, 1.0, 0.0,
          ]),
          child: content,
        );
        break;

      case SensorMode.anime:
        // Cyberpunk neon anime aesthetic (from GitHub style preset 5)
        content = ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            1.5, -0.1, 0.2, 0.0, 25.0,
            -0.1, 1.4, -0.1, 0.0, 15.0,
            0.2, -0.2, 1.8, 0.0, 40.0,
            0.0, 0.0, 0.0, 1.0, 0.0,
          ]),
          child: content,
        );
        break;

      case SensorMode.noir:
        // Monochrome high-contrast black & white surveillance
        content = ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.33, 0.33, 0.33, 0.0, 0.0,
            0.33, 0.33, 0.33, 0.0, 0.0,
            0.33, 0.33, 0.33, 0.0, 0.0,
            0.0, 0.0, 0.0, 1.0, 0.0,
          ]),
          child: content,
        );
        break;

      case SensorMode.snow:
        // Inverted IR / Frost look
        content = ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            -0.8, 0.0, 0.0, 0.0, 240.0,
            0.0, -0.8, 0.0, 0.0, 240.0,
            0.0, 0.0, -0.5, 0.0, 255.0,
            0.0, 0.0, 0.0, 1.0, 0.0,
          ]),
          child: content,
        );
        break;

      case SensorMode.normal:
        break;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        content,
        // Scanlines and vignette layer
        IgnorePointer(
          child: CustomPaint(
            painter: _ScanlineVignettePainter(mode: mode),
          ),
        ),
      ],
    );
  }
}

class _ScanlineVignettePainter extends CustomPainter {
  final SensorMode mode;

  _ScanlineVignettePainter({required this.mode});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. CRT or NVG Scanlines
    if (mode == SensorMode.crt || mode == SensorMode.nvg) {
      final linePaint = Paint()
        ..color = (mode == SensorMode.nvg
                ? const Color(0xFF00FF00)
                : const Color(0xFF00FF66))
            .withValues(alpha: 0.06)
        ..strokeWidth = 1.0;

      const step = 4.0;
      for (double y = 0; y < size.height; y += step) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
      }
    }

    // 2. Heavy Vignette at outer corners (like cockpit optics or spy sensor barrel)
    final vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.85,
      colors: [
        Colors.transparent,
        Colors.black.withValues(alpha: mode == SensorMode.crt ? 0.75 : 0.45),
      ],
      stops: const [0.55, 1.0],
    );

    final vignettePaint = Paint()
      ..shader = vignetteGradient.createShader(rect);

    canvas.drawRect(rect, vignettePaint);

    // 3. Sensor Watermark Stamp (bottom-left)
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'SENSOR: ${mode.shortCode} // REALTIME GEOINT FEED',
        style: TextStyle(
          color: mode.hudColor.withValues(alpha: 0.45),
          fontSize: 10,
          fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, Offset(24, size.height - 32));
  }

  @override
  bool shouldRepaint(covariant _ScanlineVignettePainter oldDelegate) {
    return oldDelegate.mode != mode;
  }
}
