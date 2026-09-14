import 'package:latlong2/latlong.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';

abstract class SpaceLaunchDataSource {
  List<SpaceLaunchContact> getSpaceLaunches();
  List<CinematicTour> getCinematicTours();
}

class SpaceLaunchDataSourceImpl implements SpaceLaunchDataSource {
  @override
  List<SpaceLaunchContact> getSpaceLaunches() {
    return [
      SpaceLaunchContact(
        id: 'launch_ksc_39a',
        title: 'FALCON 9 // STARLINK GROUP 12-4',
        position: const LatLng(28.608, -80.604),
        missionName: 'Starlink Group 12-4 (54 Satellites)',
        vehicle: 'Falcon 9 Block 5',
        operatorName: 'SpaceX',
        site: 'Kennedy Space Center, LC-39A, Florida',
        azimuthDeg: 53.0,
        status: 'T-MINUS 00:14:22',
        trajectoryPoints: const [
          LatLng(28.608, -80.604),
          LatLng(29.800, -78.400),
          LatLng(32.100, -74.200),
          LatLng(35.500, -68.000),
          LatLng(40.200, -56.000),
          LatLng(45.000, -40.000),
        ],
      ),
      SpaceLaunchContact(
        id: 'launch_starbase_pad_a',
        title: 'STARSHIP // INTEGRATED FLIGHT TEST',
        position: const LatLng(25.997, -97.156),
        missionName: 'Starship Orbital Demonstration',
        vehicle: 'Starship / Super Heavy Booster',
        operatorName: 'SpaceX',
        site: 'Starbase Orbital Pad A, Boca Chica, Texas',
        azimuthDeg: 95.0,
        status: 'PROPELLANT LOAD IN PROGRESS',
        trajectoryPoints: const [
          LatLng(25.997, -97.156),
          LatLng(25.900, -94.500),
          LatLng(25.600, -90.000),
          LatLng(24.800, -82.000),
          LatLng(23.200, -70.000),
          LatLng(21.000, -55.000),
        ],
      ),
      SpaceLaunchContact(
        id: 'launch_vandenberg_slc4e',
        title: 'FALCON 9 // NROL-186 RECON',
        position: const LatLng(34.632, -120.611),
        missionName: 'NROL-186 Classified Optical Recon',
        vehicle: 'Falcon 9 FT',
        operatorName: 'National Reconnaissance Office (NRO)',
        site: 'Vandenberg Space Force Base, SLC-4E, California',
        azimuthDeg: 190.0,
        status: 'STAGE 2 SEPARATION // POLAR ASCENT',
        trajectoryPoints: const [
          LatLng(34.632, -120.611),
          LatLng(30.200, -121.500),
          LatLng(24.000, -122.800),
          LatLng(15.000, -124.000),
          LatLng(0.000, -125.500),
          LatLng(-20.000, -127.000),
        ],
      ),
      SpaceLaunchContact(
        id: 'launch_baikonur_site31',
        title: 'SOYUZ-2.1A // PROGRESS MS-28',
        position: const LatLng(45.996, 63.564),
        missionName: 'Progress MS-28 ISS Resupply',
        vehicle: 'Soyuz-2.1a',
        operatorName: 'Roscosmos',
        site: 'Baikonur Cosmodrome Site 31/6, Kazakhstan',
        azimuthDeg: 64.0,
        status: 'ORBIT INSERTION CONFIRMED',
        trajectoryPoints: const [
          LatLng(45.996, 63.564),
          LatLng(48.200, 68.400),
          LatLng(51.000, 76.000),
          LatLng(53.400, 86.000),
          LatLng(54.200, 100.000),
        ],
      ),
      SpaceLaunchContact(
        id: 'launch_guiana_ela4',
        title: 'ARIANE 6 // COPERNICUS SENTINEL',
        position: const LatLng(5.239, -52.768),
        missionName: 'Copernicus Earth Observation',
        vehicle: 'Ariane 62',
        operatorName: 'European Space Agency (ESA) / Arianespace',
        site: 'Guiana Space Centre ELA-4, Kourou, French Guiana',
        azimuthDeg: 80.0,
        status: 'TERMINAL COUNTDOWN',
        trajectoryPoints: const [
          LatLng(5.239, -52.768),
          LatLng(6.100, -48.000),
          LatLng(7.500, -40.000),
          LatLng(9.200, -30.000),
          LatLng(11.000, -18.000),
        ],
      ),
    ];
  }

