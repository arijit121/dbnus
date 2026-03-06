import 'package:latlong2/latlong.dart';

class RouteInfo {
  final List<LatLng> polylinePoints;
  final double distanceKm;
  final double durationMinutes;
  final String? summary;

  RouteInfo({
    required this.polylinePoints,
    required this.distanceKm,
    required this.durationMinutes,
    this.summary,
  });
}
