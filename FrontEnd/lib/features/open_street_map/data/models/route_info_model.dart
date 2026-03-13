import 'package:dbnus/features/open_street_map/domain/entities/route_info.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:latlong2/latlong.dart';

class RouteInfoModel extends RouteInfo {
  RouteInfoModel({
    required super.polylinePoints,
    required super.distanceKm,
    required super.durationMinutes,
    super.summary,
    super.steps,
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

      // Parse turn-by-turn steps from OSRM
      final List<RouteStep> parsedSteps = [];
      final legs = route['legs'] as List?;
      if (legs != null && legs.isNotEmpty) {
        int cumulativeWaypointIndex = 0;
        for (final leg in legs) {
          final stepsJson = leg['steps'] as List? ?? [];
          for (final step in stepsJson) {
            final maneuver = step['maneuver'] as Map<String, dynamic>? ?? {};
            final maneuverType = maneuver['type'] as String? ?? 'unknown';
            final modifier = maneuver['modifier'] as String?;

            // Build instruction from OSRM step data
            final stepName = step['name'] as String? ?? '';
            final stepDistance =
                (step['distance'] as num?)?.toDouble() ?? 0.0;

            String instruction = _buildInstruction(
                maneuverType, modifier, stepName);

            parsedSteps.add(RouteStep(
              maneuver: maneuverType,
              modifier: modifier,
              instruction: instruction,
              distanceMeters: stepDistance,
              waypointIndex: cumulativeWaypointIndex,
            ));

            // Count coordinates in this step's geometry to advance waypointIndex
            final stepGeometry = step['geometry'] as Map<String, dynamic>?;
            if (stepGeometry != null) {
              final stepCoords =
                  stepGeometry['coordinates'] as List? ?? [];
              // Subtract 1 because the last coord of one step = first of next
              cumulativeWaypointIndex +=
                  stepCoords.length > 1 ? stepCoords.length - 1 : 0;
            }
          }
        }
      }

      return RouteInfoModel(
        polylinePoints: points,
        distanceKm: distance,
        durationMinutes: duration,
        summary: summary,
        steps: parsedSteps,
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

  static String _buildInstruction(
      String type, String? modifier, String name) {
    final road = name.isNotEmpty ? name : 'the road';
    switch (type) {
      case 'depart':
        return 'Head towards $road';
      case 'arrive':
        return 'Arrive at your destination';
      case 'turn':
        final dir = _modifierToDirection(modifier);
        return 'Turn $dir onto $road';
      case 'new name':
        return 'Continue onto $road';
      case 'merge':
        final dir = _modifierToDirection(modifier);
        return 'Merge $dir onto $road';
      case 'on ramp':
      case 'off ramp':
        final dir = _modifierToDirection(modifier);
        return 'Take the ramp $dir onto $road';
      case 'fork':
        final dir = _modifierToDirection(modifier);
        return 'Keep $dir onto $road';
      case 'end of road':
        final dir = _modifierToDirection(modifier);
        return 'Turn $dir onto $road';
      case 'roundabout':
      case 'rotary':
        return 'Enter the roundabout towards $road';
      case 'continue':
        return 'Continue on $road';
      default:
        if (modifier != null) {
          return '${_modifierToDirection(modifier).capitalize()} towards $road';
        }
        return 'Continue towards $road';
    }
  }

  static String _modifierToDirection(String? modifier) {
    switch (modifier) {
      case 'left':
        return 'left';
      case 'right':
        return 'right';
      case 'slight left':
        return 'slight left';
      case 'slight right':
        return 'slight right';
      case 'sharp left':
        return 'sharp left';
      case 'sharp right':
        return 'sharp right';
      case 'straight':
        return 'straight';
      case 'uturn':
        return 'U-turn';
      default:
        return 'ahead';
    }
  }
}

extension _StringCapitalize on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

