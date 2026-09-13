import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/sensor_mode.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_event.dart';

class GodsEyeViewState extends Equatable {
  final bool isLoading;
  final List<FlightContact> flights;
  final List<SatelliteContact> satellites;
  final List<VesselContact> vessels;
  final List<EarthquakeContact> earthquakes;
  final List<CctvCameraContact> cctvCameras;
  final List<InfrastructureContact> infrastructure;
  final List<WildfireContact> wildfires;
  final List<SpaceLaunchContact> spaceLaunches;
  final GeointContact? selectedContact;
  final SensorMode sensorMode;
  final Set<GeointLayer> activeLayers;
  final BasemapType basemap;
  final bool isCockpitMode;
  final bool isMeasureToolActive;
  final List<LatLng> measurementPoints;
  final double? measuredDistanceKm;
  final CinematicTour? activeTour;
  final int activeTourWaypointIndex;
  final LatLng cameraCenter;
  final double cameraZoom;
  final double cameraHeading;
  final String intelligenceSummary;
  final String? lastCommandFeedback;

  const GodsEyeViewState({
    this.isLoading = false,
    this.flights = const [],
    this.satellites = const [],
    this.vessels = const [],
    this.earthquakes = const [],
    this.cctvCameras = const [],
    this.infrastructure = const [],
    this.wildfires = const [],
    this.spaceLaunches = const [],
    this.selectedContact,
    this.sensorMode = SensorMode.normal,
    this.activeLayers = const {
      GeointLayer.flights,
      GeointLayer.military,
      GeointLayer.satellites,
      GeointLayer.vessels,
      GeointLayer.earthquakes,
      GeointLayer.cctv,
      GeointLayer.infrastructure,
      GeointLayer.wildfires,
      GeointLayer.spaceLaunches,
      GeointLayer.annotations,
      GeointLayer.detectionBoxes,
    },
    this.basemap = BasemapType.satellite,
    this.isCockpitMode = false,
    this.isMeasureToolActive = false,
    this.measurementPoints = const [],
    this.measuredDistanceKm,
    this.activeTour,
    this.activeTourWaypointIndex = 0,
    this.cameraCenter = const LatLng(25.0, 45.0), // Middle East / Mediterranean junction
    this.cameraZoom = 3.5,
    this.cameraHeading = 0.0,
    this.intelligenceSummary = 'SURVEILLANCE GRID ACTIVE // SECTOR GLOBAL',
    this.lastCommandFeedback,
  });

  int get totalActiveContacts =>
      (activeLayers.contains(GeointLayer.flights) ? flights.length : 0) +
      (activeLayers.contains(GeointLayer.satellites) ? satellites.length : 0) +
      (activeLayers.contains(GeointLayer.vessels) ? vessels.length : 0) +
      (activeLayers.contains(GeointLayer.earthquakes) ? earthquakes.length : 0) +
      (activeLayers.contains(GeointLayer.cctv) ? cctvCameras.length : 0) +
      (activeLayers.contains(GeointLayer.wildfires) ? wildfires.length : 0) +
      (activeLayers.contains(GeointLayer.spaceLaunches) ? spaceLaunches.length : 0) +
      (activeLayers.contains(GeointLayer.infrastructure)
          ? infrastructure.length
          : 0);

  GodsEyeViewState copyWith({
    bool? isLoading,
    List<FlightContact>? flights,
    List<SatelliteContact>? satellites,
    List<VesselContact>? vessels,
    List<EarthquakeContact>? earthquakes,
    List<CctvCameraContact>? cctvCameras,
    List<InfrastructureContact>? infrastructure,
    List<WildfireContact>? wildfires,
    List<SpaceLaunchContact>? spaceLaunches,
    GeointContact? selectedContact,
    bool clearSelectedContact = false,
    SensorMode? sensorMode,
    Set<GeointLayer>? activeLayers,
    BasemapType? basemap,
    bool? isCockpitMode,
    bool? isMeasureToolActive,
    List<LatLng>? measurementPoints,
    double? measuredDistanceKm,
    bool clearMeasuredDistance = false,
    CinematicTour? activeTour,
    bool clearActiveTour = false,
    int? activeTourWaypointIndex,
    LatLng? cameraCenter,
    double? cameraZoom,
    double? cameraHeading,
    String? intelligenceSummary,
    String? lastCommandFeedback,
  }) {
    return GodsEyeViewState(
      isLoading: isLoading ?? this.isLoading,
      flights: flights ?? this.flights,
      satellites: satellites ?? this.satellites,
      vessels: vessels ?? this.vessels,
      earthquakes: earthquakes ?? this.earthquakes,
      cctvCameras: cctvCameras ?? this.cctvCameras,
      infrastructure: infrastructure ?? this.infrastructure,
      wildfires: wildfires ?? this.wildfires,
      spaceLaunches: spaceLaunches ?? this.spaceLaunches,
      selectedContact: clearSelectedContact
          ? null
          : (selectedContact ?? this.selectedContact),
      sensorMode: sensorMode ?? this.sensorMode,
      activeLayers: activeLayers ?? this.activeLayers,
      basemap: basemap ?? this.basemap,
      isCockpitMode: isCockpitMode ?? this.isCockpitMode,
      isMeasureToolActive: isMeasureToolActive ?? this.isMeasureToolActive,
      measurementPoints: measurementPoints ?? this.measurementPoints,
      measuredDistanceKm: clearMeasuredDistance
          ? null
          : (measuredDistanceKm ?? this.measuredDistanceKm),
      activeTour: clearActiveTour ? null : (activeTour ?? this.activeTour),
      activeTourWaypointIndex:
          activeTourWaypointIndex ?? this.activeTourWaypointIndex,
      cameraCenter: cameraCenter ?? this.cameraCenter,
      cameraZoom: cameraZoom ?? this.cameraZoom,
      cameraHeading: cameraHeading ?? this.cameraHeading,
      intelligenceSummary: intelligenceSummary ?? this.intelligenceSummary,
      lastCommandFeedback: lastCommandFeedback ?? this.lastCommandFeedback,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        flights,
        satellites,
        vessels,
        earthquakes,
        cctvCameras,
        infrastructure,
        wildfires,
        spaceLaunches,
        selectedContact,
        sensorMode,
        activeLayers,
        basemap,
        isCockpitMode,
        isMeasureToolActive,
        measurementPoints,
        measuredDistanceKm,
        activeTour,
        activeTourWaypointIndex,
        cameraCenter,
        cameraZoom,
        cameraHeading,
        intelligenceSummary,
        lastCommandFeedback,
      ];
}
