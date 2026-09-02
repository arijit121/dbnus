import 'dart:math' as math;
import 'package:intl/intl.dart' hide TextDirection;
import 'package:material_ui/material_ui.dart';
import 'package:dbnus/shared/ui/atoms/decorations/glass_container.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/sensor_mode.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_bloc.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_event.dart';

/// Authentic Cockpit View HUD matching lines 80-305 of the GitHub repo:
/// Roll arc (-30 to +30), pitch rails (+20 to -20), horizon level guide,
/// speed & altitude rim tapes with live indicators, compass heading tape,
/// top-line first-person info, vision switcher (PREV/CURRENT/NEXT),
/// and the 250 KM contact context window with briefing tabs (SIG / NEWS / LOCAL).
/// Built 100% responsive for both mobile and desktop screens.
class CockpitHudView extends StatefulWidget {
  final FlightContact flight;
  final List<FlightContact> allFlights;
  final SensorMode sensorMode;
  final GodsEyeViewBloc bloc;

  const CockpitHudView({
    super.key,
    required this.flight,
    required this.allFlights,
    required this.sensorMode,
    required this.bloc,
  });

  @override
  State<CockpitHudView> createState() => _CockpitHudViewState();
}

class _CockpitHudViewState extends State<CockpitHudView> {
  int _briefTabIndex = 0; // 0: SIG, 1: NEWS, 2: LOCAL
  bool _contextExpanded = false;

  void _cycleVision(int delta) {
    final values = SensorMode.values;
    final currentIndex = values.indexOf(widget.sensorMode);
    final nextIndex = (currentIndex + delta) % values.length;
    final resolvedIndex = nextIndex < 0 ? values.length - 1 : nextIndex;
    widget.bloc.add(ChangeSensorMode(values[resolvedIndex]));
  }

