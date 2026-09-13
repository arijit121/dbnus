import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

import 'package:dbnus/shared/ui/atoms/decorations/glass_container.dart';
import 'package:dbnus/features/gods_eye_view/data/repositories/gods_eye_view_repository_impl.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/sensor_mode.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_bloc.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_event.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_state.dart';
import 'package:dbnus/features/gods_eye_view/presentation/widgets/cctv_feed_dialog.dart';
import 'package:dbnus/features/gods_eye_view/presentation/widgets/cockpit_hud_view.dart';
import 'package:dbnus/features/gods_eye_view/presentation/widgets/contact_detail_sheet.dart';
import 'package:dbnus/features/gods_eye_view/presentation/widgets/first_run_launcher_dialog.dart';
import 'package:dbnus/features/gods_eye_view/presentation/widgets/layer_control_drawer.dart';
import 'package:dbnus/features/gods_eye_view/presentation/widgets/sensor_shader_overlay.dart';
import 'package:dbnus/features/gods_eye_view/presentation/widgets/tactical_hud_overlay.dart';
import 'package:dbnus/features/gods_eye_view/presentation/widgets/voice_analyst_bar.dart';

/// God's Eye View (GEV) Master Screen:
/// Live open-source spatial intelligence simulator with photorealistic / tactical
/// basemaps, sensor optics shaders (NVG, FLIR, CRT), cockpit chase mode, and live telemetry.
class GodsEyeViewPage extends StatelessWidget {
  const GodsEyeViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GodsEyeViewBloc(
        repository: GodsEyeViewRepositoryImpl(),
      )..add(const InitGeointData()),
      child: const _GodsEyeViewView(),
    );
  }
}

class _GodsEyeViewView extends StatefulWidget {
  const _GodsEyeViewView();

  @override
  State<_GodsEyeViewView> createState() => _GodsEyeViewViewState();
}

class _GodsEyeViewViewState extends State<_GodsEyeViewView> {
  final MapController _mapController = MapController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _focusNode = FocusNode();
  bool _hudVisible = true;

  late final MapOptions _mapOptions;

