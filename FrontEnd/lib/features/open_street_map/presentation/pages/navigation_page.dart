import 'dart:async';
import 'dart:math';

import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:dbnus/features/open_street_map/domain/entities/route_info.dart';
import 'package:dbnus/features/open_street_map/presentation/widget/navigation_arrow_painter.dart';
import 'package:dbnus/features/open_street_map/presentation/widget/navigation_overlay.dart';

/// Full-screen live GPS navigation page.
/// Receives a [RouteInfo] and tracks user position along the route.
class NavigationPage extends StatefulWidget {
  final RouteInfo routeInfo;

  const NavigationPage({super.key, required this.routeInfo});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final MapController _mapController = MapController();
  final Distance _distanceCalc = const Distance();

  // Navigation state
  int _navCurrentIndex = 0;
  LatLng? _navCurrentPosition;
  double _navRemainingKm = 0;
  double _navRemainingMin = 0;
  double _navSpeed = 0;
  double _navHeading = 0;
  int _navCurrentStepIndex = 0;
  StreamSubscription<Position>? _positionStream;
  bool _arrived = false;

  List<LatLng> get _points => widget.routeInfo.polylinePoints;

  @override
  void initState() {
    super.initState();
    _navCurrentPosition = _points.first;
    _navRemainingKm = widget.routeInfo.distanceKm;
    _navRemainingMin = widget.routeInfo.durationMinutes;
    _startListening();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  // ── GPS Streaming ──────────────────────────────────────

  Future<void> _startListening() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Location permission needed for navigation')),
            );
            Navigator.pop(context);
          }
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Location permission permanently denied')),
          );
          Navigator.pop(context);
        }
        return;
      }
    } catch (e) {
      AppLog.e('Permission error: $e');
    }

    _mapController.move(_points.first, 16);

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen(
      _onPositionUpdate,
      onError: (e) => AppLog.e('Location stream error: $e'),
    );
  }

  void _onPositionUpdate(Position position) {
    if (!mounted || _arrived) return;
    final currentLatLng = LatLng(position.latitude, position.longitude);

    // Find closest point on route
    int closestIndex = _navCurrentIndex;
    double closestDist = double.infinity;
    final searchEnd = min(_points.length, _navCurrentIndex + 50);
    for (int i = _navCurrentIndex; i < searchEnd; i++) {
      final d = _distanceCalc.as(LengthUnit.Meter, currentLatLng, _points[i]);
      if (d < closestDist) {
        closestDist = d;
        closestIndex = i;
      }
    }

    // Remaining distance
    double remainingMeters = 0;
    for (int i = closestIndex; i < _points.length - 1; i++) {
      remainingMeters +=
          _distanceCalc.as(LengthUnit.Meter, _points[i], _points[i + 1]);
    }
    final remainingKm = remainingMeters / 1000;

    // Speed (m/s → km/h)
    final speedKmh = (position.speed >= 0 ? position.speed : 0) * 3.6;

    // ETA
    final etaMin =
        speedKmh > 1 ? (remainingKm / speedKmh) * 60 : _navRemainingMin;

    // Heading: prefer GPS heading, fallback to bearing along route
    double heading = _navHeading;
    if (position.heading != 0 && position.heading.isFinite) {
      heading = position.heading;
    } else if (closestIndex < _points.length - 1) {
      heading = _distanceCalc.bearing(
          _points[closestIndex], _points[closestIndex + 1]);
    }

    // Determine current step
    int currentStepIdx = _navCurrentStepIndex;
    final steps = widget.routeInfo.steps;
    if (steps.isNotEmpty) {
      for (int i = currentStepIdx; i < steps.length; i++) {
        if (steps[i].waypointIndex > closestIndex) {
          currentStepIdx = max(0, i - 1);
          break;
        }
        if (i == steps.length - 1) currentStepIdx = i;
      }
    }

    setState(() {
      _navCurrentIndex = closestIndex;
      _navCurrentPosition = currentLatLng;
      _navRemainingKm = remainingKm;
      _navRemainingMin = etaMin;
      _navSpeed = speedKmh;
      _navHeading = heading;
      _navCurrentStepIndex = currentStepIdx;
    });

    _mapController.move(currentLatLng, 17);
    _mapController.rotate(-heading);

    // Arrival check (within 50m)
    final distToDest =
        _distanceCalc.as(LengthUnit.Meter, currentLatLng, _points.last);
    if (distToDest < 50) {
      _positionStream?.cancel();
      setState(() => _arrived = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have arrived at your destination!'),
          backgroundColor: Color(0xFF34A853),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  // ── Deep Blue Tile Tint ─────────────────────────────────

  Widget _deepBlueTileBuilder(
      BuildContext context, Widget tileWidget, TileImage tile) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.3, 0, 0, 0, 0, // R: dim
        0, 0.3, 0, 0, 0, // G: dim
        0, 0, 0.3, 0, 0, // B: dim
        0, 0, 0, 1, 0, // A: keep alpha
      ]),
      child: tileWidget,
    );
  }

  void _stopNavigation() {
    _positionStream?.cancel();
    _mapController.rotate(0);
    Navigator.pop(context);
  }

  // ── Build ──────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final steps = widget.routeInfo.steps;
    final hasStep = steps.isNotEmpty &&
        _navCurrentStepIndex < steps.length;

    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _points.first,
              initialZoom: 16,
              backgroundColor: const Color(0xFF1A1A1A),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.dbnus.app',
                tileBuilder: _deepBlueTileBuilder,
              ),
              // Traveled portion (dimmed)
              if (_navCurrentIndex > 0)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _points.sublist(0, _navCurrentIndex + 1),
                      strokeWidth: 5,
                      color:
                          const Color(0xFF4285F4).withValues(alpha: 0.3),
                    ),
                  ],
                ),
              // Shadow polyline
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _points.sublist(_navCurrentIndex),
                    strokeWidth: 8,
                    color:
                        const Color(0xFF4285F4).withValues(alpha: 0.25),
                  ),
                ],
              ),
              // Main polyline
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _points.sublist(_navCurrentIndex),
                    strokeWidth: 5,
                    color: const Color(0xFF4285F4),
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // Navigation marker
                  if (_navCurrentPosition != null)
                    Marker(
                      point: _navCurrentPosition!,
                      width: 56,
                      height: 56,
                      child: Transform.rotate(
                        angle: _navHeading * pi / 180,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF4285F4)
                                    .withValues(alpha: 0.15),
                              ),
                            ),
                            CustomPaint(
                              size: const Size(40, 40),
                              painter: NavigationArrowPainter(
                                color: const Color(0xFF4285F4),
                                borderColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Destination marker
                  Marker(
                    point: _points.last,
                    width: 40,
                    height: 50,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEA4335),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEA4335)
                                    .withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.flag,
                              color: Colors.white, size: 16),
                        ),
                        Container(
                          width: 2,
                          height: 6,
                          color: const Color(0xFFEA4335),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
            ],
          ),

          // Navigation Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: NavigationOverlay(
              remainingDistanceKm: _navRemainingKm,
              remainingDurationMin: _navRemainingMin,
              speedKmh: _navSpeed,
              currentStep: _navCurrentIndex,
              totalSteps: _points.length,
              onStop: _stopNavigation,
              currentInstruction:
                  hasStep ? steps[_navCurrentStepIndex].instruction : null,
              nextInstruction: hasStep &&
                      _navCurrentStepIndex + 1 < steps.length
                  ? steps[_navCurrentStepIndex + 1].instruction
                  : null,
              maneuverType:
                  hasStep ? steps[_navCurrentStepIndex].maneuver : null,
              maneuverModifier:
                  hasStep ? steps[_navCurrentStepIndex].modifier : null,
              distanceToNextStepMeters: hasStep
                  ? steps[_navCurrentStepIndex].distanceMeters
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