  @override
  List<CinematicTour> getCinematicTours() {
    return const [
      CinematicTour(
        id: 'tour_orbital_watch',
        name: 'ORBITAL WATCH // SPACE CADENCE',
        description: 'Global low-Earth orbit sweep tracking active stations, recon constellations, and spaceports.',
        waypoints: [
          TourWaypoint(
            title: 'KENNEDY SPACE CENTER // CAPE CANAVERAL',
            subtitle: 'Active spaceport telemetry and orbital ascent corridors.',
            position: LatLng(28.608, -80.604),
            zoom: 8.5,
            durationSeconds: 6,
          ),
          TourWaypoint(
            title: 'ISS OVER THE MEDITERRANEAN',
            subtitle: 'International Space Station orbital ground track intersecting Europe.',
            position: LatLng(41.9028, 12.4964),
            zoom: 5.5,
            durationSeconds: 6,
          ),
          TourWaypoint(
            title: 'BAIKONUR COSMODROME // EURASIAN STEPPE',
            subtitle: 'Soyuz orbital ascent trajectory heading northeast toward 51.6 deg inclination.',
            position: LatLng(45.996, 63.564),
            zoom: 7.0,
            durationSeconds: 6,
          ),
          TourWaypoint(
            title: 'STARBASE ORBITAL LAUNCH COMPLEX // BOCA CHICA',
            subtitle: 'Super Heavy booster flight test pad and Gulf of Mexico launch corridor.',
            position: LatLng(25.997, -97.156),
            zoom: 9.0,
            durationSeconds: 6,
          ),
        ],
      ),
      CinematicTour(
        id: 'tour_ring_of_fire',
        name: 'PACIFIC RING OF FIRE // SEISMIC CORRIDOR',
        description: 'Tectonic boundary surveillance across global earthquake hotbeds and volcanic trenches.',
        waypoints: [
          TourWaypoint(
            title: 'JAPAN TRENCH // HONSHU OFFSHORE',
            subtitle: 'Subduction seismic zone with active M6+ events recorded.',
            position: LatLng(38.297, 142.372),
            zoom: 6.8,
            durationSeconds: 6,
          ),
          TourWaypoint(
            title: 'JAVA TRENCH // SUNDA SUBDUCTION',
            subtitle: 'High-density mantle deformation zone near Indonesian archipelago.',
            position: LatLng(-8.452, 114.281),
            zoom: 6.5,
            durationSeconds: 6,
          ),
          TourWaypoint(
            title: 'SAN ANDREAS FAULT // CALIFORNIA',
            subtitle: 'Transform plate boundary with shallow strike-slip seismic monitoring.',
            position: LatLng(35.912, -120.485),
            zoom: 7.2,
            durationSeconds: 6,
          ),
          TourWaypoint(
            title: 'KERMADEC TRENCH // NEW ZEALAND',
            subtitle: 'Deep-ocean seismic fault line extending northeast of North Island.',
            position: LatLng(-29.845, -177.124),
            zoom: 6.0,
            durationSeconds: 6,
          ),
        ],
      ),
      CinematicTour(
        id: 'tour_transatlantic_corridor',
        name: 'TRANSATLANTIC AIR HIGHWAY // NAT TRACKS',
        description: 'Follow the intercontinental jet stream corridor connecting North America and Western Europe.',
        waypoints: [
          TourWaypoint(
            title: 'LONDON HEATHROW (EGLL) // EUROPEAN HUB',
            subtitle: 'Air traffic control sector departure hub into Shanwick Oceanic.',
            position: LatLng(51.470, -0.454),
            zoom: 9.5,
            durationSeconds: 6,
          ),
          TourWaypoint(
            title: 'MID-ATLANTIC OCEANIC // FL380 CRUISE',
            subtitle: 'North Atlantic Tracks high-altitude crossing at 490 knots.',
            position: LatLng(51.850, -28.400),
            zoom: 5.5,
            durationSeconds: 6,
          ),
          TourWaypoint(
            title: 'NEW YORK METROPOLITAN // JFK SECTOR',
            subtitle: 'Terminal radar approach control descent into New York airspace.',
            position: LatLng(40.641, -73.778),
            zoom: 9.0,
            durationSeconds: 6,
          ),
        ],
      ),
      CinematicTour(
        id: 'tour_capital_citadels',
        name: 'CAPITAL CITADELS // STRATEGIC NODES',
        description: 'Direct aerial intelligence passes over world command centers and financial capitals.',
        waypoints: [
          TourWaypoint(
            title: 'WASHINGTON D.C. // NATIONAL RECON',
            subtitle: 'Federal district, Potomac corridor, and Pentagon strategic sector.',
            position: LatLng(38.8951, -77.0364),
            zoom: 11.5,
            durationSeconds: 6,
          ),
          TourWaypoint(
            title: 'LONDON METROPOLIS // THAMES RADAR',
            subtitle: 'Westminster, the City, and London CCTV coverage network.',
            position: LatLng(51.5074, -0.1278),
            zoom: 11.5,
            durationSeconds: 6,
          ),
          TourWaypoint(
            title: 'PARIS // ILE-DE-FRANCE SECTOR',
            subtitle: 'Central European telecommunications and transport crossroads.',
            position: LatLng(48.8566, 2.3522),
            zoom: 11.5,
            durationSeconds: 6,
          ),
          TourWaypoint(
            title: 'TOKYO SHINJUKU // ASIA-PACIFIC PACER',
            subtitle: 'High-density urban sensors, Bay surveillance, and Haneda approaches.',
            position: LatLng(35.6762, 139.6503),
            zoom: 11.5,
            durationSeconds: 6,
          ),
        ],
      ),
    ];
  }
}