  @override
  void initState() {
    super.initState();
    final initialState = context.read<GodsEyeViewBloc>().state;
    _mapOptions = MapOptions(
      initialCenter: initialState.cameraCenter,
      initialZoom: initialState.cameraZoom,
      minZoom: 2.0,
      maxZoom: 18.0,
      interactionOptions: const InteractionOptions(
        flags: InteractiveFlag.all,
      ),
      onTap: (_, point) {
        final bloc = context.read<GodsEyeViewBloc>();
        if (bloc.state.isMeasureToolActive) {
          bloc.add(AddMeasurementPoint(point));
        } else {
          bloc.add(const SelectContact(null));
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(
      KeyEvent event, GodsEyeViewBloc bloc, GodsEyeViewState state) {
    if (event is! KeyDownEvent) return;

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.digit1 ||
        key == LogicalKeyboardKey.numpad1) {
      bloc.add(const ChangeSensorMode(SensorMode.normal));
    } else if (key == LogicalKeyboardKey.digit2 ||
        key == LogicalKeyboardKey.numpad2) {
      bloc.add(const ChangeSensorMode(SensorMode.crt));
    } else if (key == LogicalKeyboardKey.digit3 ||
        key == LogicalKeyboardKey.numpad3) {
      bloc.add(const ChangeSensorMode(SensorMode.nvg));
    } else if (key == LogicalKeyboardKey.digit4 ||
        key == LogicalKeyboardKey.numpad4) {
      bloc.add(const ChangeSensorMode(SensorMode.flir));
    } else if (key == LogicalKeyboardKey.digit5 ||
        key == LogicalKeyboardKey.numpad5) {
      bloc.add(const ChangeSensorMode(SensorMode.anime));
    } else if (key == LogicalKeyboardKey.digit6 ||
        key == LogicalKeyboardKey.numpad6) {
      bloc.add(const ChangeSensorMode(SensorMode.noir));
    } else if (key == LogicalKeyboardKey.digit7 ||
        key == LogicalKeyboardKey.numpad7) {
      bloc.add(const ChangeSensorMode(SensorMode.snow));
    } else if (key == LogicalKeyboardKey.keyH) {
      setState(() => _hudVisible = !_hudVisible);
    } else if (key == LogicalKeyboardKey.keyD) {
      bloc.add(const ToggleLayer(GeointLayer.detectionBoxes));
    } else if (key == LogicalKeyboardKey.keyC) {
      bloc.add(ToggleCockpitMode(!state.isCockpitMode));
    } else if (key == LogicalKeyboardKey.escape) {
      if (state.isCockpitMode) {
        bloc.add(const ToggleCockpitMode(false));
      } else if (state.selectedContact != null) {
        bloc.add(const SelectContact(null));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GodsEyeViewBloc, GodsEyeViewState>(
      listenWhen: (prev, curr) =>
          (curr.isCockpitMode && prev.cameraCenter != curr.cameraCenter) ||
          prev.cameraZoom != curr.cameraZoom ||
          (prev.selectedContact != curr.selectedContact && curr.selectedContact != null),
      listener: (context, state) {
        _mapController.move(state.cameraCenter, state.cameraZoom);
      },
      builder: (context, state) {
        final bloc = context.read<GodsEyeViewBloc>();
        final hudColor = state.sensorMode.hudColor;

        return KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: (event) => _handleKeyEvent(event, bloc, state),
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.black,
            endDrawer: LayerControlDrawer(state: state, bloc: bloc),
            body: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Map Canvas with Sensor Optics Filter
                SensorShaderOverlay(
                  mode: state.sensorMode,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: _mapOptions,
                    children: [
                      // Basemap Tile Layer
                      TileLayer(
                        urlTemplate: state.basemap.tileUrl,
                        userAgentPackageName: 'com.dbnus.app',
                      ),

                      // Orbital & Flight Trail Vectors (Visual only - ignore pointer to prevent hit-test multi-world loops)
                      IgnorePointer(
                        child: PolylineLayer(
                          polylines: _buildPolylines(state, hudColor),
                        ),
                      ),

                      // CCTV Viewshed Coverage Cones (Visual only - safe custom painter)
                      if (state.activeLayers.contains(GeointLayer.cctv))
                        _CctvViewshedLayer(
                          cameras: state.cctvCameras,
                          hudColor: hudColor,
                        ),

                      // Seismic Pulse Rings (Visual only - safe custom painter immune to multi-world loop bugs)
                      if (state.activeLayers.contains(GeointLayer.earthquakes))
                        _SeismicPulseLayer(
                          earthquakes: state.earthquakes,
                        ),

                      // Entity Tactical Markers
                      MarkerLayer(
                        markers: _buildMarkers(state, bloc, hudColor),
                      ),
                    ],
                  ),
                ),

                // 2. Cockpit Mode Heads-Up Display
                if (state.isCockpitMode &&
                    state.selectedContact is FlightContact)
                  CockpitHudView(
                    flight: state.selectedContact as FlightContact,
                    allFlights: state.flights,
                    sensorMode: state.sensorMode,
                    bloc: bloc,
                  ),

                // 3. Tactical Military HUD Overlay
                if (_hudVisible)
                  TacticalHudOverlay(
                    state: state,
                    bloc: bloc,
                    onOpenLayers: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    onOpenVoice: () {
                      _showVoiceAnalyst(context, bloc, state.sensorMode);
                    },
                    onOpenMissions: () {
                      _showMissionControl(context, bloc, hudColor);
                    },
                  ),

                // 4. Contact Detail Sheet (Slide-Up)
                if (state.selectedContact != null && !state.isCockpitMode)
                  Positioned(
                    bottom: 80,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 480,
                            maxHeight: MediaQuery.of(context).size.height * 0.45,
                          ),
                        child: SingleChildScrollView(
                          child: ContactDetailSheet(
                            contact: state.selectedContact!,
                            sensorMode: state.sensorMode,
                            bloc: bloc,
                            onViewCctv: () {
                              if (state.selectedContact is CctvCameraContact) {
                                _showCctvFeed(
                                  context,
                                  state.selectedContact as CctvCameraContact,
                                  state.sensorMode,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // 5. Loading Indicator
              if (state.isLoading)
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GlassContainer(
                      blur: 16,
                      borderRadius: 6,
                      color: const Color(0xFF0C0C14).withValues(alpha: 0.88),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: hudColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'SYNCHRONIZING GEOINT SATELLITE FEEDS...',
                            style: TextStyle(
                              color: hudColor,
                              fontSize: 11,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
  }

  List<Polyline> _buildPolylines(GodsEyeViewState state, Color hudColor) {
    final polylines = <Polyline>[];

    // Satellite Orbit Tracks
    if (state.activeLayers.contains(GeointLayer.satellites)) {
      for (final sat in state.satellites) {
        if (sat.orbitPath.length > 2) {
          polylines.add(
            Polyline(
              points: sat.orbitPath,
              color: hudColor.withValues(alpha: 0.35),
              strokeWidth: 1.2,
            ),
          );
        }
      }
    }

    // Selected Flight Trail
    if (state.selectedContact is FlightContact) {
      final flight = state.selectedContact as FlightContact;
      if (flight.trail.length > 1) {
        polylines.add(
          Polyline(
            points: flight.trail,
            color: const Color(0xFFFFD600).withValues(alpha: 0.8),
            strokeWidth: 2.0,
          ),
        );
      }
    }

    // Space Launch Trajectories
    if (state.activeLayers.contains(GeointLayer.spaceLaunches)) {
      for (final launch in state.spaceLaunches) {
        if (launch.trajectoryPoints.length > 1) {
          polylines.add(
            Polyline(
              points: launch.trajectoryPoints,
              color: const Color(0xFFFF5252).withValues(alpha: 0.75),
              strokeWidth: 2.2,
            ),
          );
        }
      }
    }

    // Tactical Measurement Ruler Line
    if (state.isMeasureToolActive && state.measurementPoints.length > 1) {
      polylines.add(
        Polyline(
          points: state.measurementPoints,
          color: const Color(0xFFFFD600),
          strokeWidth: 2.5,
        ),
      );
    }

    return polylines;
  }

  // (Replaced by _CctvViewshedLayer and _SeismicPulseLayer below)


  List<Marker> _buildMarkers(
      GodsEyeViewState state, GodsEyeViewBloc bloc, Color hudColor) {
    final markers = <Marker>[];
    final showBoxes = state.activeLayers.contains(GeointLayer.detectionBoxes);

    // 1. Flights
    if (state.activeLayers.contains(GeointLayer.flights)) {
      for (final f in state.flights) {
        if (f.isMilitary &&
            !state.activeLayers.contains(GeointLayer.military)) {
          continue;
        }

        final isSelected = state.selectedContact?.id == f.id;
        final iconColor = f.isMilitary
            ? const Color(0xFFFF9100) // Military amber
            : (isSelected ? const Color(0xFFFFD600) : hudColor);

        markers.add(
          Marker(
            point: f.position,
            width: showBoxes ? 110 : 44,
            height: showBoxes ? 68 : 44,
            child: GestureDetector(
              onTap: () => bloc.add(SelectContact(f)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.rotate(
                    angle: f.headingDeg * (math.pi / 180.0),
                    child: SizedBox(
                      width: isSelected ? 32 : 26,
                      height: isSelected ? 32 : 26,
                      child: CustomPaint(
                        painter: _TacticalChevronPainter(
                          color: iconColor,
                          isMilitary: f.isMilitary,
                          isSelected: isSelected,
                          speedKnots: f.speedKnots,
                        ),
                      ),
                    ),
                  ),
                  if (showBoxes)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF03070D).withValues(alpha: 0.88),
                        border: Border.all(
                            color: iconColor.withValues(alpha: 0.85), width: 0.8),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            color: iconColor.withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            f.callsign,
                            style: TextStyle(
                              color: iconColor,
                              fontSize: 7.5,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            'FL${(f.altitudeFt / 100).round()} · ${f.speedKnots.toInt()}KT',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 6.5,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }
    }

    // 2. Satellites
    if (state.activeLayers.contains(GeointLayer.satellites)) {
      for (final s in state.satellites) {
        final isSelected = state.selectedContact?.id == s.id;
        final satColor = isSelected ? const Color(0xFFFFD600) : const Color(0xFF00E5FF);

        markers.add(
          Marker(
            point: s.position,
            width: showBoxes ? 90 : 36,
            height: showBoxes ? 52 : 36,
            child: GestureDetector(
              onTap: () => bloc.add(SelectContact(s)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CustomPaint(
                      painter: _TacticalSatellitePainter(
                        color: satColor,
                        isSelected: isSelected,
                      ),
                    ),
                  ),
                  if (showBoxes)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF03070D).withValues(alpha: 0.88),
                        border: Border.all(
                            color: satColor.withValues(alpha: 0.8), width: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        'NORAD ${s.noradId}',
                        style: TextStyle(
                          color: satColor,
                          fontSize: 7,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }
    }

    // 3. Maritime Vessels
    if (state.activeLayers.contains(GeointLayer.vessels)) {
      for (final v in state.vessels) {
        final isSelected = state.selectedContact?.id == v.id;
        final vslColor = isSelected ? const Color(0xFFFFD600) : const Color(0xFF26A69A);

        markers.add(
          Marker(
            point: v.position,
            width: showBoxes ? 80 : 32,
            height: showBoxes ? 50 : 32,
            child: GestureDetector(
              onTap: () => bloc.add(SelectContact(v)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.rotate(
                    angle: v.headingDeg * (math.pi / 180.0),
                    child: Icon(
                      Icons.navigation,
                      color: vslColor,
                      size: 18,
                    ),
                  ),
                  if (showBoxes)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        border: Border.all(
                            color: vslColor, width: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        'VSL: ${v.speedKnots}KT',
                        style: TextStyle(
                          color: vslColor,
                          fontSize: 7,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }
    }

    // 4. CCTV Cameras
    if (state.activeLayers.contains(GeointLayer.cctv)) {
      for (final c in state.cctvCameras) {
        final isSelected = state.selectedContact?.id == c.id;
        markers.add(
          Marker(
            point: c.position,
            width: 32,
            height: 32,
            child: GestureDetector(
              onTap: () => bloc.add(SelectContact(c)),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFFD600).withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFFD600)
                        : const Color(0xFF00E676),
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  Icons.videocam,
                  color: isSelected
                      ? const Color(0xFFFFD600)
                      : const Color(0xFF00E676),
                  size: 14,
                ),
              ),
            ),
          ),
        );
      }
    }

    // 5. Critical Infrastructure
    if (state.activeLayers.contains(GeointLayer.infrastructure)) {
      for (final i in state.infrastructure) {
        final isSelected = state.selectedContact?.id == i.id;
        markers.add(
          Marker(
            point: i.position,
            width: 32,
            height: 32,
            child: GestureDetector(
              onTap: () => bloc.add(SelectContact(i)),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFFD600).withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFFD600)
                        : const Color(0xFFAB47BC),
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  Icons.cable,
                  color: isSelected
                      ? const Color(0xFFFFD600)
                      : const Color(0xFFAB47BC),
                  size: 14,
                ),
              ),
            ),
          ),
        );
      }
    }

    // 5b. USGS Earthquakes
    if (state.activeLayers.contains(GeointLayer.earthquakes)) {
      for (final eq in state.earthquakes) {
        final isSelected = state.selectedContact?.id == eq.id;
        final eqColor = eq.alertLevel == 'red'
            ? const Color(0xFFFF1744)
            : eq.alertLevel == 'orange'
                ? const Color(0xFFFF9100)
                : const Color(0xFFFFEA00);

        markers.add(
          Marker(
            point: eq.position,
            width: showBoxes ? 90 : 36,
            height: showBoxes ? 54 : 36,
            child: GestureDetector(
              onTap: () => bloc.add(SelectContact(eq)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: eqColor.withValues(alpha: 0.3),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFFD600) : eqColor,
                        width: isSelected ? 2.0 : 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: eqColor.withValues(alpha: 0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.waves,
                      color: isSelected ? const Color(0xFFFFD600) : eqColor,
                      size: 13,
                    ),
                  ),
                  if (showBoxes)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.85),
                        border: Border.all(color: eqColor, width: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        'M${eq.magnitude.toStringAsFixed(1)} · ${eq.depthKm.toInt()}KM',
                        style: TextStyle(
                          color: eqColor,
                          fontSize: 6.5,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }
    }

    // 6. NASA FIRMS Wildfires
    if (state.activeLayers.contains(GeointLayer.wildfires)) {
      for (final wf in state.wildfires) {
        final isSelected = state.selectedContact?.id == wf.id;
        final fireColor = isSelected ? const Color(0xFFFFD600) : const Color(0xFFFF3D00);

        markers.add(
          Marker(
            point: wf.position,
            width: showBoxes ? 95 : 36,
            height: showBoxes ? 56 : 36,
            child: GestureDetector(
              onTap: () => bloc.add(SelectContact(wf)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: fireColor.withValues(alpha: 0.25),
                      border: Border.all(color: fireColor, width: isSelected ? 2.0 : 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: fireColor.withValues(alpha: 0.6),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.local_fire_department,
                      color: fireColor,
                      size: 14,
                    ),
                  ),
                  if (showBoxes)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.85),
                        border: Border.all(color: fireColor, width: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        '${wf.frpMw.toInt()}MW · ${wf.region}',
                        style: TextStyle(
                          color: fireColor,
                          fontSize: 6.5,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }
    }

    // 7. Spaceport Rocket Launches
    if (state.activeLayers.contains(GeointLayer.spaceLaunches)) {
      for (final sl in state.spaceLaunches) {
        final isSelected = state.selectedContact?.id == sl.id;
        final launchColor = isSelected ? const Color(0xFFFFD600) : const Color(0xFFFF5252);

        markers.add(
          Marker(
            point: sl.position,
            width: showBoxes ? 110 : 38,
            height: showBoxes ? 56 : 38,
            child: GestureDetector(
              onTap: () => bloc.add(SelectContact(sl)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: launchColor.withValues(alpha: 0.25),
                      border: Border.all(color: launchColor, width: isSelected ? 2.0 : 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: launchColor.withValues(alpha: 0.6),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.rocket_launch,
                      color: launchColor,
                      size: 13,
                    ),
                  ),
                  if (showBoxes)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.85),
                        border: Border.all(color: launchColor, width: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        sl.vehicle,
                        style: TextStyle(
                          color: launchColor,
                          fontSize: 6.5,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }
    }

    // 8. Measurement Waypoint Markers & Midpoint Distance Badge
    if (state.isMeasureToolActive && state.measurementPoints.isNotEmpty) {
      for (int i = 0; i < state.measurementPoints.length; i++) {
        final pt = state.measurementPoints[i];
        final label = i == 0 ? 'A' : 'B';
        markers.add(
          Marker(
            point: pt,
            width: 28,
            height: 28,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD600),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [
                  BoxShadow(color: Color(0xFFFFD600), blurRadius: 8, spreadRadius: 1),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        );
      }

      // If both points exist, show midpoint badge with distance
      if (state.measurementPoints.length == 2 && state.measuredDistanceKm != null) {
        final p1 = state.measurementPoints[0];
        final p2 = state.measurementPoints[1];
        final midLat = (p1.latitude + p2.latitude) / 2.0;
        final midLon = (p1.longitude + p2.longitude) / 2.0;
        final km = state.measuredDistanceKm!;
        final nm = km * 0.539957;

        markers.add(
          Marker(
            point: LatLng(midLat, midLon),
            width: 150,
            height: 32,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF0C0C14).withValues(alpha: 0.95),
                border: Border.all(color: const Color(0xFFFFD600), width: 1.2),
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(color: Colors.black54, blurRadius: 6),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                '${km.toStringAsFixed(1)} KM (${nm.toStringAsFixed(1)} NM)',
                style: const TextStyle(
                  color: Color(0xFFFFD600),
                  fontSize: 8.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        );
      }
    }

    return markers;
  }

  void _showVoiceAnalyst(
      BuildContext context, GodsEyeViewBloc bloc, SensorMode mode) {
    showDialog(
      context: context,
      builder: (_) => VoiceAnalystDialog(bloc: bloc, sensorMode: mode),
    );
  }

  void _showCctvFeed(
      BuildContext context, CctvCameraContact cam, SensorMode mode) {
    showDialog(
      context: context,
      builder: (_) => CctvFeedDialog(camera: cam, sensorMode: mode),
    );
  }

  void _showMissionControl(
      BuildContext context, GodsEyeViewBloc bloc, Color hudColor) {
    FirstRunLauncherDialog.show(context, bloc, hudColor);
  }
}

/// Military radar delta chevron painter for aircraft
class _TacticalChevronPainter extends CustomPainter {
  final Color color;
  final bool isMilitary;
  final bool isSelected;
  final double speedKnots;

  const _TacticalChevronPainter({
    required this.color,
    required this.isMilitary,
    required this.isSelected,
    required this.speedKnots,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // 1. Forward velocity vector lead-line
    final vectorLen = (speedKnots / 30).clamp(8.0, 22.0);
    final vectorPaint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(cx, cy - 6), Offset(cx, cy - 6 - vectorLen), vectorPaint);

    // 2. Tactical delta chevron path (Apex pointing UP)
    final path = Path();
    path.moveTo(cx, cy - 8); // Apex nose
    path.lineTo(cx + 7, cy + 7); // Right wing tip
    path.lineTo(cx, cy + 3); // Inward engine notch
    path.lineTo(cx - 7, cy + 7); // Left wing tip
    path.close();

    final fillPaint = Paint()
      ..color = color.withValues(alpha: isSelected ? 0.95 : 0.75)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final strokePaint = Paint()
      ..color = isSelected ? Colors.white : color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, strokePaint);

    // 3. Center glowing avionics beacon
    canvas.drawCircle(Offset(cx, cy), 1.5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _TacticalChevronPainter old) =>
      old.color != color || old.isSelected != isSelected || old.speedKnots != speedKnots;
}

/// Orbit radar diamond painter for satellites
class _TacticalSatellitePainter extends CustomPainter {
  final Color color;
  final bool isSelected;

  const _TacticalSatellitePainter({
    required this.color,
    required this.isSelected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Outer orbital radar ring
    final ringPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(cx, cy), 9, ringPaint);

    // Tactical diamond
    final path = Path();
    path.moveTo(cx, cy - 6);
    path.lineTo(cx + 6, cy);
    path.lineTo(cx, cy + 6);
    path.lineTo(cx - 6, cy);
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.8)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 0.8
        ..style = PaintingStyle.stroke,
    );

    // Center core
    canvas.drawCircle(Offset(cx, cy), 1.5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _TacticalSatellitePainter old) =>
      old.color != color || old.isSelected != isSelected;
}

/// Safe, non-interactive seismic shockwave layer completely immune to
/// flutter_map's CircleLayer multi-world infinite loop bug (issue #2052).
class _SeismicPulseLayer extends StatelessWidget {
  final List<EarthquakeContact> earthquakes;

  const _SeismicPulseLayer({required this.earthquakes});

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.of(context);

    return MobileLayerTransformer(
      child: CustomPaint(
        painter: _SeismicRingsPainter(
          earthquakes: earthquakes,
          camera: camera,
        ),
        size: camera.size,
      ),
    );
  }
}

class _SeismicRingsPainter extends CustomPainter {
  final List<EarthquakeContact> earthquakes;
  final MapCamera camera;

  _SeismicRingsPainter({required this.earthquakes, required this.camera});

  @override
  void paint(Canvas canvas, Size size) {
    for (final eq in earthquakes) {
      final center = camera.getOffsetFromOrigin(eq.position);
      final radius = (eq.magnitude * 5.0).clamp(12.0, 45.0);
      final color = eq.alertLevel == 'red'
          ? const Color(0xFFFF1744)
          : eq.alertLevel == 'orange'
              ? const Color(0xFFFF9100)
              : const Color(0xFFFFEA00);

      // Outer shockwave ripple
      canvas.drawCircle(
        center,
        radius * 1.5,
        Paint()
          ..color = color.withValues(alpha: 0.22)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );

      // Inner filled disk
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = color.withValues(alpha: 0.14)
          ..style = PaintingStyle.fill,
      );

      // Primary perimeter stroke
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = color.withValues(alpha: 0.85)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SeismicRingsPainter oldDelegate) {
    return oldDelegate.earthquakes != earthquakes ||
        oldDelegate.camera != camera;
  }

  // Explicitly return false to guarantee zero multi-world hit testing loops
  @override
  bool? hitTest(Offset position) => false;
}

/// Safe, non-interactive CCTV viewshed cone layer immune to
/// flutter_map's PolygonLayer multi-world infinite loop bug.
class _CctvViewshedLayer extends StatelessWidget {
  final List<CctvCameraContact> cameras;
  final Color hudColor;

  const _CctvViewshedLayer({required this.cameras, required this.hudColor});

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.of(context);

    return MobileLayerTransformer(
      child: CustomPaint(
        painter: _CctvViewshedPainter(
          cameras: cameras,
          hudColor: hudColor,
          camera: camera,
        ),
        size: camera.size,
      ),
    );
  }
}

class _CctvViewshedPainter extends CustomPainter {
  final List<CctvCameraContact> cameras;
  final Color hudColor;
  final MapCamera camera;

  _CctvViewshedPainter({
    required this.cameras,
    required this.hudColor,
    required this.camera,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = hudColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = hudColor.withValues(alpha: 0.40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (final cam in cameras) {
      const radiusKm = 1.5;
      final halfFovRad = (cam.fovDeg / 2.0) * (math.pi / 180.0);
      final bearingRad = cam.bearingDeg * (math.pi / 180.0);

      final leftRad = bearingRad - halfFovRad;
      final rightRad = bearingRad + halfFovRad;

      final p0 = camera.getOffsetFromOrigin(cam.position);
      final pLeft = camera.getOffsetFromOrigin(_projectPoint(cam.position, radiusKm, leftRad));
      final pRight = camera.getOffsetFromOrigin(_projectPoint(cam.position, radiusKm, rightRad));

      final path = ui.Path()
        ..moveTo(p0.dx, p0.dy)
        ..lineTo(pLeft.dx, pLeft.dy)
        ..lineTo(pRight.dx, pRight.dy)
        ..close();

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    }
  }

  LatLng _projectPoint(LatLng origin, double distKm, double angleRad) {
    final deltaLat = (distKm / 111.0) * math.cos(angleRad);
    final cosLat = math.cos(origin.latitude * (math.pi / 180.0));
    final deltaLon =
        (distKm / (111.0 * (cosLat.abs() < 0.01 ? 0.01 : cosLat))) *
            math.sin(angleRad);

    return LatLng(origin.latitude + deltaLat, origin.longitude + deltaLon);
  }

  @override
  bool shouldRepaint(covariant _CctvViewshedPainter oldDelegate) {
    return oldDelegate.cameras != cameras ||
        oldDelegate.hudColor != hudColor ||
        oldDelegate.camera != camera;
  }

  // Explicitly return false to guarantee zero multi-world hit testing loops
  @override
  bool? hitTest(Offset position) => false;
}

