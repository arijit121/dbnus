import 'dart:math' as math;
import 'package:latlong2/latlong.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';

abstract class GeointStaticDataSource {
  List<SatelliteContact> getSatellites();
  List<SatelliteContact> advanceSatellites(
      List<SatelliteContact> satellites, double dtSeconds);
  List<VesselContact> getVessels();
  List<VesselContact> advanceVessels(
      List<VesselContact> vessels, double dtSeconds);
  List<CctvCameraContact> getCctvCameras();
  List<InfrastructureContact> getInfrastructure();
}

class GeointStaticDataSourceImpl implements GeointStaticDataSource {
  @override
  List<SatelliteContact> getSatellites() {
    return [
      SatelliteContact(
        id: 'sat_25544',
        title: 'ISS (ZARYA) - NORAD 25544',
        position: const LatLng(51.64, -0.12),
        noradId: '25544',
        category: 'Manned Station',
        altitudeKm: 418.2,
        velocityKmS: 7.66,
        inclinationDeg: 51.64,
        orbitPath: _generateOrbitGroundTrack(51.64, -0.12),
      ),
      SatelliteContact(
        id: 'sat_20580',
        title: 'HUBBLE SPACE TELESCOPE - NORAD 20580',
        position: const LatLng(28.47, -80.52),
        noradId: '20580',
        category: 'Science / Recon',
        altitudeKm: 535.0,
        velocityKmS: 7.59,
        inclinationDeg: 28.47,
        orbitPath: _generateOrbitGroundTrack(28.47, -80.52),
      ),
      SatelliteContact(
        id: 'sat_48274',
        title: 'USA-314 (KH-11 KENNEN Recon)',
        position: const LatLng(72.10, 45.30),
        noradId: '48274',
        category: 'Optical Reconnaissance (GEOINT)',
        altitudeKm: 285.4,
        velocityKmS: 7.74,
        inclinationDeg: 97.9,
        orbitPath: _generateOrbitGroundTrack(72.10, 45.30),
      ),
      SatelliteContact(
        id: 'sat_STARLINK_3012',
        title: 'STARLINK-3012 - NORAD 51421',
        position: const LatLng(-34.60, 150.80),
        noradId: '51421',
        category: 'Communications Mega-Constellation',
        altitudeKm: 550.0,
        velocityKmS: 7.58,
        inclinationDeg: 53.2,
        orbitPath: _generateOrbitGroundTrack(-34.60, 150.80),
      ),
      SatelliteContact(
        id: 'sat_GPS_III',
        title: 'NAVSTAR GPS-78 (USA-304)',
        position: const LatLng(15.20, -110.40),
        noradId: '45854',
        category: 'Navigation & Positioning',
        altitudeKm: 20180.0,
        velocityKmS: 3.87,
        inclinationDeg: 55.0,
        orbitPath: _generateOrbitGroundTrack(15.20, -110.40),
      ),
    ];
  }

  static List<LatLng> _generateOrbitGroundTrack(double inc, double startLon) {
    final points = <LatLng>[];
    for (int i = 0; i < 360; i += 6) {
      final rad = i * (math.pi / 180.0);
      final lat = inc * math.sin(rad);
      var lon = startLon + i;
      while (lon > 180.0) {
        lon -= 360.0;
      }
      while (lon < -180.0) {
        lon += 360.0;
      }
      points.add(LatLng(lat, lon));
    }
    return points;
  }

  @override
  List<SatelliteContact> advanceSatellites(
      List<SatelliteContact> satellites, double dtSeconds) {
    return satellites.map((s) {
      // Orbital speed: ~7.6 km/s -> ~0.068 degrees longitude per second
      final degPerSec = (s.velocityKmS / 111.0) * (360.0 / 40075.0) * 100.0;
      var newLon = s.position.longitude + (degPerSec * dtSeconds);
      if (newLon > 180.0) newLon -= 360.0;

      final rad = (newLon * (math.pi / 180.0)) * 1.5;
      final newLat = (s.inclinationDeg * math.sin(rad)).clamp(-85.0, 85.0);

      return s.copyWith(
        position: LatLng(newLat, newLon),
      );
    }).toList();
  }

