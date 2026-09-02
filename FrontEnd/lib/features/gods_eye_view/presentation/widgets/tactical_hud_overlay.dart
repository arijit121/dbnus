import 'dart:async';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:latlong2/latlong.dart';
import 'package:dbnus/shared/ui/atoms/decorations/glass_container.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/sensor_mode.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_bloc.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_event.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_state.dart';

/// Authentic Tactical HUD Overlay matching the GitHub bilawalsidhu/gods-eye-view UI:
/// Title Bar ("GOD'S EYE VIEW // NO PLACE LEFT BEHIND"), Active Style pill,
/// Top-center globe/share actions, Live sync chips, and the unified Command Dock
/// with Visual Presets (1-7), Location Bar with quick city pills, and GEV Voice Mic.
/// Built fully responsive across mobile, tablet, and desktop viewports.
class TacticalHudOverlay extends StatefulWidget {
  final GodsEyeViewState state;
  final GodsEyeViewBloc bloc;
  final VoidCallback onOpenLayers;
  final VoidCallback onOpenVoice;
  final VoidCallback? onOpenMissions;

  const TacticalHudOverlay({
    super.key,
    required this.state,
    required this.bloc,
    required this.onOpenLayers,
    required this.onOpenVoice,
    this.onOpenMissions,
  });

  @override
  State<TacticalHudOverlay> createState() => _TacticalHudOverlayState();
}

class _TacticalHudOverlayState extends State<TacticalHudOverlay> {
  late Timer _clockTimer;
  DateTime _now = DateTime.now().toUtc();
  bool _presetsExpanded = false;
  bool _locationsExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  static const List<Map<String, dynamic>> _quickCities = [
    {'name': 'NEW YORK', 'lat': 40.7128, 'lon': -74.0060, 'zoom': 11.0},
    {'name': 'TOKYO', 'lat': 35.6762, 'lon': 139.6503, 'zoom': 11.0},
    {'name': 'LONDON', 'lat': 51.5074, 'lon': -0.1278, 'zoom': 11.0},
    {'name': 'SAN FRANCISCO', 'lat': 37.7749, 'lon': -122.4194, 'zoom': 11.5},
    {'name': 'DUBAI', 'lat': 25.2048, 'lon': 55.2708, 'zoom': 11.0},
    {'name': 'PARIS', 'lat': 48.8566, 'lon': 2.3522, 'zoom': 11.0},
    {'name': 'SINGAPORE', 'lat': 1.3521, 'lon': 103.8198, 'zoom': 11.5},
    {'name': 'SYDNEY', 'lat': -33.8688, 'lon': 151.2093, 'zoom': 11.0},
  ];

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (mounted) {
        setState(() {
          _now = DateTime.now().toUtc();
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  String _formatZulu(DateTime time) {
    return '${DateFormat('HH:mm:ss').format(time)}.${(time.millisecond ~/ 100)}Z';
  }

  void _onSearchSubmit(String query) {
    if (query.trim().isEmpty) return;
    final clean = query.trim().toUpperCase();
    final match = _quickCities.firstWhere(
      (c) => (c['name'] as String).contains(clean),
      orElse: () => {'name': clean, 'lat': 38.8951, 'lon': -77.0364, 'zoom': 10.0},
    );
    widget.bloc.add(CenterOnLocation(
      LatLng(match['lat'] as double, match['lon'] as double),
      match['zoom'] as double,
      label: match['name'] as String,
    ));
    _searchController.clear();
    setState(() => _locationsExpanded = false);
  }

  @override
  Widget build(BuildContext context) {
    final hudColor = widget.state.sensorMode.hudColor;
    final isCockpit = widget.state.isCockpitMode;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isCompact = screenWidth < 768;
        final isVerySmall = screenWidth < 480;

        return Stack(
          fit: StackFit.expand,
          children: [
            // 0. Intel HUD Military Scope Corners & Reticle (Completely non-blocking in IgnorePointer)
            if (!isCockpit)
              Positioned.fill(
                child: IgnorePointer(
                  child: _buildIntelHudScope(hudColor, isVerySmall),
                ),
              ),

            // 1. Top-Left Floating Title Bar (#title-bar from GitHub)
            Positioned(
              top: 20,
              left: isCompact ? 12 : 24,
              child: _buildFloatingTitleBar(hudColor, isCompact),
            ),

            // 2. Top-Center Actions Navigation Bar (#top-center-actions from GitHub)
            if (!isVerySmall)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: _buildTopCenterActions(hudColor, isCompact),
                ),
              ),

            // 3. Top-Right Style Indicator & UTC Zulu Clock (#style-indicator from GitHub)
            Positioned(
              top: 20,
              right: isCompact ? 12 : 24,
              child: _buildStyleIndicator(hudColor, isCompact),
            ),

            // 4. Floating Location Bar (#location-bar from GitHub)
            if (!isCockpit)
              Positioned(
                bottom: isCompact ? 82 : 88,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isCompact ? screenWidth : 760),
                      child: _buildFloatingLocationBar(hudColor, isCompact),
                    ),
                  ),
                ),
              ),

