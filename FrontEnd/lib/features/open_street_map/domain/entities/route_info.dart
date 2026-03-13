import 'package:latlong2/latlong.dart';

class RouteStep {
  final String maneuver; // e.g., "turn", "depart", "arrive", "continue"
  final String? modifier; // e.g., "left", "right", "straight", "slight left"
  final String instruction; // Human-readable instruction
  final double distanceMeters;
  final int waypointIndex; // Index into polylinePoints

  RouteStep({
    required this.maneuver,
    this.modifier,
    required this.instruction,
    required this.distanceMeters,
    required this.waypointIndex,
  });
}

class RouteInfo {
  final List<LatLng> polylinePoints;
  final double distanceKm;
  final double durationMinutes;
  final String? summary;
  final List<RouteStep> steps;

  RouteInfo({
    required this.polylinePoints,
    required this.distanceKm,
    required this.durationMinutes,
    this.summary,
    this.steps = const [],
  });
}