  @override
  List<VesselContact> getVessels() {
    return const [
      VesselContact(
        id: 'vsl_EVERGIVEN',
        title: 'EVER GIVEN (Ultra Large Container)',
        position: LatLng(30.012, 32.551),
        mmsi: '353136000',
        vesselType: 'Container Ship (20,124 TEU)',
        speedKnots: 11.2,
        headingDeg: 165.0,
        destination: 'ROTTERDAM',
        draughtM: 14.5,
      ),
      VesselContact(
        id: 'vsl_PACIFIC_VOYAGER',
        title: 'PACIFIC VOYAGER (VLCC Crude Carrier)',
        position: LatLng(26.150, 56.240),
        mmsi: '538006741',
        vesselType: 'Super-Tanker (VLCC)',
        speedKnots: 13.8,
        headingDeg: 210.0,
        destination: 'SINGAPORE',
        draughtM: 20.8,
      ),
      VesselContact(
        id: 'vsl_MAERSK_MCKINNEY',
        title: 'MAERSK MC-KINNEY MOLLER',
        position: LatLng(1.230, 103.810),
        mmsi: '219018271',
        vesselType: 'Triple-E Container Ship',
        speedKnots: 14.2,
        headingDeg: 295.0,
        destination: 'SUEZ CANAL',
        draughtM: 15.2,
      ),
      VesselContact(
        id: 'vsl_USNS_COMFORT',
        title: 'USNS COMFORT (T-AH-20)',
        position: LatLng(36.940, -76.320),
        mmsi: '368884000',
        vesselType: 'Hospital Ship / Naval Auxiliary',
        speedKnots: 9.5,
        headingDeg: 80.0,
        destination: 'NORFOLK NAVAL BASE',
        draughtM: 10.0,
      ),
      VesselContact(
        id: 'vsl_CMA_CGM_JULES',
        title: 'CMA CGM JULES VERNE',
        position: LatLng(33.720, -118.260),
        mmsi: '228032900',
        vesselType: 'Container Vessel',
        speedKnots: 6.8,
        headingDeg: 340.0,
        destination: 'PORT OF LOS ANGELES',
        draughtM: 13.8,
      ),
    ];
  }

  @override
  List<VesselContact> advanceVessels(
      List<VesselContact> vessels, double dtSeconds) {
    return vessels.map((v) {
      final headingRad = v.headingDeg * (math.pi / 180.0);
      final distKm = (v.speedKnots * 1.852 / 3600.0) * dtSeconds;
      final deltaLat = (distKm / 111.0) * math.cos(headingRad);
      final deltaLon = (distKm / 111.0) * math.sin(headingRad);

      var newLat = v.position.latitude + deltaLat;
      var newLon = v.position.longitude + deltaLon;
      if (newLat > 85.0) newLat = -85.0;
      if (newLat < -85.0) newLat = 85.0;
      if (newLon > 180.0) newLon -= 360.0;
      if (newLon < -180.0) newLon += 360.0;

      return v.copyWith(
        position: LatLng(newLat, newLon),
      );
    }).toList();
  }

