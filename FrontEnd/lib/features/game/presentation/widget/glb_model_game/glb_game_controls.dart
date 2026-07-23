import 'package:material_ui/material_ui.dart';

class GlbGameJoystick extends StatelessWidget {
  final double touchXOffset;
  final double touchYOffset;
  final ValueChanged<DragUpdateDetails> onPanUpdate;
  final VoidCallback onPanEnd;

  const GlbGameJoystick({
    super.key,
    required this.touchXOffset,
    required this.touchYOffset,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 24,
      child: GestureDetector(
        onPanUpdate: onPanUpdate,
        onPanEnd: (_) => onPanEnd(),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0x33FFFFFF),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x2200f0ff)),
          ),
          child: Center(
            child: Transform.translate(
              offset: Offset(touchXOffset * 22.0, -touchYOffset * 22.0),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0x8800F0FF),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GlbGameFireButton extends StatelessWidget {
  final bool touchFiring;
  final VoidCallback onPointerDown;
  final VoidCallback onPointerUp;
  final VoidCallback onPointerCancel;

  const GlbGameFireButton({
    super.key,
    required this.touchFiring,
    required this.onPointerDown,
    required this.onPointerUp,
    required this.onPointerCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      right: 24,
      child: Listener(
        onPointerDown: (_) => onPointerDown(),
        onPointerUp: (_) => onPointerUp(),
        onPointerCancel: (_) => onPointerCancel(),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: touchFiring
                ? const Color(0xCCFF0055)
                : const Color(0x33FF0055),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFF0055), width: 1.5),
            boxShadow: [
              if (touchFiring)
                BoxShadow(
                  color: const Color(0xFFFF0055).withValues(alpha: 0.6),
                  blurRadius: 15,
                )
            ],
          ),
          child: const Center(
            child: Icon(Icons.gps_fixed, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}

class GlbGameCrosshair extends StatelessWidget {
  final bool laserOverheated;

  const GlbGameCrosshair({
    super.key,
    required this.laserOverheated,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: IgnorePointer(
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: laserOverheated
                      ? const Color(0x88FF3300)
                      : const Color(0x8800FFFF),
                  width: 1.5),
            ),
            child: Center(
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: laserOverheated
                      ? const Color(0xFFFF3300)
                      : const Color(0xFF00FFFF),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
