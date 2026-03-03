import 'package:dbnus/features/open_street_map/domain/entities/route_info.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:latlong2/latlong.dart';

class RouteInfoModel extends RouteInfo {
  RouteInfoModel({
    required super.polylinePoints,
    required super.distanceKm,
    required super.durationMinutes,
    super.summary,
  });

  factory RouteInfoModel.fromJson(Map<String, dynamic> json) {
    try {
      final route = json['routes']?[0];
      if (route == null) {
        return RouteInfoModel(
          polylinePoints: [],
          distanceKm: 0,
          durationMinutes: 0,
        );
      }

      final geometry = route['geometry'];
      final coords = geometry['coordinates'] as List;
      final points = coords
          .map(
              (c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
          .toList();

      final distance = (route['distance'] as num).toDouble() / 1000;
      final duration = (route['duration'] as num).toDouble() / 60;
      final summary = route['summary'] as String?;

      return RouteInfoModel(
        polylinePoints: points,
        distanceKm: distance,
        durationMinutes: duration,
        summary: summary,
      );
    } catch (e, s) {
      AppLog.e(e.toString(), stackTrace: s);
      return RouteInfoModel(
        polylinePoints: [],
        distanceKm: 0,
        durationMinutes: 0,
      );
    }
  }
}
