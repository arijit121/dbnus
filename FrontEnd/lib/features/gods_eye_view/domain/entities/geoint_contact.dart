import 'package:latlong2/latlong.dart';

enum GeointType {
  flight,
  militaryFlight,
  satellite,
  vessel,
  earthquake,
  cctv,
  infrastructure,
}

abstract class GeointContact {
  final String id;
  final String title;
  final LatLng position;
  final GeointType type;

  const GeointContact({
    required this.id,
    required this.title,
    required this.position,
    required this.type,
  });
}

/// Live Aircraft Telemetry
class FlightContact extends GeointContact {
  final String icao24;
  final String callsign;
  final String model;
  final double altitudeFt;
  final double speedKnots;
  final double headingDeg;
  final String origin;
  final String destination;
  final String squawk;
  final bool isMilitary;
  final List<LatLng> trail;

  FlightContact({
    required super.id,
    required super.title,
    required super.position,
    required this.icao24,
    required this.callsign,
    required this.model,
    required this.altitudeFt,
    required this.speedKnots,
    required this.headingDeg,
    this.origin = 'UNKNOWN',
    this.destination = 'UNKNOWN',
    this.squawk = '7000',
    this.isMilitary = false,
    this.trail = const [],
  }) : super(
          type: isMilitary ? GeointType.militaryFlight : GeointType.flight,
        );

  FlightContact copyWith({
    LatLng? position,
    double? headingDeg,
    double? speedKnots,
    double? altitudeFt,
    List<LatLng>? trail,
  }) {
    return FlightContact(
      id: id,
      title: title,
      position: position ?? this.position,
      icao24: icao24,
      callsign: callsign,
      model: model,
      altitudeFt: altitudeFt ?? this.altitudeFt,
      speedKnots: speedKnots ?? this.speedKnots,
      headingDeg: headingDeg ?? this.headingDeg,
      origin: origin,
      destination: destination,
      squawk: squawk,
      isMilitary: isMilitary,
      trail: trail ?? this.trail,
    );
  }
}

/// Satellites in Orbit
class SatelliteContact extends GeointContact {
  final String noradId;
  final String category; // Recon, Manned, Comms, Weather, Nav
  final double altitudeKm;
  final double velocityKmS;
  final double inclinationDeg;
  final List<LatLng> orbitPath;

  const SatelliteContact({
    required super.id,
    required super.title,
    required super.position,
    required this.noradId,
    required this.category,
    required this.altitudeKm,
    required this.velocityKmS,
    required this.inclinationDeg,
    this.orbitPath = const [],
  }) : super(type: GeointType.satellite);

  SatelliteContact copyWith({
    LatLng? position,
    List<LatLng>? orbitPath,
  }) {
    return SatelliteContact(
      id: id,
      title: title,
      position: position ?? this.position,
      noradId: noradId,
      category: category,
      altitudeKm: altitudeKm,
      velocityKmS: velocityKmS,
      inclinationDeg: inclinationDeg,
      orbitPath: orbitPath ?? this.orbitPath,
    );
  }
}

/// Maritime AIS Vessels
class VesselContact extends GeointContact {
  final String mmsi;
  final String vesselType; // Cargo, Tanker, Patrol, Carrier
  final double speedKnots;
  final double headingDeg;
  final String destination;
  final double draughtM;

  const VesselContact({
    required super.id,
    required super.title,
    required super.position,
    required this.mmsi,
    required this.vesselType,
    required this.speedKnots,
    required this.headingDeg,
    required this.destination,
    required this.draughtM,
  }) : super(type: GeointType.vessel);

  VesselContact copyWith({
    LatLng? position,
    double? headingDeg,
    double? speedKnots,
  }) {
    return VesselContact(
      id: id,
      title: title,
      position: position ?? this.position,
      mmsi: mmsi,
      vesselType: vesselType,
      speedKnots: speedKnots ?? this.speedKnots,
      headingDeg: headingDeg ?? this.headingDeg,
      destination: destination,
      draughtM: draughtM,
    );
  }
}

/// USGS Live Earthquake
class EarthquakeContact extends GeointContact {
  final double magnitude;
  final double depthKm;
  final DateTime timestamp;
  final String alertLevel; // green, yellow, orange, red

  const EarthquakeContact({
    required super.id,
    required super.title,
    required super.position,
    required this.magnitude,
    required this.depthKm,
    required this.timestamp,
    this.alertLevel = 'green',
  }) : super(type: GeointType.earthquake);
}

/// Projected Public CCTV Node
class CctvCameraContact extends GeointContact {
  final String city;
  final String cameraName;
  final String snapshotUrl;
  final double bearingDeg;
  final double fovDeg;

  const CctvCameraContact({
    required super.id,
    required super.title,
    required super.position,
    required this.city,
    required this.cameraName,
    required this.snapshotUrl,
    required this.bearingDeg,
    this.fovDeg = 65.0,
  }) : super(type: GeointType.cctv);
}

/// Critical Infrastructure (Undersea cables, datacenters, dams)
class InfrastructureContact extends GeointContact {
  final String category; // Cable, Datacenter, Dam, Naval Base
  final String details;
  final String capacity;

  const InfrastructureContact({
    required super.id,
    required super.title,
    required super.position,
    required this.category,
    required this.details,
    this.capacity = 'N/A',
  }) : super(type: GeointType.infrastructure);
}
