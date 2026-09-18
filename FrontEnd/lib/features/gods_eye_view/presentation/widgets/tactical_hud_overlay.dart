import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:dbnus/shared/ui/atoms/decorations/glass_container.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/sensor_mode.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_bloc.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_event.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_state.dart';

/// Authentic Dark Sci-Fi UI matching bilawalsidhu/gods-eye-view ("Apple meets Blade Runner"):
/// - Borderless floating #title-bar with cyan radial ambient glow & wide letter tracking
/// - Borderless #style-indicator with glowing cyan value & Zulu clock
/// - Circular #top-center-actions (36x36 glass round buttons) & #global-loading-status pill
/// - Unified 3-segment bottom #command-dock (LOCATION bar | elevated AI RECON ANALYST | VISUAL PRESETS 1-7)
/// - Left floating DATA LAYERS pill
/// - Completely clean, unobstructed globe view with minimal perimeter framing brackets
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
      orElse: () =>
          {'name': clean, 'lat': 38.8951, 'lon': -77.0364, 'zoom': 10.0},
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
        final hudTop = isCompact ? 34.0 : 40.0;
        final tourTop = isVerySmall ? 82.0 : 96.0;

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildClassificationRail(hudColor, isCompact),
            ),

            // 0. Minimal Tactical Scope Corners (Non-obtrusive framing brackets)
            if (!isCockpit)
              Positioned.fill(
                child: IgnorePointer(
                  child: _buildIntelHudScope(hudColor, isVerySmall),
                ),
              ),

            // 1. Top-Left Floating Title Bar (#title-bar: transparent typography with radial cyan glow)
            Positioned(
              top: hudTop,
              left: isCompact ? 16 : 36,
              child: _buildFloatingTitleBar(hudColor, isCompact),
            ),

            // 2. Top-Center Actions Navigation Bar (#top-center-actions: 36x36 round glass buttons)
            if (!isVerySmall)
              Positioned(
                top: hudTop,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: _buildTopCenterActions(hudColor, isCompact),
                ),
              ),

            // 2b. Active Cinematic Tour Status Banner
            if (widget.state.activeTour != null)
              Positioned(
                top: tourTop,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: _buildTourStatusBanner(hudColor),
                ),
              ),

            // 3. Top-Right Style Indicator & Zulu Clock (#style-indicator)
            Positioned(
              top: hudTop,
              right: isCompact ? 16 : 36,
              child: _buildStyleIndicator(hudColor, isCompact),
            ),

            // 4. Left Floating Data Layers Accordion Trigger (#left-panel-stack)
            if (!isCockpit && !isCompact)
              Positioned(
                top: 112,
                left: 28,
                child: _buildFloatingDataLayersButton(hudColor),
              ),

            // 5. Unified Bottom Command Dock (#command-dock: locations | voice | presets)
            if (!isCockpit)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: _buildUnifiedCommandDock(
                        hudColor, screenWidth, isCompact),
                  ),
                ),
              ),

            // 6. Coordinates & Attribution Readout (#cesium-credits)
            if (!isCockpit && !isCompact)
              Positioned(
                bottom: 104,
                left: 36,
                child: _buildCoordinatesReadout(hudColor),
              ),
          ],
        );
      },
    );
  }

  Widget _buildClassificationRail(Color hudColor, bool isCompact) {
    return Container(
      height: isCompact ? 22 : 26,
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 12 : 24),
      decoration: BoxDecoration(
        color: const Color(0xFF02070B).withValues(alpha: 0.72),
        border: Border(
          bottom: BorderSide(
            color: hudColor.withValues(alpha: 0.18),
            width: 0.8,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'TOP SECRET // SI-TK // NOFORN',
            style: TextStyle(
              color: hudColor.withValues(alpha: 0.72),
              fontSize: isCompact ? 7 : 8,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const Spacer(),
          if (!isCompact)
            Text(
              'OPS-KH11 // ${widget.state.sensorMode.shortCode}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.42),
                fontSize: 8,
                fontFamily: 'monospace',
                letterSpacing: 1.0,
              ),
            ),
          const Spacer(),
          Text(
            'PAGE 1/1',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.42),
              fontSize: isCompact ? 7 : 8,
              fontFamily: 'monospace',
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  /// Minimal Tactical Scope: Framing corner brackets that do NOT obstruct the 3D globe.
  Widget _buildIntelHudScope(Color hudColor, bool isVerySmall) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Only show center crosshair in NVG or FLIR tactical optics mode
        if (widget.state.sensorMode == SensorMode.nvg ||
            widget.state.sensorMode == SensorMode.flir)
          Center(
            child: _buildCenterReticle(hudColor, isVerySmall ? 100 : 140),
          ),

        // Corner framing ticks
        Positioned(
          top: 10,
          left: 12,
          child: Text('┌',
              style: TextStyle(
                  color: hudColor.withValues(alpha: 0.35),
                  fontSize: 20,
                  fontFamily: 'monospace')),
        ),
        Positioned(
          top: 10,
          right: 12,
          child: Text('┐',
              style: TextStyle(
                  color: hudColor.withValues(alpha: 0.35),
                  fontSize: 20,
                  fontFamily: 'monospace')),
        ),
        Positioned(
          bottom: 10,
          left: 12,
          child: Text('└',
              style: TextStyle(
                  color: hudColor.withValues(alpha: 0.35),
                  fontSize: 20,
                  fontFamily: 'monospace')),
        ),
        Positioned(
          bottom: 10,
          right: 12,
          child: Text('┘',
              style: TextStyle(
                  color: hudColor.withValues(alpha: 0.35),
                  fontSize: 20,
                  fontFamily: 'monospace')),
        ),
      ],
    );
  }

  /// Floating Title Bar (#title-bar from upstream foundation.css)
  Widget _buildFloatingTitleBar(Color hudColor, bool isCompact) {
    return GestureDetector(
      onTap: () => widget.bloc.add(const ResetGlobe()),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Ambient radial cyan glow behind title
          Positioned(
            top: -20,
            left: -20,
            child: Container(
              width: 180,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.7,
                  colors: [
                    hudColor.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: isCompact ? 24 : 32,
                    height: isCompact ? 18 : 24,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: hudColor.withValues(alpha: 0.5),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      AssetsConst.gevLogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "GOD'S EYE ",
                          style: TextStyle(
                            color: const Color(0xFFE8EAED),
                            fontSize: isCompact ? 14 : 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                            letterSpacing: isCompact ? 4.0 : 8.0,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.8),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        TextSpan(
                          text: "VIEW",
                          style: TextStyle(
                            color: hudColor,
                            fontSize: isCompact ? 14 : 20,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'monospace',
                            letterSpacing: isCompact ? 4.0 : 8.0,
                            shadows: [
                              Shadow(
                                color: hudColor.withValues(alpha: 0.6),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                  'NO PLACE LEFT BEHIND',
                  style: TextStyle(
                    color: const Color(0xFFE8EAED).withValues(alpha: 0.4),
                    fontSize: isCompact ? 8.5 : 10,
                    fontFamily: 'monospace',
                    letterSpacing: isCompact ? 3.0 : 5.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Floating Top-Center Actions (#top-center-actions from upstream foundation.css & status.css)
  Widget _buildTopCenterActions(Color hudColor, bool isCompact) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
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
            const SizedBox(width: 8),
            _buildCircleIconButton(
              icon: Icons.share,
              tooltip: 'Copy Share Link',
              hudColor: hudColor,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF09121B),
                    content: Text(
                      'COPIED VIEW LINK: ${widget.state.cameraCenter.latitude.toStringAsFixed(3)}N ${widget.state.cameraCenter.longitude.toStringAsFixed(3)}E // ZM: ${widget.state.cameraZoom.toStringAsFixed(1)}',
                      style:
                          TextStyle(color: hudColor, fontFamily: 'monospace'),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            _buildCircleIconButton(
              icon: Icons.public,
              tooltip: 'Reset Globe View',
              hudColor: hudColor,
              onTap: () => widget.bloc.add(const ResetGlobe()),
            ),
            if (widget.onOpenMissions != null) ...[
              const SizedBox(width: 8),
              _buildCircleIconButton(
                icon: Icons.rocket_launch,
                tooltip: 'Mission Control',
                hudColor: const Color(0xFFFF9100),
                onTap: widget.onOpenMissions!,
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF030A12).withValues(alpha: 0.78),
            border: Border.all(
              color: hudColor.withValues(alpha: 0.28),
              width: 0.9,
            ),
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.34),
                blurRadius: 18,
              ),
              BoxShadow(
                color: hudColor.withValues(alpha: 0.08),
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hudColor,
                  boxShadow: [
                    BoxShadow(color: hudColor, blurRadius: 6),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'LIVE DATA // INTEL: ${widget.state.intelligenceSummary}',
                style: TextStyle(
                  color: const Color(0xFFAAFCFF).withValues(alpha: 0.92),
                  fontSize: 8.5,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Floating Style Indicator (#style-indicator from upstream foundation.css)
  Widget _buildStyleIndicator(Color hudColor, bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ACTIVE STYLE',
          style: TextStyle(
            color: const Color(0xFFE8EAED).withValues(alpha: 0.4),
            fontSize: 9.5,
            fontFamily: 'monospace',
            letterSpacing: 3.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          widget.state.sensorMode.displayName.toUpperCase(),
          style: TextStyle(
            color: hudColor,
            fontSize: isCompact ? 13 : 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
            letterSpacing: isCompact ? 3.0 : 5.0,
            shadows: [
              Shadow(
                color: hudColor.withValues(alpha: 0.5),
                blurRadius: 16,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00E676),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              'REC ${_formatZulu(_now)}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 8.5,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${widget.state.totalActiveContacts} TARGETS',
              style: TextStyle(
                color: hudColor.withValues(alpha: 0.85),
                fontSize: 8.5,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Floating Left Accordion Trigger (#left-panel-stack from upstream layers.css)
  Widget _buildFloatingDataLayersButton(Color hudColor) {
    return GlassContainer(
      blur: 24,
      borderRadius: 999,
      color: const Color(0xFF09121B).withValues(alpha: 0.82),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: InkWell(
        onTap: widget.onOpenLayers,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.layers_outlined, size: 13, color: hudColor),
            const SizedBox(width: 6),
            Text(
              'DATA LAYERS',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 8.2,
                fontFamily: 'monospace',
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF0C0C14),
                border: Border.all(color: hudColor.withValues(alpha: 0.4), width: 0.8),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: hudColor.withValues(alpha: 0.18),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                '${widget.state.activeLayers.length}',
                style: TextStyle(
                  color: hudColor,
                  fontSize: 8.5,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Unified 3-Segment Command Dock (#command-dock from upstream command-dock.css)
  Widget _buildUnifiedCommandDock(
      Color hudColor, double screenWidth, bool isCompact) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Basemap Tile Selector Popover (if MAP is toggled)
        if (_presetsExpanded)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF09121B).withValues(alpha: 0.94),
              border: Border.all(
                color: const Color(0xFF7BBDD3).withValues(alpha: 0.35),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.58),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'MAP SOURCE TILE STACK',
                      style: TextStyle(
                        color: hudColor,
                        fontSize: 8.5,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(width: 18),
                    InkWell(
                      onTap: () => setState(() => _presetsExpanded = false),
                      child: const Icon(Icons.close,
                          color: Colors.white54, size: 13),
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

        // Main unified dock container
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: math.min(screenWidth - 24, 1220.0),
          ),
          child: GlassContainer(
            blur: 28,
            borderRadius: 5,
            color: const Color(0xFF050B10).withValues(alpha: 0.82),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: screenWidth >= 960
                ? _buildDesktopDockContent(hudColor)
                : _buildCompactDockContent(hudColor),
          ),
        ),
      ],
    );
  }

  /// Wide layout: 3 distinct areas side-by-side [LOCATION | ELEVATED VOICE MIC | VISUAL PRESETS]
  Widget _buildDesktopDockContent(Color hudColor) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. LOCATION Segment
          Expanded(
            flex: 4,
            child: _buildLocationSection(hudColor),
          ),

          // Divider
          Container(
            width: 1,
            height: 48,
            color: const Color(0xFF7BBDD3).withValues(alpha: 0.16),
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),

          // 2. Elevated AI RECON ANALYST Center Segment
          _buildElevatedVoiceCenter(hudColor),

          // Divider
          Container(
            width: 1,
            height: 48,
            color: const Color(0xFF7BBDD3).withValues(alpha: 0.16),
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),

          // 3. VISUAL PRESETS Segment
          Expanded(
            flex: 5,
            child: _buildPresetsSection(hudColor),
          ),
        ],
      ),
    );
  }

  /// Compact layout (< 960px): Stacked rows adapting cleanly without overflow
  Widget _buildCompactDockContent(Color hudColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _buildLocationSection(hudColor)),
            const SizedBox(width: 8),
            _buildElevatedVoiceCenter(hudColor),
          ],
        ),
        const SizedBox(height: 8),
        Container(
            height: 1, color: const Color(0xFF7BBDD3).withValues(alpha: 0.14)),
        const SizedBox(height: 6),
        _buildPresetsSection(hudColor),
      ],
    );
  }

  /// Location section of the command dock
  Widget _buildLocationSection(Color hudColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AssetsConst.gevLocation,
              width: 10,
              height: 10,
              colorFilter: ColorFilter.mode(
                const Color(0xFFBEDDE6).withValues(alpha: 0.58),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'LOCATION',
              style: TextStyle(
                color: const Color(0xFFBEDDE6).withValues(alpha: 0.58),
                fontSize: 8.0,
                fontFamily: 'monospace',
                letterSpacing: 1.6,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            InkWell(
              onTap: () =>
                  setState(() => _locationsExpanded = !_locationsExpanded),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _locationsExpanded ? Icons.close : Icons.search,
                      size: 13,
                      color: const Color(0xFF00D4FF),
                    ),
                    if (!_locationsExpanded) ...[
                      const SizedBox(width: 4),
                      Text(
                        'SEARCH',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 8,
                          fontFamily: 'monospace',
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (_locationsExpanded) ...[
              const SizedBox(width: 6),
              SizedBox(
                width: 140,
                height: 28,
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    hintText: 'Search city...',
                    hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 9),
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.06),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                          color: Color(0xFF00D4FF), width: 0.8),
                    ),
                  ),
                  onSubmitted: _onSearchSubmit,
                ),
              ),
            ],
            const SizedBox(width: 6),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickCities.map((city) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: InkWell(
                        onTap: () {
                          widget.bloc.add(CenterOnLocation(
                            LatLng(
                                city['lat'] as double, city['lon'] as double),
                            city['zoom'] as double,
                            label: city['name'] as String,
                          ));
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.04),
                            border:
                                Border.all(color: Colors.white12, width: 0.8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            city['name'] as String,
                            style: const TextStyle(
                              color: Color(0xFFE8EAED),
                              fontSize: 8.5,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Elevated AI Recon Analyst Voice Card (#gev-voice-control in command-dock.css)
  Widget _buildElevatedVoiceCenter(Color hudColor) {
    final voiceColor = hudColor;

    return InkWell(
      onTap: widget.onOpenVoice,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(minWidth: 154),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF081F2A).withValues(alpha: 0.94),
          border: Border.all(
            color: voiceColor.withValues(alpha: 0.36),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.56),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: voiceColor.withValues(alpha: 0.16),
              blurRadius: 18,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'GEV MIC // VOICE OPS',
              style: TextStyle(
                color: const Color(0xFFBEDDE6).withValues(alpha: 0.65),
                fontFamily: 'monospace',
                fontSize: 7.5,
                letterSpacing: 1.4,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: voiceColor.withValues(alpha: 0.12),
                    border: Border.all(
                      color: voiceColor.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AssetsConst.gevMic,
                      width: 12,
                      height: 12,
                      colorFilter: ColorFilter.mode(
                        voiceColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'READY // TAP TO TALK',
                      style: TextStyle(
                        color: Color(0xFF00D4FF),
                        fontSize: 8.5,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      'TAP TO SPEAK',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 7,
                        fontFamily: 'monospace',
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Visual Presets section of the command dock
  Widget _buildPresetsSection(Color hudColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AssetsConst.gevVisualPresets,
              width: 10,
              height: 10,
              colorFilter: ColorFilter.mode(
                const Color(0xFFBEDDE6).withValues(alpha: 0.58),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'VISUAL PRESETS',
              style: TextStyle(
                color: const Color(0xFFBEDDE6).withValues(alpha: 0.58),
                fontSize: 8.0,
                fontFamily: 'monospace',
                letterSpacing: 1.6,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...SensorMode.values
                  .map((mode) => _buildStyleButton(mode, hudColor)),
              Container(
                width: 1,
                height: 28,
                color: Colors.white12,
                margin: const EdgeInsets.symmetric(horizontal: 6),
              ),
              _buildDockButton(
                icon: Icons.map_outlined,
                label: 'MAP',
                isActive: _presetsExpanded,
                hudColor: hudColor,
                onTap: () =>
                    setState(() => _presetsExpanded = !_presetsExpanded),
              ),
              const SizedBox(width: 4),
              _buildDockButton(
                icon: Icons.straighten,
                label: 'RULER',
                isActive: widget.state.isMeasureToolActive,
                hudColor: const Color(0xFFFFD600),
                onTap: () => widget.bloc.add(const ToggleMeasureTool()),
              ),
              const SizedBox(width: 4),
              _buildDockButton(
                icon: Icons.movie_filter_outlined,
                label: 'TOURS',
                isActive: widget.state.activeTour != null,
                hudColor: const Color(0xFF00E5FF),
                onTap: () => _showToursModal(context, hudColor),
              ),
              if (widget.state.selectedContact is FlightContact) ...[
                const SizedBox(width: 4),
                _buildDockButton(
                  icon: Icons.flight_takeoff,
                  label: 'COCKPIT',
                  isActive: false,
                  hudColor: const Color(0xFFFF5252),
                  onTap: () => widget.bloc.add(const ToggleCockpitMode(true)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Style button with exact icon, label, and shortcut key badge matching upstream controls.css
  Widget _buildStyleButton(SensorMode mode, Color hudColor) {
    final isSelected = widget.state.sensorMode == mode;
    final modeColor = mode.hudColor;
    final iconGlyph = switch (mode) {
      SensorMode.normal => '◯',
      SensorMode.crt => '▦',
      SensorMode.nvg => '🌙',
      SensorMode.flir => '🌡️',
      SensorMode.anime => '✦',
      SensorMode.noir => '◐',
      SensorMode.snow => '❄',
    };

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InkWell(
        onTap: () => widget.bloc.add(ChangeSensorMode(mode)),
        borderRadius: BorderRadius.circular(7),
        child: Container(
          width: 52,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? modeColor.withValues(alpha: 0.18)
                : Colors.white.withValues(alpha: 0.03),
            border: Border.all(
              color: isSelected ? modeColor : Colors.white10,
              width: isSelected ? 1.2 : 0.8,
            ),
            borderRadius: BorderRadius.circular(7),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: modeColor.withValues(alpha: 0.25),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                right: 1,
                child: Text(
                  '${mode.keyNumber}',
                  style: TextStyle(
                    color: isSelected ? modeColor : Colors.white30,
                    fontSize: 7.5,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    iconGlyph,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? modeColor : Colors.white70,
                      shadows: isSelected
                          ? [
                              Shadow(
                                color: modeColor,
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    mode.displayName.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? modeColor : Colors.white60,
                      fontSize: 7.5,
                      fontFamily: 'monospace',
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
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

    final distanceStr = widget.state.measuredDistanceKm != null
        ? ' | RULER: ${widget.state.measuredDistanceKm!.toStringAsFixed(1)} KM'
        : (widget.state.isMeasureToolActive ? ' | RULER: ARMED' : '');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF09121B).withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: hudColor.withValues(alpha: 0.22)),
      ),
      child: Text(
        'GEOINT: $latStr $lonStr | ZM: ${widget.state.cameraZoom.toStringAsFixed(1)}$distanceStr',
        style: TextStyle(
          color: const Color(0xFFE8EAED).withValues(alpha: 0.6),
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
      borderRadius: BorderRadius.circular(18),
      child: Tooltip(
        message: tooltip,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0C0C14).withValues(alpha: 0.72),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.12), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Icon(icon, size: 18, color: hudColor),
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

  Widget _buildTourStatusBanner(Color hudColor) {
    final tour = widget.state.activeTour!;
    final wpIndex = widget.state.activeTourWaypointIndex;
    final wp = tour.waypoints.isNotEmpty && wpIndex < tour.waypoints.length
        ? tour.waypoints[wpIndex]
        : null;

    return GlassContainer(
      blur: 20,
      borderRadius: 999,
      color: const Color(0xFF0C0C14).withValues(alpha: 0.92),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF00E5FF),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'CINEMATIC TOUR [${wpIndex + 1}/${tour.waypoints.length}]: ${wp?.title ?? tour.name}',
            style: const TextStyle(
              color: Color(0xFF00E5FF),
              fontSize: 10.5,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => widget.bloc.add(const StopCinematicTour()),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.2),
                border: Border.all(color: Colors.redAccent, width: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.stop, color: Colors.redAccent, size: 12),
                  SizedBox(width: 3),
                  Text(
                    'ABORT',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 9,
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
    );
  }

  void _showToursModal(BuildContext context, Color hudColor) {
    final tours = widget.bloc.repository.getCinematicTours();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0C0C14).withValues(alpha: 0.95),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        side: BorderSide(color: Colors.white24, width: 1),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(Icons.movie_filter, color: hudColor, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'CINEMATIC SCENE DIRECTOR',
                      style: TextStyle(
                        color: hudColor,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    if (widget.state.activeTour != null)
                      TextButton.icon(
                        icon: const Icon(Icons.stop,
                            color: Colors.redAccent, size: 16),
                        label: const Text(
                          'ABORT',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontFamily: 'monospace',
                              fontSize: 11),
                        ),
                        onPressed: () {
                          widget.bloc.add(const StopCinematicTour());
                          Navigator.of(ctx).pop();
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                ...tours.map((tour) {
                  final isActive = widget.state.activeTour?.id == tour.id;
                  return Card(
                    color: isActive
                        ? hudColor.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.04),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isActive ? hudColor : Colors.white12,
                        width: 1,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        isActive ? Icons.play_arrow : Icons.explore,
                        color: isActive ? hudColor : Colors.white70,
                      ),
                      title: Text(
                        tour.name,
                        style: TextStyle(
                          color: isActive ? hudColor : Colors.white,
                          fontSize: 12,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${tour.waypoints.length} Keyframes // ${tour.description}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        '${tour.waypoints.length * 6}s',
                        style: TextStyle(
                          color: hudColor.withValues(alpha: 0.7),
                          fontFamily: 'monospace',
                          fontSize: 10,
                        ),
                      ),
                      onTap: () {
                        widget.bloc.add(StartCinematicTour(tour));
                        Navigator.of(ctx).pop();
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
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
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
        decoration: BoxDecoration(
          color:
              isActive ? hudColor.withValues(alpha: 0.2) : Colors.transparent,
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
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? hudColor : Colors.white70,
                fontSize: 9,
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
      ..color = hudColor.withValues(alpha: 0.4)
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
    final arm = size.width * 0.08;
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
        Offset(center.dx + offset, center.dy + offset + arm), paint);
  }

  @override
  bool shouldRepaint(covariant _CrosshairPainter oldDelegate) {
    return oldDelegate.hudColor != hudColor;
  }
}