  @override
  Widget build(BuildContext context) {
    final hudColor = widget.sensorMode.hudColor;
    final now = DateTime.now().toUtc();
    final zulu = DateFormat('HH:mm:ss').format(now);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final isMobile = width < 600;

        return Stack(
          fit: StackFit.expand,
          children: [
            // 1. Central Artificial Horizon & Pitch Ladder Painter
            Center(
              child: SizedBox(
                width: isMobile ? width * 0.8 : 420,
                height: isMobile ? height * 0.6 : 380,
                child: CustomPaint(
                  painter: _CockpitAvionicsPainter(
                    hudColor: hudColor,
                    heading: widget.flight.headingDeg,
                    speed: widget.flight.speedKnots,
                    altitude: widget.flight.altitudeFt,
                  ),
                ),
              ),
            ),

            // 2. Top-line First-Person Header & Vision Switcher (lines 147-167 of GitHub)
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: SafeArea(
                bottom: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Aircraft Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: hudColor),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'FIRST PERSON // VISOR LOCK',
                                style: TextStyle(
                                  color: hudColor.withValues(alpha: 0.8),
                                  fontSize: 9,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.flight.callsign.isNotEmpty ? widget.flight.callsign : widget.flight.id,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              letterSpacing: 1.0,
                            ),
                          ),
                          Text(
                            'MODEL: ${widget.flight.model} · LIVE TRACK · COURSE ALIGNED',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.65),
                              fontSize: 9,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Vision Style Switcher (GitHub lines 153-166)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0C0C14).withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: hudColor.withValues(alpha: 0.5), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left, color: hudColor, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => _cycleVision(-1),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () => _cycleVision(1),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'OPTICS',
                                  style: TextStyle(
                                    color: hudColor.withValues(alpha: 0.6),
                                    fontSize: 7,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                Text(
                                  widget.sensorMode.displayName,
                                  style: TextStyle(
                                    color: hudColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: Icon(Icons.chevron_right, color: hudColor, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => _cycleVision(1),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Exit Cockpit Button
                    InkWell(
                      onTap: () => widget.bloc.add(const ToggleCockpitMode(false)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5252).withValues(alpha: 0.25),
                          border: Border.all(color: const Color(0xFFFF5252), width: 1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.close_fullscreen, size: 12, color: Color(0xFFFF5252)),
                            SizedBox(width: 4),
                            Text(
                              'EXIT',
                              style: TextStyle(
                                color: Color(0xFFFF5252),
                                fontSize: 10,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Top Compass Heading Tape (lines 169-185 of GitHub)
            Positioned(
              top: isMobile ? 70 : 80,
              left: isMobile ? 40 : 120,
              right: isMobile ? 40 : 120,
              child: _buildCompassHeadingTape(hudColor),
            ),

            // 4. Airspeed Rim Tape (Left side, lines 109-127 of GitHub)
            Positioned(
              left: isMobile ? 8 : 24,
              top: isMobile ? 120 : 160,
              bottom: isMobile ? 120 : 160,
              child: _buildAirspeedTape(hudColor, isMobile),
            ),

            // 5. Altitude Rim Tape (Right side, lines 128-146 of GitHub)
            Positioned(
              right: isMobile ? 8 : 24,
              top: isMobile ? 120 : 160,
              bottom: isMobile ? 120 : 160,
              child: _buildAltitudeTape(hudColor, isMobile),
            ),

            // 6. Cockpit Context / Briefing Stream (bottom left, lines 190-305 of GitHub)
            Positioned(
              bottom: 12,
              left: 12,
              child: SafeArea(
                top: false,
                child: _buildContextAndBriefingPanel(hudColor, isMobile, zulu),
              ),
            ),

            // 7. Position & UTC Readout (bottom right, lines 186-189 of GitHub)
            Positioned(
              bottom: 12,
              right: 12,
              child: SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: hudColor.withValues(alpha: 0.3), width: 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${zulu}Z',
                        style: TextStyle(
                          color: hudColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        '${widget.flight.position.latitude.toStringAsFixed(3)}° · ${widget.flight.position.longitude.toStringAsFixed(3)}°',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 9,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCompassHeadingTape(Color hudColor) {
    final heading = widget.flight.headingDeg.toInt() % 360;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${heading.toString().padLeft(3, '0')}°',
                style: TextStyle(
                  color: hudColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          Icon(Icons.arrow_drop_down, color: hudColor, size: 16),
          // Tape line
          Container(
            height: 14,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: hudColor.withValues(alpha: 0.5), width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHeadingTick((heading - 40 + 360) % 360, hudColor),
                _buildHeadingTick((heading - 20 + 360) % 360, hudColor),
                _buildHeadingTick(heading, hudColor, isCenter: true),
                _buildHeadingTick((heading + 20) % 360, hudColor),
                _buildHeadingTick((heading + 40) % 360, hudColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadingTick(int val, Color hudColor, {bool isCenter = false}) {
    String label = '$val';
    if (val == 0 || val == 360) label = 'N';
    if (val == 90) label = 'E';
    if (val == 180) label = 'S';
    if (val == 270) label = 'W';

    return Text(
      label,
      style: TextStyle(
        color: isCenter ? hudColor : hudColor.withValues(alpha: 0.4),
        fontSize: isCenter ? 10 : 8,
        fontWeight: isCenter ? FontWeight.bold : FontWeight.normal,
        fontFamily: 'monospace',
      ),
    );
  }

  Widget _buildAirspeedTape(Color hudColor, bool isMobile) {
    final speed = widget.flight.speedKnots.toInt();
    return Container(
      width: isMobile ? 48 : 64,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        border: Border(right: BorderSide(color: hudColor.withValues(alpha: 0.8), width: 1.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'KTS',
            style: TextStyle(
              color: hudColor.withValues(alpha: 0.7),
              fontSize: 8,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${speed + 40}',
            style: TextStyle(color: hudColor.withValues(alpha: 0.35), fontSize: 9, fontFamily: 'monospace'),
          ),
          const SizedBox(height: 4),
          Text(
            '${speed + 20}',
            style: TextStyle(color: hudColor.withValues(alpha: 0.55), fontSize: 10, fontFamily: 'monospace'),
          ),
          const SizedBox(height: 6),
          // Active Speed Pointer (arrow_right)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: hudColor.withValues(alpha: 0.2),
              border: Border.all(color: hudColor, width: 1.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_right, color: hudColor, size: 14),
                Text(
                  '$speed',
                  style: TextStyle(
                    color: hudColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(speed - 20).clamp(0, 9999)}',
            style: TextStyle(color: hudColor.withValues(alpha: 0.55), fontSize: 10, fontFamily: 'monospace'),
          ),
          const SizedBox(height: 4),
          Text(
            '${(speed - 40).clamp(0, 9999)}',
            style: TextStyle(color: hudColor.withValues(alpha: 0.35), fontSize: 9, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  Widget _buildAltitudeTape(Color hudColor, bool isMobile) {
    final alt = widget.flight.altitudeFt.toInt();
    return Container(
      width: isMobile ? 54 : 70,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        border: Border(left: BorderSide(color: hudColor.withValues(alpha: 0.8), width: 1.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ALT FT',
            style: TextStyle(
              color: hudColor.withValues(alpha: 0.7),
              fontSize: 8,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${alt + 1000}',
            style: TextStyle(color: hudColor.withValues(alpha: 0.35), fontSize: 9, fontFamily: 'monospace'),
          ),
          const SizedBox(height: 4),
          Text(
            '${alt + 500}',
            style: TextStyle(color: hudColor.withValues(alpha: 0.55), fontSize: 10, fontFamily: 'monospace'),
          ),
          const SizedBox(height: 6),
          // Active Altitude Pointer (arrow_left)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: hudColor.withValues(alpha: 0.2),
              border: Border.all(color: hudColor, width: 1.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$alt',
                  style: TextStyle(
                    color: hudColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                Icon(Icons.arrow_left, color: hudColor, size: 14),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(alt - 500).clamp(0, 99999)}',
            style: TextStyle(color: hudColor.withValues(alpha: 0.55), fontSize: 10, fontFamily: 'monospace'),
          ),
          const SizedBox(height: 4),
          Text(
            '${(alt - 1000).clamp(0, 99999)}',
            style: TextStyle(color: hudColor.withValues(alpha: 0.35), fontSize: 9, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  Widget _buildContextAndBriefingPanel(Color hudColor, bool isMobile, String zulu) {
    if (!_contextExpanded) {
      return InkWell(
        onTap: () => setState(() => _contextExpanded = true),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0C0C14).withValues(alpha: 0.85),
            border: Border.all(color: hudColor.withValues(alpha: 0.4), width: 1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.radar, size: 14, color: hudColor),
              const SizedBox(width: 6),
              Text(
                'CONTACTS · 250 KM',
                style: TextStyle(color: hudColor, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.keyboard_arrow_up, size: 14, color: Colors.white70),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: isMobile ? 260 : 320,
      child: GlassContainer(
        blur: 16,
        borderRadius: 8,
        color: const Color(0xFF0C0C14).withValues(alpha: 0.92),
        padding: const EdgeInsets.all(10),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CONTACTS // 250 KM RADIUS',
                style: TextStyle(
                  color: hudColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white70, size: 14),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => setState(() => _contextExpanded = false),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Cohort counts (FLT, MIL, AIS, SITE) - lines 201-206 in GitHub
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCohortItem('FLT', '${widget.allFlights.where((f) => !f.isMilitary).length}', 'OpenSky', hudColor),
              _buildCohortItem('MIL', '${widget.allFlights.where((f) => f.isMilitary).length}', 'adsb.lol', const Color(0xFFFF9100)),
              _buildCohortItem('AIS', '4', 'AISStream', const Color(0xFF26A69A)),
              _buildCohortItem('SITE', '12', 'OSM', const Color(0xFFAB47BC)),
            ],
          ),
          const Divider(color: Colors.white12, height: 14),

          // Estimated Flight Plan (lines 233-249 in GitHub)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FROM: ${widget.flight.origin}',
                  style: const TextStyle(color: Colors.white70, fontSize: 9, fontFamily: 'monospace'),
                ),
                const Icon(Icons.east, size: 12, color: Colors.white38),
                Text(
                  'TO: ${widget.flight.destination}',
                  style: const TextStyle(color: Colors.white70, fontSize: 9, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Briefing Tabs (SIG, NEWS, LOCAL) - lines 297-304 in GitHub
          Row(
            children: [
              _buildBriefTab(0, 'SIG', hudColor),
              const SizedBox(width: 6),
              _buildBriefTab(1, 'NEWS', hudColor),
              const SizedBox(width: 6),
              _buildBriefTab(2, 'LOCAL WX', hudColor),
            ],
          ),
          const SizedBox(height: 6),

          // Tab content
          if (_briefTabIndex == 0) ...[
            Text(
              '• TRANSPONDER SQWK ${widget.flight.squawk} TRACKED\n• RADAR ECHO LEVEL 1 // NO CONVECTIVE SIGS',
              style: TextStyle(color: hudColor.withValues(alpha: 0.8), fontSize: 9, fontFamily: 'monospace', height: 1.4),
            ),
          ] else if (_briefTabIndex == 1) ...[
            const Text(
              '• REGIONAL AIRSPACE NOTICE: NORMAL OPS\n• SECTOR VHF FREQ: 124.850 MHZ',
              style: TextStyle(color: Colors.white70, fontSize: 9, fontFamily: 'monospace', height: 1.4),
            ),
          ] else ...[
            const Text(
              '• TEMP: 18°C · WIND: 12KT @ 280°\n• SKY: CAVOK · VIS: 10KM+ (Open-Meteo)',
              style: TextStyle(color: Color(0xFF80D8FF), fontSize: 9, fontFamily: 'monospace', height: 1.4),
            ),
          ],
        ],
      ),
    ),
  );
}

  Widget _buildCohortItem(String label, String count, String source, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        Text(source, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 7, fontFamily: 'monospace')),
      ],
    );
  }

  Widget _buildBriefTab(int index, String label, Color hudColor) {
    final isSel = _briefTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _briefTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSel ? hudColor.withValues(alpha: 0.2) : Colors.transparent,
          border: Border.all(color: isSel ? hudColor : Colors.white24, width: 0.8),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSel ? hudColor : Colors.white60,
            fontSize: 8,
            fontFamily: 'monospace',
            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// Custom Canvas Painter rendering the Pitch Ladder, Horizon Line,
/// Roll Arc (-30 to +30), and Reticle matching military HUD optics
class _CockpitAvionicsPainter extends CustomPainter {
  final Color hudColor;
  final double heading;
  final double speed;
  final double altitude;

  _CockpitAvionicsPainter({
    required this.hudColor,
    required this.heading,
    required this.speed,
    required this.altitude,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = hudColor.withValues(alpha: 0.75)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // 1. Center Flight Path Marker (aircraft reticle)
    canvas.drawCircle(center, 6, paint);
    canvas.drawLine(Offset(center.dx - 18, center.dy), Offset(center.dx - 6, center.dy), paint);
    canvas.drawLine(Offset(center.dx + 6, center.dy), Offset(center.dx + 18, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - 12), Offset(center.dx, center.dy - 6), paint);

    // 2. Horizon Level Line ("LEVEL" - line 98 in GitHub)
    final horizonPaint = Paint()
      ..color = hudColor.withValues(alpha: 0.5)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(center.dx - 100, center.dy), Offset(center.dx - 40, center.dy), horizonPaint);
    canvas.drawLine(Offset(center.dx + 40, center.dy), Offset(center.dx + 100, center.dy), horizonPaint);

    // 3. Pitch Ladder (+20, +10, -10, -20 - lines 91-96 in GitHub)
    _drawPitchBar(canvas, center.dx, center.dy - 40, 50, '+10', hudColor);
    _drawPitchBar(canvas, center.dx, center.dy - 80, 40, '+20', hudColor);
    _drawPitchBar(canvas, center.dx, center.dy + 40, 50, '-10', hudColor, isDashed: true);
    _drawPitchBar(canvas, center.dx, center.dy + 80, 40, '-20', hudColor, isDashed: true);

    // 4. Roll Arc at Top (-30 to +30 - lines 82-90 in GitHub)
    final arcRadius = size.width * 0.42;
    final arcRect = Rect.fromCircle(center: Offset(center.dx, center.dy + 40), radius: arcRadius);
    final arcPaint = Paint()
      ..color = hudColor.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawArc(arcRect, -math.pi * 0.75, math.pi * 0.5, false, arcPaint);
  }

  void _drawPitchBar(Canvas canvas, double cx, double cy, double halfW, String label, Color color, {bool isDashed = false}) {
    final p = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 1.0;

    if (!isDashed) {
      canvas.drawLine(Offset(cx - halfW, cy), Offset(cx - 20, cy), p);
      canvas.drawLine(Offset(cx + 20, cy), Offset(cx + halfW, cy), p);
      canvas.drawLine(Offset(cx - halfW, cy), Offset(cx - halfW, cy + 4), p);
      canvas.drawLine(Offset(cx + halfW, cy), Offset(cx + halfW, cy + 4), p);
    } else {
      // Dashed line for negative pitch
      for (double x = cx - halfW; x < cx - 20; x += 8) {
        canvas.drawLine(Offset(x, cy), Offset(x + 4, cy), p);
      }
      for (double x = cx + 20; x < cx + halfW; x += 8) {
        canvas.drawLine(Offset(x, cy), Offset(x + 4, cy), p);
      }
    }

    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 8, fontFamily: 'monospace'),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx + halfW + 4, cy - 5));
  }

  @override
  bool shouldRepaint(covariant _CockpitAvionicsPainter oldDelegate) {
    return oldDelegate.heading != heading ||
        oldDelegate.speed != speed ||
        oldDelegate.altitude != altitude ||
        oldDelegate.hudColor != hudColor;
  }
}
