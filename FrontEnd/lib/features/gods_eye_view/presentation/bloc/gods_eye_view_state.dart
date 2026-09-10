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
  final GeointContact? selectedContact;
  final SensorMode sensorMode;
  final Set<GeointLayer> activeLayers;
  final BasemapType basemap;
  final bool isCockpitMode;
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
      GeointLayer.detectionBoxes,
    },
    this.basemap = BasemapType.satellite,
    this.isCockpitMode = false,
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
    GeointContact? selectedContact,
    bool clearSelectedContact = false,
    SensorMode? sensorMode,
    Set<GeointLayer>? activeLayers,
    BasemapType? basemap,
    bool? isCockpitMode,
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
      selectedContact: clearSelectedContact
          ? null
          : (selectedContact ?? this.selectedContact),
      sensorMode: sensorMode ?? this.sensorMode,
      activeLayers: activeLayers ?? this.activeLayers,
      basemap: basemap ?? this.basemap,
      isCockpitMode: isCockpitMode ?? this.isCockpitMode,
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
        selectedContact,
        sensorMode,
        activeLayers,
        basemap,
        isCockpitMode,
        cameraCenter,
        cameraZoom,
        cameraHeading,
        intelligenceSummary,
        lastCommandFeedback,
      ];
}
