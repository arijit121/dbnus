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
            // 1. Top Header Area (Title bar, Action buttons, Status chips, Telemetry)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopHeaderArea(hudColor, isCompact, isVerySmall),
            ),

            // 2. Center Tactical Reticle (only in map overview mode, completely non-blocking)
            if (!isCockpit)
              IgnorePointer(
                child: Center(
                  child: _buildCenterReticle(hudColor, isVerySmall ? 110 : 160),
                ),
              ),

            // 3. Unified Bottom Command Dock (Visual Presets, Location bar, Mic, Layers)
            if (!isCockpit)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isCompact ? screenWidth : 820),
                      child: _buildUnifiedCommandDock(hudColor, isCompact),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTopHeaderArea(Color hudColor, bool isCompact, bool isVerySmall) {
    final lat = widget.state.cameraCenter.latitude;
    final lon = widget.state.cameraCenter.longitude;
    final latStr = '${lat.abs().toStringAsFixed(3)}° ${lat >= 0 ? "N" : "S"}';
    final lonStr = '${lon.abs().toStringAsFixed(3)}° ${lon >= 0 ? "E" : "W"}';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 10 : 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0A0A0F).withValues(alpha: 0.94),
            const Color(0xFF0A0A0F).withValues(alpha: 0.70),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row: Brand Logo & Title | Top Center Actions | Zulu Clock & Contacts
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Brand Title Block (#title-bar from GitHub)
                InkWell(
                  onTap: () => widget.bloc.add(const ResetGlobe()),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hudColor,
                          boxShadow: [
                            BoxShadow(
                              color: hudColor.withValues(alpha: 0.8),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "GOD'S EYE ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isCompact ? 12 : 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                letterSpacing: 1.2,
                              ),
                            ),
                            TextSpan(
                              text: "VIEW",
                              style: TextStyle(
                                color: hudColor,
                                fontSize: isCompact ? 12 : 14,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    color: hudColor.withValues(alpha: 0.6),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                if (!isVerySmall) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: hudColor.withValues(alpha: 0.12),
                      border: Border.all(color: hudColor.withValues(alpha: 0.4), width: 0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.state.sensorMode.displayName,
                      style: TextStyle(
                        color: hudColor,
                        fontSize: 9,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],

                const Spacer(),

                // Top Center Action Buttons (#top-center-actions in GitHub)
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
                    const SizedBox(width: 6),
                    _buildCircleIconButton(
                      icon: Icons.share,
                      tooltip: 'Share View',
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
                        tooltip: 'Mission Control First Run',
                        hudColor: const Color(0xFFFF9100),
                        onTap: widget.onOpenMissions!,
                      ),
                    ],
                  ],
                ),

                const SizedBox(width: 10),

                // Zulu Clock & Contact Count
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C0C14).withValues(alpha: 0.8),
                    border: Border.all(color: hudColor.withValues(alpha: 0.35), width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatZulu(_now),
                        style: TextStyle(
                          color: hudColor,
                          fontSize: isCompact ? 10 : 11,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!isCompact) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 10,
                          color: hudColor.withValues(alpha: 0.3),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.state.totalActiveContacts} CONTACTS',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 10,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Telemetry Sub-line (Intel line + Coordinates)
            Row(
              children: [
                Expanded(
                  child: Text(
                    '// INTEL: ${widget.state.intelligenceSummary}',
                    style: TextStyle(
                      color: hudColor.withValues(alpha: 0.8),
                      fontSize: 10,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'POS: $latStr $lonStr | ZM: ${widget.state.cameraZoom.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 9,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),

            // Live Data Sync status chips (from lines 58-70 of GitHub)
            if (!isCompact) ...[
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatusChip('LIVE DATA', 'SYNCED', hudColor),
                    const SizedBox(width: 8),
                    _buildStatusChip('ROAD NETWORK', 'MAPPED 100%', Colors.white54),
                    const SizedBox(width: 8),
                    _buildStatusChip('CCTV FEEDS', '${widget.state.cctvCameras.length} CAMERAS ONLINE', const Color(0xFF00E676)),
                    const SizedBox(width: 8),
                    _buildStatusChip('SUBSEA INFRA', '${widget.state.infrastructure.length} NODES', const Color(0xFFAB47BC)),
                  ],
                ),
              ),
            ],
          ],
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
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0C0C14).withValues(alpha: 0.8),
            border: Border.all(color: hudColor.withValues(alpha: 0.4), width: 1),
          ),
          child: Icon(icon, size: 14, color: hudColor),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.8),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 5),
          Text(
            '$label: $value',
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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

  Widget _buildUnifiedCommandDock(Color hudColor, bool isCompact) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Popover 1: Visual Presets Tray (#control-panel in GitHub)
        if (_presetsExpanded)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0C0C14).withValues(alpha: 0.94),
              border: Border.all(color: hudColor.withValues(alpha: 0.5), width: 1.2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.7),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'VISUAL PRESETS (KEYBOARD 1–7)',
                      style: TextStyle(
                        color: hudColor,
                        fontSize: 10,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70, size: 14),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => setState(() => _presetsExpanded = false),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: SensorMode.values.map((mode) {
                    final isSelected = widget.state.sensorMode == mode;
                    return InkWell(
                      onTap: () {
                        widget.bloc.add(ChangeSensorMode(mode));
                        setState(() => _presetsExpanded = false);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? mode.hudColor.withValues(alpha: 0.25)
                              : Colors.white.withValues(alpha: 0.05),
                          border: Border.all(
                            color: isSelected ? mode.hudColor : Colors.white24,
                            width: isSelected ? 1.4 : 0.8,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(mode.iconSymbol, style: TextStyle(fontSize: 11, color: mode.hudColor)),
                            const SizedBox(width: 6),
                            Text(
                              mode.displayName,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontSize: 10,
                                fontFamily: 'monospace',
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                '${mode.keyNumber}',
                                style: TextStyle(color: mode.hudColor, fontSize: 8, fontFamily: 'monospace'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Text(
                  'MAP SOURCE TILE STACK',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 9,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
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
                          fontSize: 9,
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

        // Popover 2: Location Bar & Quick City Pills (#location-bar in GitHub)
        if (_locationsExpanded)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0C0C14).withValues(alpha: 0.94),
              border: Border.all(color: hudColor.withValues(alpha: 0.5), width: 1.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.search, size: 14, color: hudColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace'),
                        decoration: InputDecoration(
                          hintText: 'Search any location (e.g. Tokyo, London, LAX)...',
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 6),
                          border: InputBorder.none,
                        ),
                        onSubmitted: _onSearchSubmit,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70, size: 14),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => setState(() => _locationsExpanded = false),
                    ),
                  ],
                ),
                const Divider(color: Colors.white12, height: 16),
                Text(
                  'GLOBAL RECONNAISSANCE TARGETS',
                  style: TextStyle(
                    color: hudColor.withValues(alpha: 0.8),
                    fontSize: 9,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _quickCities.map((city) {
                    return InkWell(
                      onTap: () {
                        widget.bloc.add(CenterOnLocation(
                          LatLng(city['lat'] as double, city['lon'] as double),
                          city['zoom'] as double,
                          label: city['name'] as String,
                        ));
                        setState(() => _locationsExpanded = false);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          border: Border.all(color: Colors.white24, width: 0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          city['name'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

        // Primary Dock Bar (#command-dock in GitHub)
        GlassContainer(
          blur: 16,
          borderRadius: 10,
          color: const Color(0xFF0C0C14).withValues(alpha: 0.90),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Visual Presets Toggle Button
                _buildDockButton(
                  icon: Icons.palette_outlined,
                  label: 'PRESETS (${widget.state.sensorMode.displayName})',
                  isActive: _presetsExpanded,
                  hudColor: hudColor,
                  onTap: () {
                    setState(() {
                      _presetsExpanded = !_presetsExpanded;
                      if (_presetsExpanded) _locationsExpanded = false;
                    });
                  },
                ),
                const SizedBox(width: 6),

                // Location Bar Toggle Button
                _buildDockButton(
                  icon: Icons.explore,
                  label: 'LOCATION',
                  isActive: _locationsExpanded,
                  hudColor: hudColor,
                  onTap: () {
                    setState(() {
                      _locationsExpanded = !_locationsExpanded;
                      if (_locationsExpanded) _presetsExpanded = false;
                    });
                  },
                ),
                const SizedBox(width: 6),

                // Voice Agent Mic Button (#GEV MIC)
                InkWell(
                  onTap: widget.onOpenVoice,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: hudColor.withValues(alpha: 0.18),
                      border: Border.all(color: hudColor, width: 1.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mic, color: hudColor, size: 13),
                        const SizedBox(width: 4),
                        Text(
                          'GEV MIC',
                          style: TextStyle(
                            color: hudColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Cockpit View Button (if flight contact selected)
                if (widget.state.selectedContact is FlightContact) ...[
                  InkWell(
                    onTap: () => widget.bloc.add(const ToggleCockpitMode(true)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5252).withValues(alpha: 0.25),
                        border: Border.all(color: const Color(0xFFFF5252), width: 1.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flight_takeoff, color: Color(0xFFFF5252), size: 13),
                          SizedBox(width: 4),
                          Text(
                            'COCKPIT',
                            style: TextStyle(
                              color: Color(0xFFFF5252),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],

                // Data Layers Toggle
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
