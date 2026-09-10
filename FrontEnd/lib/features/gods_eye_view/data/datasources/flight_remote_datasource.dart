import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';

abstract class FlightRemoteDataSource {
  Future<List<FlightContact>> fetchFlights();
  List<FlightContact> advanceFlights(List<FlightContact> flights, double dtSeconds);
}

class FlightRemoteDataSourceImpl implements FlightRemoteDataSource {
  final http.Client client;

  FlightRemoteDataSourceImpl({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<List<FlightContact>> fetchFlights() async {
    // OpenSky Network public API
    const url = 'https://opensky-network.org/api/states/all';

    try {
      final response = await client
          .get(Uri.parse(url), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final states = data['states'] as List<dynamic>? ?? [];

        final flights = <FlightContact>[];
        // Take up to 60 prominent flights to keep rendering performant and smooth
        for (final state in states.take(60)) {
          final s = state as List<dynamic>;
          final icao24 = s[0]?.toString() ?? 'N/A';
          final callsign = (s[1]?.toString() ?? 'UNKNOWN').trim();
          final lon = (s[5] as num?)?.toDouble();
          final lat = (s[6] as num?)?.toDouble();
          final altM = (s[7] as num?)?.toDouble() ?? 10000;
          final velocityMs = (s[9] as num?)?.toDouble() ?? 220;
          final track = (s[10] as num?)?.toDouble() ?? 90;
          final squawk = s[14]?.toString() ?? '7000';

          if (lat != null && lon != null) {
            final isMil = _isLikelyMilitary(callsign, squawk);
            flights.add(
              FlightContact(
                id: 'fl_$icao24',
                title: callsign.isNotEmpty ? callsign : icao24.toUpperCase(),
                position: LatLng(lat, lon),
                icao24: icao24,
                callsign: callsign.isNotEmpty ? callsign : 'FLIGHT-$icao24',
                model: isMil ? 'MQ-9 / RC-135' : _inferModel(callsign),
                altitudeFt: (altM * 3.28084).roundToDouble(),
                speedKnots: (velocityMs * 1.94384).roundToDouble(),
                headingDeg: track,
                origin: isMil ? 'CLASSIFIED' : 'ORIGIN',
                destination: isMil ? 'PATROL-SECTOR' : 'DEST',
                squawk: squawk,
                isMilitary: isMil,
                trail: [LatLng(lat, lon)],
              ),
            );
          }
        }

        if (flights.isNotEmpty) {
          return flights;
        }
      }
    } catch (_) {
      // Offline fallback
    }

    return _generateTacticalFleet();
  }

  bool _isLikelyMilitary(String callsign, String squawk) {
    final cs = callsign.toUpperCase();
    return cs.startsWith('RCH') ||
        cs.startsWith('VIPER') ||
        cs.startsWith('REAPER') ||
        cs.startsWith('FORTE') ||
        cs.startsWith('JAKE') ||
        cs.startsWith('NATO') ||
        squawk == '7700' ||
        squawk == '7600';
  }

  String _inferModel(String callsign) {
    final cs = callsign.toUpperCase();
    if (cs.startsWith('UAL') || cs.startsWith('DAL') || cs.startsWith('BAW')) {
      return 'Boeing 787-9';
    } else if (cs.startsWith('AAL') || cs.startsWith('AFR') || cs.startsWith('DLH')) {
      return 'Airbus A350-900';
    } else if (cs.startsWith('SWA') || cs.startsWith('RYR')) {
      return 'Boeing 737-MAX8';
    }
    return 'Airbus A320-neo';
  }

  List<FlightContact> _generateTacticalFleet() {
    return [
      FlightContact(
        id: 'fl_FORTE12',
        title: 'FORTE-12 (RQ-4B Global Hawk)',
        position: const LatLng(43.120, 31.850),
        icao24: 'ae5422',
        callsign: 'FORTE12',
        model: 'RQ-4B Global Hawk',
        altitudeFt: 52000,
        speedKnots: 340,
        headingDeg: 82,
        origin: 'Sigonella NAS',
        destination: 'Black Sea Recon Orbit',
        squawk: '0412',
        isMilitary: true,
        trail: [
          const LatLng(42.800, 30.200),
          const LatLng(43.000, 31.000),
          const LatLng(43.120, 31.850),
        ],
      ),
      FlightContact(
        id: 'fl_REAPER01',
        title: 'REAPER-01 (MQ-9A)',
        position: const LatLng(25.310, 56.890),
        icao24: 'ae1908',
        callsign: 'REAPER01',
        model: 'General Atomics MQ-9A',
        altitudeFt: 28000,
        speedKnots: 210,
        headingDeg: 145,
        origin: 'Al Dhafra AB',
        destination: 'Hormuz Surveillance',
        squawk: '4301',
        isMilitary: true,
        trail: [
          const LatLng(26.100, 56.100),
          const LatLng(25.700, 56.500),
          const LatLng(25.310, 56.890),
        ],
      ),
      FlightContact(
        id: 'fl_BAW178',
        title: 'BAW-178 (B787-9)',
        position: const LatLng(51.850, -28.400),
        icao24: '4007f3',
        callsign: 'BAW178',
        model: 'Boeing 787-9 Dreamliner',
        altitudeFt: 38000,
        speedKnots: 490,
        headingDeg: 105,
        origin: 'JFK (New York)',
        destination: 'LHR (London)',
        squawk: '2145',
        isMilitary: false,
        trail: [
          const LatLng(50.400, -35.200),
          const LatLng(51.200, -32.000),
          const LatLng(51.850, -28.400),
        ],
      ),
      FlightContact(
        id: 'fl_UAL881',
        title: 'UAL-881 (B777-300ER)',
        position: const LatLng(34.200, -150.400),
        icao24: 'a028dc',
        callsign: 'UAL881',
        model: 'Boeing 777-300ER',
        altitudeFt: 36000,
        speedKnots: 515,
        headingDeg: 280,
        origin: 'ORD (Chicago)',
        destination: 'HND (Tokyo)',
        squawk: '5230',
        isMilitary: false,
        trail: [
          const LatLng(35.500, -140.000),
          const LatLng(34.900, -145.000),
          const LatLng(34.200, -150.400),
        ],
      ),
      FlightContact(
        id: 'fl_DLH456',
        title: 'DLH-456 (A350-900)',
        position: const LatLng(48.350, 11.780),
        icao24: '3c65c2',
        callsign: 'DLH456',
        model: 'Airbus A350-900',
        altitudeFt: 18000,
        speedKnots: 310,
        headingDeg: 245,
        origin: 'MUC (Munich)',
        destination: 'LAX (Los Angeles)',
        squawk: '1200',
        isMilitary: false,
        trail: [
          const LatLng(48.500, 12.200),
          const LatLng(48.350, 11.780),
        ],
      ),
      FlightContact(
        id: 'fl_SIA321',
        title: 'SIA-321 (A380-800)',
        position: const LatLng(1.364, 103.991),
        icao24: '76a89b',
        callsign: 'SIA321',
        model: 'Airbus A380-800',
        altitudeFt: 32000,
        speedKnots: 480,
        headingDeg: 310,
        origin: 'SIN (Singapore)',
        destination: 'CDG (Paris)',
        squawk: '7112',
        isMilitary: false,
        trail: [
          const LatLng(0.800, 104.500),
          const LatLng(1.364, 103.991),
        ],
      ),
      FlightContact(
        id: 'fl_RCH414',
        title: 'RCH-414 (C-17 Globemaster)',
        position: const LatLng(36.120, 14.850),
        icao24: 'ae0804',
        callsign: 'RCH414',
        model: 'Boeing C-17A Globemaster III',
        altitudeFt: 31000,
        speedKnots: 440,
        headingDeg: 120,
        origin: 'Ramstein AB',
        destination: 'Al Udeid AB',
        squawk: '6211',
        isMilitary: true,
        trail: [
          const LatLng(37.500, 13.200),
          const LatLng(36.800, 14.000),
          const LatLng(36.120, 14.850),
        ],
      ),
      FlightContact(
        id: 'fl_JAL004',
        title: 'JAL-004 (A350-1000)',
        position: const LatLng(35.549, 139.779),
        icao24: '8692c1',
        callsign: 'JAL004',
        model: 'Airbus A350-1000',
        altitudeFt: 22000,
        speedKnots: 380,
        headingDeg: 45,
        origin: 'HND (Tokyo)',
        destination: 'JFK (New York)',
        squawk: '4451',
        isMilitary: false,
        trail: [
          const LatLng(34.800, 139.200),
          const LatLng(35.549, 139.779),
        ],
      ),
    ];
  }

  @override
  List<FlightContact> advanceFlights(List<FlightContact> flights, double dtSeconds) {
    return flights.map((f) {
      // Speed in knots to degrees lat/lon displacement
      // 1 knot ~ 1.852 km/h ~ 0.000277 deg/sec lat
      final headingRad = f.headingDeg * (math.pi / 180.0);
      final distKm = (f.speedKnots * 1.852 / 3600.0) * dtSeconds;

      final deltaLat = (distKm / 111.0) * math.cos(headingRad);
      final cosLat = math.cos(f.position.latitude * (math.pi / 180.0));
      final deltaLon = (distKm / (111.0 * (cosLat.abs() < 0.01 ? 0.01 : cosLat))) *
          math.sin(headingRad);

      var newLat = f.position.latitude + deltaLat;
      var newLon = f.position.longitude + deltaLon;

      // Wrap-around
      if (newLat > 85.0) newLat = -85.0;
      if (newLat < -85.0) newLat = 85.0;
      if (newLon > 180.0) newLon -= 360.0;
      if (newLon < -180.0) newLon += 360.0;

      final newPos = LatLng(newLat, newLon);
      final newTrail = List<LatLng>.from(f.trail);
      if (newTrail.length > 25) newTrail.removeAt(0);
      newTrail.add(newPos);

      return f.copyWith(
        position: newPos,
        trail: newTrail,
      );
    }).toList();
  }
}