            // 5. Bottom Command Dock (#control-panel from GitHub)
            if (!isCockpit)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isCompact ? screenWidth : 820),
                      child: _buildFloatingCommandDock(hudColor, isCompact),
                    ),
                  ),
                ),
              ),

            // 6. Floating Voice Analyst Pill (#gev-voice-control from GitHub)
            if (!isCockpit && !isCompact)
              Positioned(
                bottom: 16,
                right: 24,
                child: _buildVoiceControlPill(hudColor),
              ),

            // 7. Telemetry & Coordinates Readout (#cesium-credits from GitHub)
            if (!isCockpit && !isCompact)
              Positioned(
                bottom: 16,
                left: 24,
                child: _buildCoordinatesReadout(hudColor),
              ),
          ],
        );
      },
    );
  }

  /// Authentic NRO/NGA Military Intelligence Scope Overlay (hud.js)
  Widget _buildIntelHudScope(Color hudColor, bool isVerySmall) {
    final lat = widget.state.cameraCenter.latitude;
    final lon = widget.state.cameraCenter.longitude;
    final latStr = '${lat.abs().toStringAsFixed(3)}° ${lat >= 0 ? "N" : "S"}';
    final lonStr = '${lon.abs().toStringAsFixed(3)}° ${lon >= 0 ? "E" : "W"}';

    return Stack(
      fit: StackFit.expand,
      children: [
        // Center crosshair reticle
        Center(
          child: _buildCenterReticle(hudColor, isVerySmall ? 120 : 180),
        ),

        // Corner Top-Left: ┌ TOP SECRET // SI-TK // NOFORN
        Positioned(
          top: 14,
          left: 14,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('┌', style: TextStyle(color: hudColor.withValues(alpha: 0.7), fontSize: 24, fontFamily: 'monospace')),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TOP SECRET // SI-TK // NOFORN', style: TextStyle(color: hudColor.withValues(alpha: 0.65), fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  Text('KH11-4128  OPS-4152', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 8, fontFamily: 'monospace')),
                ],
              ),
            ],
          ),
        ),

        // Corner Top-Right: ┐ ORB: 47821  PASS: DESC-142
        Positioned(
          top: 14,
          right: 14,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('ORB: 47821  PASS: DESC-142', style: TextStyle(color: hudColor.withValues(alpha: 0.65), fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  Text('BAND: PAN // LVL: 1A', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 8, fontFamily: 'monospace')),
                ],
              ),
              const SizedBox(width: 4),
              Text('┐', style: TextStyle(color: hudColor.withValues(alpha: 0.7), fontSize: 24, fontFamily: 'monospace')),
            ],
          ),
        ),

        // Corner Bottom-Left: └ MGRS
        Positioned(
          bottom: 14,
          left: 14,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('└', style: TextStyle(color: hudColor.withValues(alpha: 0.7), fontSize: 24, fontFamily: 'monospace')),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MGRS: 37U DA 12345 67890', style: TextStyle(color: hudColor.withValues(alpha: 0.65), fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  Text('$latStr  $lonStr', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 8, fontFamily: 'monospace')),
                ],
              ),
            ],
          ),
        ),

        // Corner Bottom-Right: ┘ SENSOR METRICS
        Positioned(
          bottom: 14,
          right: 14,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('GSD: 0.15M  NIIRS: 8.5', style: TextStyle(color: hudColor.withValues(alpha: 0.65), fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  Text('ALT: 420KM  SUN: 42° EL', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 8, fontFamily: 'monospace')),
                ],
              ),
              const SizedBox(width: 4),
              Text('┘', style: TextStyle(color: hudColor.withValues(alpha: 0.7), fontSize: 24, fontFamily: 'monospace')),
            ],
          ),
        ),
      ],
    );
  }

  /// Floating Title Bar (#title-bar in GitHub)
  Widget _buildFloatingTitleBar(Color hudColor, bool isCompact) {
    return GlassContainer(
      blur: 24,
      borderRadius: 14,
      color: const Color(0xFF0C0C14).withValues(alpha: 0.82),
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 12 : 16, vertical: 10),
      child: InkWell(
        onTap: () => widget.bloc.add(const ResetGlobe()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hudColor,
                    boxShadow: [
                      BoxShadow(color: hudColor.withValues(alpha: 0.8), blurRadius: 10, spreadRadius: 2),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "GOD'S EYE ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isCompact ? 13 : 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          letterSpacing: 2.0,
                        ),
                      ),
                      TextSpan(
                        text: "VIEW",
                        style: TextStyle(
                          color: hudColor,
                          fontSize: isCompact ? 13 : 16,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(color: hudColor.withValues(alpha: 0.8), blurRadius: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              '// NO PLACE LEFT BEHIND',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 8.5,
                fontFamily: 'monospace',
                letterSpacing: 3.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Floating Top-Center Actions Navigation Bar (#top-center-actions in GitHub)
  Widget _buildTopCenterActions(Color hudColor, bool isCompact) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassContainer(
          blur: 24,
          borderRadius: 999,
          color: const Color(0xFF0C0C14).withValues(alpha: 0.82),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCircleIconButton(
                icon: Icons.layers_clear,
                tooltip: 'Clear Selected Layers',
                hudColor: hudColor,
                onTap: () {
                  for (final l in GeointLayer.values) {
                    if (widget.state.activeLayers.contains(l)) {
                      widget.bloc.add(ToggleLayer(l));
                    }
                  }
                },
              ),
              const SizedBox(width: 6),
              _buildCircleIconButton(
                icon: Icons.share,
                tooltip: 'Copy Share Link',
                hudColor: hudColor,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF0C0C14),
                      content: Text(
                        'COPIED VIEW LINK: 25.000N 45.000E // ZM: ${widget.state.cameraZoom.toStringAsFixed(1)}',
                        style: TextStyle(color: hudColor, fontFamily: 'monospace'),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(width: 6),
              _buildCircleIconButton(
                icon: Icons.public,
                tooltip: 'Reset Globe View',
                hudColor: hudColor,
                onTap: () => widget.bloc.add(const ResetGlobe()),
              ),
              if (widget.onOpenMissions != null) ...[
                const SizedBox(width: 6),
                _buildCircleIconButton(
                  icon: Icons.rocket_launch,
                  tooltip: 'Mission Control',
                  hudColor: const Color(0xFFFF9100),
                  onTap: widget.onOpenMissions!,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF030A12).withValues(alpha: 0.80),
            border: Border.all(color: hudColor.withValues(alpha: 0.25), width: 0.8),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(shape: BoxShape.circle, color: hudColor),
              ),
              const SizedBox(width: 6),
              Text(
                'LIVE DATA // INTEL: ${widget.state.intelligenceSummary}',
                style: TextStyle(
                  color: hudColor.withValues(alpha: 0.9),
                  fontSize: 8,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Floating Style Indicator & Digital Clock (#style-indicator in GitHub)
  Widget _buildStyleIndicator(Color hudColor, bool isCompact) {
    return GlassContainer(
      blur: 24,
      borderRadius: 14,
      color: const Color(0xFF0C0C14).withValues(alpha: 0.82),
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 10 : 14, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ACTIVE STYLE: ',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 8.5,
                  fontFamily: 'monospace',
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                '${widget.state.sensorMode.displayName} [${widget.state.sensorMode.keyNumber}]',
                style: TextStyle(
                  color: hudColor,
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(color: hudColor.withValues(alpha: 0.6), blurRadius: 8),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF00E676)),
              ),
              const SizedBox(width: 5),
              Text(
                'REC  ${_formatZulu(_now)}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 9,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${widget.state.totalActiveContacts} TARGETS',
                style: TextStyle(
                  color: hudColor,
                  fontSize: 8.5,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Floating Voice Analyst Pill (#gev-voice-control in GitHub)
  Widget _buildVoiceControlPill(Color hudColor) {
    return GlassContainer(
      blur: 24,
      borderRadius: 999,
      color: const Color(0xFF0C0C14).withValues(alpha: 0.88),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: InkWell(
        onTap: widget.onOpenVoice,
        borderRadius: BorderRadius.circular(999),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hudColor.withValues(alpha: 0.15),
                border: Border.all(color: hudColor.withValues(alpha: 0.5)),
              ),
              child: Icon(Icons.mic, size: 14, color: hudColor),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AI RECON ANALYST',
                  style: TextStyle(
                    color: hudColor,
                    fontSize: 8.5,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  'VOICE OPS READY',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 7.5,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Telemetry & Coordinates Readout (#cesium-credits in GitHub)
  Widget _buildCoordinatesReadout(Color hudColor) {
    final lat = widget.state.cameraCenter.latitude;
    final lon = widget.state.cameraCenter.longitude;
    final latStr = '${lat.abs().toStringAsFixed(4)}° ${lat >= 0 ? "N" : "S"}';
    final lonStr = '${lon.abs().toStringAsFixed(4)}° ${lon >= 0 ? "E" : "W"}';

    return GlassContainer(
      blur: 24,
      borderRadius: 8,
      color: const Color(0xFF0C0C14).withValues(alpha: 0.82),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        'GEOINT: $latStr $lonStr | ZM: ${widget.state.cameraZoom.toStringAsFixed(1)} | MGRS: 37U DA 12345 67890',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 8.5,
          fontFamily: 'monospace',
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required String tooltip,
    required Color hudColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Tooltip(
        message: tooltip,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0C0C14).withValues(alpha: 0.8),
            border: Border.all(color: hudColor.withValues(alpha: 0.4), width: 1),
          ),
          child: Icon(icon, size: 16, color: hudColor),
        ),
      ),
    );
  }

  Widget _buildCenterReticle(Color hudColor, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CrosshairPainter(hudColor: hudColor),
      ),
    );
  }

  Widget _buildFloatingLocationBar(Color hudColor, bool isCompact) {
    return GlassContainer(
      blur: 24,
      borderRadius: 12,
      color: const Color(0xFF0C0C14).withValues(alpha: 0.85),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search toggle icon & field
            IconButton(
              icon: Icon(_locationsExpanded ? Icons.close : Icons.search, size: 14, color: hudColor),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => setState(() => _locationsExpanded = !_locationsExpanded),
            ),
            if (_locationsExpanded) ...[
              const SizedBox(width: 8),
              SizedBox(
                width: isCompact ? 140 : 200,
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    hintText: 'Search city...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    border: InputBorder.none,
                  ),
                  onSubmitted: _onSearchSubmit,
                ),
              ),
            ],
            const SizedBox(width: 8),
            Container(width: 1, height: 14, color: Colors.white12),
            const SizedBox(width: 8),
            // Quick city pills
            ..._quickCities.map((city) {
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: InkWell(
                  onTap: () {
                    widget.bloc.add(CenterOnLocation(
                      LatLng(city['lat'] as double, city['lon'] as double),
                      city['zoom'] as double,
                      label: city['name'] as String,
                    ));
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      border: Border.all(color: Colors.white12, width: 0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      city['name'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCommandDock(Color hudColor, bool isCompact) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Presets tray popover if expanded
        if (_presetsExpanded)
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0C0C14).withValues(alpha: 0.94),
              border: Border.all(color: hudColor.withValues(alpha: 0.4), width: 1.0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('MAP SOURCE TILE STACK', style: TextStyle(color: hudColor, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white54, size: 12),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => setState(() => _presetsExpanded = false),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: BasemapType.values.map((base) {
                    final isSel = widget.state.basemap == base;
                    return ChoiceChip(
                      label: Text(
                        base.displayName,
                        style: TextStyle(
                          fontSize: 8.5,
                          fontFamily: 'monospace',
                          color: isSel ? Colors.black : Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selected: isSel,
                      selectedColor: hudColor,
                      backgroundColor: Colors.white.withValues(alpha: 0.06),
                      onSelected: (_) => widget.bloc.add(ChangeBasemap(base)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

        // Main command dock
        GlassContainer(
          blur: 24,
          borderRadius: 12,
          color: const Color(0xFF0C0C14).withValues(alpha: 0.88),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 7 Visual Presets (1-7) directly accessible!
                ...SensorMode.values.map((mode) {
                  final isSelected = widget.state.sensorMode == mode;
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: InkWell(
                      onTap: () => widget.bloc.add(ChangeSensorMode(mode)),
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? mode.hudColor.withValues(alpha: 0.22)
                              : Colors.white.withValues(alpha: 0.04),
                          border: Border.all(
                            color: isSelected ? mode.hudColor : Colors.white12,
                            width: isSelected ? 1.2 : 0.7,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(mode.displayName, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 9, fontFamily: 'monospace', fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)),
                              child: Text('${mode.keyNumber}', style: TextStyle(color: mode.hudColor, fontSize: 7.5, fontFamily: 'monospace')),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                Container(width: 1, height: 16, color: Colors.white12, margin: const EdgeInsets.symmetric(horizontal: 4)),

                // Basemap toggle
                _buildDockButton(
                  icon: Icons.map_outlined,
                  label: 'MAP',
                  isActive: _presetsExpanded,
                  hudColor: hudColor,
                  onTap: () => setState(() => _presetsExpanded = !_presetsExpanded),
                ),

                const SizedBox(width: 5),

                // Cockpit chase button
                if (widget.state.selectedContact is FlightContact) ...[
                  InkWell(
                    onTap: () => widget.bloc.add(const ToggleCockpitMode(true)),
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5252).withValues(alpha: 0.2),
                        border: Border.all(color: const Color(0xFFFF5252), width: 1.0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flight_takeoff, color: Color(0xFFFF5252), size: 12),
                          SizedBox(width: 3),
                          Text('COCKPIT', style: TextStyle(color: Color(0xFFFF5252), fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                ],

                // Full drawer layers toggle
                _buildDockButton(
                  icon: Icons.layers,
                  label: 'LAYERS',
                  isActive: false,
                  hudColor: hudColor,
                  onTap: widget.onOpenLayers,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildDockButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color hudColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? hudColor.withValues(alpha: 0.2) : Colors.transparent,
          border: Border.all(
            color: isActive ? hudColor : Colors.white24,
            width: isActive ? 1.2 : 0.8,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: isActive ? hudColor : Colors.white70),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: isActive ? hudColor : Colors.white70,
                fontSize: 10,
                fontFamily: 'monospace',
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CrosshairPainter extends CustomPainter {
  final Color hudColor;

  _CrosshairPainter({required this.hudColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = hudColor.withValues(alpha: 0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final radius = size.width * 0.25;

    // Outer circle
    canvas.drawCircle(center, radius, paint);

    // Center dot
    canvas.drawCircle(
      center,
      2.0,
      Paint()..color = hudColor.withValues(alpha: 0.8),
    );

    // Corner tactical brackets
    final arm = size.width * 0.1;
    final offset = size.width * 0.38;

    // Top-Left
    canvas.drawLine(Offset(center.dx - offset, center.dy - offset),
        Offset(center.dx - offset + arm, center.dy - offset), paint);
    canvas.drawLine(Offset(center.dx - offset, center.dy - offset),
        Offset(center.dx - offset, center.dy - offset + arm), paint);

    // Top-Right
    canvas.drawLine(Offset(center.dx + offset, center.dy - offset),
        Offset(center.dx + offset - arm, center.dy - offset), paint);
    canvas.drawLine(Offset(center.dx + offset, center.dy - offset),
        Offset(center.dx + offset, center.dy - offset + arm), paint);

    // Bottom-Left
    canvas.drawLine(Offset(center.dx - offset, center.dy + offset),
        Offset(center.dx - offset + arm, center.dy + offset), paint);
    canvas.drawLine(Offset(center.dx - offset, center.dy + offset),
        Offset(center.dx - offset, center.dy + offset - arm), paint);

    // Bottom-Right
    canvas.drawLine(Offset(center.dx + offset, center.dy + offset),
        Offset(center.dx + offset - arm, center.dy + offset), paint);
    canvas.drawLine(Offset(center.dx + offset, center.dy + offset),
        Offset(center.dx + offset, center.dy + offset - arm), paint);
  }

  @override
  bool shouldRepaint(covariant _CrosshairPainter oldDelegate) {
    return oldDelegate.hudColor != hudColor;
  }
}