  @override
  List<CctvCameraContact> getCctvCameras() {
    return const [
      CctvCameraContact(
        id: 'cctv_lon_01',
        title: 'TfL CAM 04/112 - Westminster Bridge',
        position: LatLng(51.5007, -0.1246),
        city: 'London, UK',
        cameraName: 'Westminster / Houses of Parliament',
        snapshotUrl:
            'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=600&auto=format&fit=crop&q=80',
        bearingDeg: 120.0,
        fovDeg: 75.0,
      ),
      CctvCameraContact(
        id: 'cctv_lon_02',
        title: 'TfL CAM 09/081 - Piccadilly Circus',
        position: LatLng(51.5101, -0.1340),
        city: 'London, UK',
        cameraName: 'Piccadilly Circus North Approach',
        snapshotUrl:
            'https://images.unsplash.com/photo-1520986606214-8b456906c813?w=600&auto=format&fit=crop&q=80',
        bearingDeg: 215.0,
        fovDeg: 68.0,
      ),
      CctvCameraContact(
        id: 'cctv_atx_01',
        title: 'Austin DOT - Congress Ave & 11th St',
        position: LatLng(30.2747, -97.7404),
        city: 'Austin, TX',
        cameraName: 'Texas State Capitol South Lawn',
        snapshotUrl:
            'https://images.unsplash.com/photo-1531218150217-54595bc2b934?w=600&auto=format&fit=crop&q=80',
        bearingDeg: 0.0,
        fovDeg: 70.0,
      ),
      CctvCameraContact(
        id: 'cctv_sfo_01',
        title: 'Caltrans District 4 - Golden Gate Bridge Toll',
        position: LatLng(37.8199, -122.4783),
        city: 'San Francisco, CA',
        cameraName: 'US-101 Northbound Toll Plaza',
        snapshotUrl:
            'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=600&auto=format&fit=crop&q=80',
        bearingDeg: 350.0,
        fovDeg: 62.0,
      ),
      CctvCameraContact(
        id: 'cctv_tok_01',
        title: 'Tokyo Metropolitan - Shibuya Crossing',
        position: LatLng(35.6595, 139.7004),
        city: 'Tokyo, Japan',
        cameraName: 'Hachiko Square Scramble',
        snapshotUrl:
            'https://images.unsplash.com/photo-1542051841857-5f90071e7989?w=600&auto=format&fit=crop&q=80',
        bearingDeg: 280.0,
        fovDeg: 80.0,
      ),
    ];
  }

  @override
  List<InfrastructureContact> getInfrastructure() {
    return const [
      InfrastructureContact(
        id: 'inf_cable_tat14',
        title: 'TAT-14 Undersea Cable Landing',
        position: LatLng(50.828, -0.139),
        category: 'Submarine Fiber Optic Cable',
        details: 'Transatlantic 15,000 km optical link (Bude / Katwijk / Norden)',
        capacity: '3.2 Terabits/sec',
      ),
      InfrastructureContact(
        id: 'inf_cable_pacific',
        title: 'Pacific Light Cable Network (PLCN)',
        position: LatLng(33.740, -118.280),
        category: 'Submarine Fiber Optic Cable',
        details: '12,800 km trans-Pacific ultra-high bandwidth cable system',
        capacity: '144 Terabits/sec',
      ),
      InfrastructureContact(
        id: 'inf_dam_threegorges',
        title: 'Three Gorges Hydroelectric Dam',
        position: LatLng(30.823, 111.003),
        category: 'Strategic Hydroelectric Dam',
        details: 'World largest power station across the Yangtze River',
        capacity: '22,500 MW generating capacity',
      ),
      InfrastructureContact(
        id: 'inf_dam_hoover',
        title: 'Hoover Dam / Lake Mead',
        position: LatLng(36.016, -114.737),
        category: 'Strategic Hydroelectric Dam',
        details: 'Colorado River water management and hydroelectric generation',
        capacity: '2,080 MW generating capacity',
      ),
      InfrastructureContact(
        id: 'inf_dc_ashburn',
        title: 'Ashburn Data Center Alley',
        position: LatLng(39.043, -77.487),
        category: 'Hyperscale Cloud Data Center Hub',
        details: 'Routes ~70% of the world daily internet traffic',
        capacity: 'Over 25 Million sq ft compute footprint',
      ),
      InfrastructureContact(
        id: 'inf_base_diego_garcia',
        title: 'Camp Thunder Cove (Diego Garcia)',
        position: LatLng(-7.319, 72.422),
        category: 'Naval Support Facility & Bomber Forward Base',
        details: 'Joint US-UK strategic military hub in the central Indian Ocean',
        capacity: 'Deep-water fleet lagoon + 12,000 ft runway',
      ),
    ];
  }
}
