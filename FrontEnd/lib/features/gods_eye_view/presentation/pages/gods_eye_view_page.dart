import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

  @override
  void initState() {
    super.initState();
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
                    options: MapOptions(
                      initialCenter: state.cameraCenter,
                      initialZoom: state.cameraZoom,
                      minZoom: 2.0,
                      maxZoom: 18.0,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                      onTap: (_, __) {
                        bloc.add(const SelectContact(null));
                      },
                    ),
                    children: [
                      // Basemap Tile Layer
                      TileLayer(
                        urlTemplate: state.basemap.tileUrl,
                        userAgentPackageName: 'com.dbnus.app',
                      ),

                      // Orbital & Flight Trail Vectors
                      PolylineLayer(
                        polylines: _buildPolylines(state, hudColor),
                      ),

                      // CCTV Viewshed Coverage Cones
                      if (state.activeLayers.contains(GeointLayer.cctv))
                        PolygonLayer(
                          polygons: _buildCctvViewsheds(state, hudColor),
                        ),

                      // Seismic Pulse Rings
                      if (state.activeLayers.contains(GeointLayer.earthquakes))
                        CircleLayer(
                          circles: _buildEarthquakeCircles(state),
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

    return polylines;
  }

  List<Polygon> _buildCctvViewsheds(
      GodsEyeViewState state, Color hudColor) {
    final polygons = <Polygon>[];

    for (final cam in state.cctvCameras) {
      // Build triangular FOV cone ~2km deep
      const radiusKm = 1.5;
      final halfFovRad = (cam.fovDeg / 2.0) * (math.pi / 180.0);
      final bearingRad = cam.bearingDeg * (math.pi / 180.0);

      final leftRad = bearingRad - halfFovRad;
      final rightRad = bearingRad + halfFovRad;

      final p0 = cam.position;
      final pLeft = _projectPoint(p0, radiusKm, leftRad);
      final pRight = _projectPoint(p0, radiusKm, rightRad);

      polygons.add(
        Polygon(
          points: [p0, pLeft, pRight],
          color: hudColor.withValues(alpha: 0.12),
          borderColor: hudColor.withValues(alpha: 0.4),
          borderStrokeWidth: 1.0,
        ),
      );
    }

    return polygons;
  }

  LatLng _projectPoint(LatLng origin, double distKm, double angleRad) {
    final deltaLat = (distKm / 111.0) * math.cos(angleRad);
    final cosLat = math.cos(origin.latitude * (math.pi / 180.0));
    final deltaLon =
        (distKm / (111.0 * (cosLat.abs() < 0.01 ? 0.01 : cosLat))) *
            math.sin(angleRad);

    return LatLng(origin.latitude + deltaLat, origin.longitude + deltaLon);
  }

  List<CircleMarker> _buildEarthquakeCircles(GodsEyeViewState state) {
    return state.earthquakes.map((eq) {
      final radius = (eq.magnitude * 5.0).clamp(12.0, 45.0);
      final color = eq.alertLevel == 'red'
          ? const Color(0xFFFF1744)
          : eq.alertLevel == 'orange'
              ? const Color(0xFFFF9100)
              : const Color(0xFFFFEA00);

      return CircleMarker(
        point: eq.position,
        radius: radius,
        color: color.withValues(alpha: 0.2),
        borderColor: color.withValues(alpha: 0.8),
        borderStrokeWidth: 1.5,
      );
    }).toList();
  }

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
            width: showBoxes ? 90 : 36,
            height: showBoxes ? 60 : 36,
            child: GestureDetector(
              onTap: () => bloc.add(SelectContact(f)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.rotate(
                    angle: f.headingDeg * (math.pi / 180.0),
                    child: Icon(
                      f.isMilitary ? Icons.airplanemode_active : Icons.flight,
                      color: iconColor,
                      size: isSelected ? 26 : 20,
                    ),
                  ),
                  if (showBoxes)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        border: Border.all(
                            color: iconColor.withValues(alpha: 0.8), width: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        '${f.callsign}\n${f.altitudeFt.toInt()}FT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: iconColor,
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

    // 2. Satellites
    if (state.activeLayers.contains(GeointLayer.satellites)) {
      for (final s in state.satellites) {
        final isSelected = state.selectedContact?.id == s.id;
        markers.add(
          Marker(
            point: s.position,
            width: showBoxes ? 90 : 36,
            height: showBoxes ? 50 : 36,
            child: GestureDetector(
              onTap: () => bloc.add(SelectContact(s)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isSelected
                              ? const Color(0xFFFFD600)
                              : const Color(0xFF00E5FF),
                          width: 1.5),
                    ),
                    child: Icon(
                      Icons.satellite_alt,
                      color: isSelected
                          ? const Color(0xFFFFD600)
                          : const Color(0xFF00E5FF),
                      size: 16,
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
                            color: const Color(0xFF00E5FF), width: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        'SAT: ${s.noradId}',
                        style: const TextStyle(
                          color: Color(0xFF00E5FF),
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
                      color: isSelected
                          ? const Color(0xFFFFD600)
                          : const Color(0xFF26A69A),
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
                            color: const Color(0xFF26A69A), width: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        'VSL: ${v.speedKnots}KT',
                        style: const TextStyle(
                          color: Color(0xFF26A69A),
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
