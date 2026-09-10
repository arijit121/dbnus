import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:dbnus/features/gods_eye_view/data/datasources/flight_remote_datasource.dart';
import 'package:dbnus/features/gods_eye_view/data/datasources/geoint_static_datasource.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/sensor_mode.dart';
import 'package:dbnus/features/gods_eye_view/domain/repositories/gods_eye_view_repository.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_event.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_state.dart';

class GodsEyeViewBloc extends Bloc<GodsEyeViewEvent, GodsEyeViewState> {
  final GodsEyeViewRepository repository;
  final FlightRemoteDataSource flightDataSource;
  final GeointStaticDataSource staticDataSource;
  Timer? _ticker;

  GodsEyeViewBloc({
    required this.repository,
    FlightRemoteDataSource? flightDataSource,
    GeointStaticDataSource? staticDataSource,
  })  : flightDataSource = flightDataSource ?? FlightRemoteDataSourceImpl(),
        staticDataSource = staticDataSource ?? GeointStaticDataSourceImpl(),
        super(const GodsEyeViewState()) {
    on<InitGeointData>(_onInitGeointData);
    on<RefreshFeeds>(_onRefreshFeeds);
    on<TickDeadReckoning>(_onTickDeadReckoning);
    on<SelectContact>(_onSelectContact);
    on<ToggleCockpitMode>(_onToggleCockpitMode);
    on<ChangeSensorMode>(_onChangeSensorMode);
    on<ToggleLayer>(_onToggleLayer);
    on<ChangeBasemap>(_onChangeBasemap);
    on<ExecuteVoiceOrTextCommand>(_onExecuteVoiceOrTextCommand);
    on<CenterOnLocation>(_onCenterOnLocation);
    on<ResetGlobe>(_onResetGlobe);

    // Start dead-reckoning movement ticker at 1-second intervals
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TickDeadReckoning(1.0));
    });
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }

  Future<void> _onInitGeointData(
      InitGeointData event, Emitter<GodsEyeViewState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final flightsFuture = repository.getFlights();
      final satsFuture = repository.getSatellites();
      final vesselsFuture = repository.getVessels();
      final quakesFuture = repository.getEarthquakes();
      final cctvFuture = repository.getCctvCameras();
      final infraFuture = repository.getInfrastructure();

      final results = await Future.wait([
        flightsFuture,
        satsFuture,
        vesselsFuture,
        quakesFuture,
        cctvFuture,
        infraFuture,
      ]);

      emit(state.copyWith(
        isLoading: false,
        flights: results[0] as List<FlightContact>,
        satellites: results[1] as List<SatelliteContact>,
        vessels: results[2] as List<VesselContact>,
        earthquakes: results[3] as List<EarthquakeContact>,
        cctvCameras: results[4] as List<CctvCameraContact>,
        infrastructure: results[5] as List<InfrastructureContact>,
        intelligenceSummary: 'ALL GEOINT LAYERS SYNCHRONIZED // 6 FEEDS ONLINE',
      ));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        intelligenceSummary: 'OFFLINE MODE // BACKUP TACTICAL FEEDS ACTIVE',
      ));
    }
  }

  Future<void> _onRefreshFeeds(
      RefreshFeeds event, Emitter<GodsEyeViewState> emit) async {
    try {
      final flights = await repository.getFlights();
      final quakes = await repository.getEarthquakes();
      emit(state.copyWith(
        flights: flights,
        earthquakes: quakes,
        intelligenceSummary: 'FEEDS REFRESHED // TELEMETRY VERIFIED',
      ));
    } catch (_) {}
  }

  void _onTickDeadReckoning(
      TickDeadReckoning event, Emitter<GodsEyeViewState> emit) {
    if (state.flights.isEmpty && state.satellites.isEmpty) return;

    final updatedFlights =
        flightDataSource.advanceFlights(state.flights, event.dtSeconds);
    final updatedSats =
        staticDataSource.advanceSatellites(state.satellites, event.dtSeconds);
    final updatedVessels =
        staticDataSource.advanceVessels(state.vessels, event.dtSeconds);

    // If currently tracking a contact, keep selectedContact reference up to date
    GeointContact? currentSelected = state.selectedContact;
    LatLng newCenter = state.cameraCenter;
    double newHeading = state.cameraHeading;

    if (currentSelected != null) {
      if (currentSelected is FlightContact) {
        final match = updatedFlights.firstWhere(
          (f) => f.id == currentSelected?.id,
          orElse: () => currentSelected as FlightContact,
        );
        currentSelected = match;
        if (state.isCockpitMode) {
          newCenter = match.position;
          newHeading = match.headingDeg;
        }
      } else if (currentSelected is SatelliteContact) {
        final match = updatedSats.firstWhere(
          (s) => s.id == currentSelected?.id,
          orElse: () => currentSelected as SatelliteContact,
        );
        currentSelected = match;
        if (state.isCockpitMode) {
          newCenter = match.position;
        }
      } else if (currentSelected is VesselContact) {
        final match = updatedVessels.firstWhere(
          (v) => v.id == currentSelected?.id,
          orElse: () => currentSelected as VesselContact,
        );
        currentSelected = match;
        if (state.isCockpitMode) {
          newCenter = match.position;
          newHeading = match.headingDeg;
        }
      }
    }

    emit(state.copyWith(
      flights: updatedFlights,
      satellites: updatedSats,
      vessels: updatedVessels,
      selectedContact: currentSelected,
      cameraCenter: newCenter,
      cameraHeading: newHeading,
    ));
  }

  void _onSelectContact(SelectContact event, Emitter<GodsEyeViewState> emit) {
    final contact = event.contact;
    if (contact == null) {
      emit(state.copyWith(
        clearSelectedContact: true,
        isCockpitMode: false,
        intelligenceSummary: 'TARGET UNLOCKED // WIDE SURVEILLANCE RESTORED',
      ));
      return;
    }

    String summary = 'LOCKED: ${contact.title}';
    double targetZoom = state.cameraZoom;
    if (targetZoom < 9.0) {
      targetZoom = 9.5;
    }

    emit(state.copyWith(
      selectedContact: contact,
      cameraCenter: contact.position,
      cameraZoom: targetZoom,
      intelligenceSummary: summary,
    ));
  }

  void _onToggleCockpitMode(
      ToggleCockpitMode event, Emitter<GodsEyeViewState> emit) {
    final enable = event.enable ?? !state.isCockpitMode;

    if (enable) {
      // Find suitable contact or use currently selected
      GeointContact? target = state.selectedContact;
      if (target == null || target is! FlightContact) {
        target = state.flights.isNotEmpty ? state.flights.first : null;
      }

      if (target != null) {
        final flight = target as FlightContact;
        emit(state.copyWith(
          isCockpitMode: true,
          selectedContact: flight,
          cameraCenter: flight.position,
          cameraZoom: 13.0,
          cameraHeading: flight.headingDeg,
          intelligenceSummary: 'COCKPIT ENGAGED // HUD LOCK ${flight.callsign}',
        ));
      }
    } else {
      emit(state.copyWith(
        isCockpitMode: false,
        intelligenceSummary: 'COCKPIT DISENGAGED // ORBITAL RETICLE ACTIVE',
      ));
    }
  }

  void _onChangeSensorMode(
      ChangeSensorMode event, Emitter<GodsEyeViewState> emit) {
    emit(state.copyWith(
      sensorMode: event.mode,
      intelligenceSummary: 'SENSOR OPTICS: ${event.mode.displayName}',
    ));
  }

  void _onToggleLayer(ToggleLayer event, Emitter<GodsEyeViewState> emit) {
    final updated = Set<GeointLayer>.from(state.activeLayers);
    if (updated.contains(event.layer)) {
      updated.remove(event.layer);
    } else {
      updated.add(event.layer);
    }

    emit(state.copyWith(
      activeLayers: updated,
      intelligenceSummary:
          'LAYER TOGGLED: ${event.layer.name.toUpperCase()} (${updated.contains(event.layer) ? "ON" : "OFF"})',
    ));
  }

  void _onChangeBasemap(ChangeBasemap event, Emitter<GodsEyeViewState> emit) {
    emit(state.copyWith(
      basemap: event.basemap,
      intelligenceSummary: 'BASEMAP: ${event.basemap.displayName}',
    ));
  }

  void _onExecuteVoiceOrTextCommand(
      ExecuteVoiceOrTextCommand event, Emitter<GodsEyeViewState> emit) {
    final cmd = event.command.toLowerCase().trim();
    String feedback = 'COMMAND EXECUTED: "$cmd"';

    if (cmd.contains('nvg') || cmd.contains('night vision')) {
      add(const ChangeSensorMode(SensorMode.nvg));
      feedback = 'OPTICS: Switched to Night Vision Goggles (NVG)';
    } else if (cmd.contains('flir') || cmd.contains('thermal')) {
      add(const ChangeSensorMode(SensorMode.flir));
      feedback = 'OPTICS: Switched to FLIR Thermal Sensor';
    } else if (cmd.contains('crt') || cmd.contains('phosphor')) {
      add(const ChangeSensorMode(SensorMode.crt));
      feedback = 'OPTICS: Switched to CRT Phosphor Display';
    } else if (cmd.contains('noir') || cmd.contains('black and white')) {
      add(const ChangeSensorMode(SensorMode.noir));
      feedback = 'OPTICS: Switched to Noir Surveillance';
    } else if (cmd.contains('snow') || cmd.contains('frost')) {
      add(const ChangeSensorMode(SensorMode.snow));
      feedback = 'OPTICS: Switched to Snow/Frost IR Mode';
    } else if (cmd.contains('normal') || cmd.contains('satellite')) {
      add(const ChangeSensorMode(SensorMode.normal));
      feedback = 'OPTICS: Switched to Normal Optical Sensor';
    } else if (cmd.contains('cockpit') || cmd.contains('ride')) {
      add(const ToggleCockpitMode(true));
      feedback = 'FLIGHT: Entering cockpit chase view';
    } else if (cmd.contains('exit cockpit') || cmd.contains('leave cockpit')) {
      add(const ToggleCockpitMode(false));
      feedback = 'FLIGHT: Exited cockpit chase view';
    } else if (cmd.contains('reset') || cmd.contains('globe')) {
      add(const ResetGlobe());
      feedback = 'NAVIGATION: Resetting to global tactical view';
    } else if (cmd.contains('earthquake') || cmd.contains('quake')) {
      if (state.earthquakes.isNotEmpty) {
        final eq = state.earthquakes.first;
        add(CenterOnLocation(eq.position, 8.0, label: eq.title));
        add(SelectContact(eq));
        feedback = 'SEISMIC: Focused on ${eq.title}';
      }
    } else if (cmd.contains('iss') || cmd.contains('satellite')) {
      if (state.satellites.isNotEmpty) {
        final sat = state.satellites.first;
        add(CenterOnLocation(sat.position, 6.0, label: sat.title));
        add(SelectContact(sat));
        feedback = 'ORBIT: Locked on ${sat.title}';
      }
    } else if (cmd.contains('military')) {
      final mil = state.flights.where((f) => f.isMilitary).firstOrNull;
      if (mil != null) {
        add(CenterOnLocation(mil.position, 10.0, label: mil.title));
        add(SelectContact(mil));
        feedback = 'MILITARY: Tracking ${mil.title}';
      }
    } else if (cmd.contains('tokyo')) {
      add(const CenterOnLocation(LatLng(35.6762, 139.6503), 11.0,
          label: 'TOKYO SECTOR'));
      feedback = 'VECTOR: Flying to Tokyo, Japan';
    } else if (cmd.contains('london')) {
      add(const CenterOnLocation(LatLng(51.5074, -0.1278), 11.0,
          label: 'LONDON SECTOR'));
      feedback = 'VECTOR: Flying to London, United Kingdom';
    } else if (cmd.contains('austin')) {
      add(const CenterOnLocation(LatLng(30.2672, -97.7431), 11.0,
          label: 'AUSTIN SECTOR'));
      feedback = 'VECTOR: Flying to Austin, Texas';
    } else if (cmd.contains('new york') || cmd.contains('jfk')) {
      add(const CenterOnLocation(LatLng(40.7128, -74.0060), 11.0,
          label: 'NEW YORK SECTOR'));
      feedback = 'VECTOR: Flying to New York Metropolitan Area';
    } else {
      feedback = 'COMMAND ACKNOWLEDGED: Processing "$cmd"';
    }

    emit(state.copyWith(
      lastCommandFeedback: feedback,
      intelligenceSummary: feedback.toUpperCase(),
    ));
  }

  void _onCenterOnLocation(
      CenterOnLocation event, Emitter<GodsEyeViewState> emit) {
    emit(state.copyWith(
      cameraCenter: event.position,
      cameraZoom: event.zoom,
      intelligenceSummary: event.label.isNotEmpty
          ? 'VECTORING TO: ${event.label.toUpperCase()}'
          : 'CAMERA VECTORING IN PROGRESS',
    ));
  }

  void _onResetGlobe(ResetGlobe event, Emitter<GodsEyeViewState> emit) {
    emit(state.copyWith(
      cameraCenter: const LatLng(25.0, 45.0),
      cameraZoom: 3.5,
      cameraHeading: 0.0,
      isCockpitMode: false,
      clearSelectedContact: true,
      intelligenceSummary: 'GLOBE VIEW RESTORED // SURVEILLANCE COMPREHENSIVE',
    ));
  }
}
