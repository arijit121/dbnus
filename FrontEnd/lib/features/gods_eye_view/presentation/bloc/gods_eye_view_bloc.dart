import 'dart:async';
import 'dart:math' as math;
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
  Timer? _tourTimer;

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
    on<ToggleMeasureTool>(_onToggleMeasureTool);
    on<AddMeasurementPoint>(_onAddMeasurementPoint);
    on<ClearMeasurements>(_onClearMeasurements);
    on<StartCinematicTour>(_onStartCinematicTour);
    on<NextTourWaypoint>(_onNextTourWaypoint);
    on<StopCinematicTour>(_onStopCinematicTour);

    // Start dead-reckoning movement ticker at 1-second intervals
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TickDeadReckoning(1.0));
    });
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    _tourTimer?.cancel();
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
      final wildfiresFuture = repository.getWildfires();
      final launchesFuture = repository.getSpaceLaunches();

      final results = await Future.wait([
        flightsFuture,
        satsFuture,
        vesselsFuture,
        quakesFuture,
        cctvFuture,
        infraFuture,
        wildfiresFuture,
        launchesFuture,
      ]);

      emit(state.copyWith(
        isLoading: false,
        flights: results[0] as List<FlightContact>,
        satellites: results[1] as List<SatelliteContact>,
        vessels: results[2] as List<VesselContact>,
        earthquakes: results[3] as List<EarthquakeContact>,
        cctvCameras: results[4] as List<CctvCameraContact>,
        infrastructure: results[5] as List<InfrastructureContact>,
        wildfires: results[6] as List<WildfireContact>,
        spaceLaunches: results[7] as List<SpaceLaunchContact>,
        intelligenceSummary: 'ALL GEOINT LAYERS SYNCHRONIZED // 8 FEEDS ONLINE',
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

    // 1-6. Sensor Modes
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
    } else if (cmd.contains('normal') || cmd.contains('satellite optics')) {
      add(const ChangeSensorMode(SensorMode.normal));
      feedback = 'OPTICS: Switched to Normal Optical Sensor';
    }
    // 7-8. Cockpit Chase Mode
    else if (cmd.contains('cockpit') || cmd.contains('ride flight') || cmd.contains('follow plane')) {
      add(const ToggleCockpitMode(true));
      feedback = 'FLIGHT: Entering cockpit chase view';
    } else if (cmd.contains('exit cockpit') || cmd.contains('leave cockpit')) {
      add(const ToggleCockpitMode(false));
      feedback = 'FLIGHT: Exited cockpit chase view';
    }
    // 9. Reset / Global View
    else if (cmd.contains('reset') || cmd.contains('globe') || cmd.contains('world')) {
      add(const ResetGlobe());
      feedback = 'NAVIGATION: Resetting to global tactical view';
    }
    // 10. Measure / Ruler Tool
    else if (cmd.contains('measure') || cmd.contains('ruler') || cmd.contains('distance tool')) {
      add(const ToggleMeasureTool());
      feedback = 'TACTICAL: Toggled distance measurement ruler';
    } else if (cmd.contains('clear measure') || cmd.contains('reset measure') || cmd.contains('reset ruler')) {
      add(const ClearMeasurements());
      feedback = 'TACTICAL: Cleared measurement points';
    }
    // 11-15. Cinematic Tours
    else if (cmd.contains('orbital watch') || (cmd.contains('tour') && cmd.contains('orbital'))) {
      final tours = repository.getCinematicTours();
      if (tours.isNotEmpty) {
        add(StartCinematicTour(tours[0]));
        feedback = 'CINEMATIC: Commencing Orbital Watch tour';
      }
    } else if (cmd.contains('ring of fire') || (cmd.contains('tour') && (cmd.contains('fire') || cmd.contains('pacific')))) {
      final tours = repository.getCinematicTours();
      if (tours.length > 1) {
        add(StartCinematicTour(tours[1]));
        feedback = 'CINEMATIC: Commencing Pacific Ring of Fire tour';
      }
    } else if (cmd.contains('transatlantic') || (cmd.contains('tour') && cmd.contains('atlantic'))) {
      final tours = repository.getCinematicTours();
      if (tours.length > 2) {
        add(StartCinematicTour(tours[2]));
        feedback = 'CINEMATIC: Commencing Transatlantic Corridor tour';
      }
    } else if (cmd.contains('capital citadels') || (cmd.contains('tour') && cmd.contains('capital'))) {
      final tours = repository.getCinematicTours();
      if (tours.length > 3) {
        add(StartCinematicTour(tours[3]));
        feedback = 'CINEMATIC: Commencing Capital Citadels tour';
      }
    } else if (cmd.contains('stop tour') || cmd.contains('cancel tour') || cmd.contains('abort tour')) {
      add(const StopCinematicTour());
      feedback = 'CINEMATIC: Aborted active tour';
    }
    // 16-24. Intelligence Entity Focus
    else if (cmd.contains('wildfire') || cmd.contains('forest fire')) {
      if (state.wildfires.isNotEmpty) {
        final wf = state.wildfires.first;
        add(CenterOnLocation(wf.position, 8.5, label: wf.title));
        add(SelectContact(wf));
        feedback = 'FIRMS: Focused on ${wf.title}';
      } else {
        feedback = 'FIRMS: No active wildfire anomaly contacts found';
      }
    } else if (cmd.contains('space launch') || cmd.contains('rocket') || cmd.contains('spaceport')) {
      if (state.spaceLaunches.isNotEmpty) {
        final sl = state.spaceLaunches.first;
        add(CenterOnLocation(sl.position, 8.5, label: sl.title));
        add(SelectContact(sl));
        feedback = 'SPACEPORT: Focused on ${sl.title}';
      } else {
        feedback = 'SPACEPORT: No active launch countdowns found';
      }
    } else if (cmd.contains('earthquake') || cmd.contains('quake') || cmd.contains('seismic')) {
      if (state.earthquakes.isNotEmpty) {
        final eq = state.earthquakes.first;
        add(CenterOnLocation(eq.position, 8.0, label: eq.title));
        add(SelectContact(eq));
        feedback = 'SEISMIC: Focused on ${eq.title}';
      }
    } else if (cmd.contains('iss') || cmd.contains('space station')) {
      final iss = state.satellites.where((s) => s.id.contains('iss') || s.title.contains('ISS')).firstOrNull ??
          (state.satellites.isNotEmpty ? state.satellites.first : null);
      if (iss != null) {
        add(CenterOnLocation(iss.position, 6.0, label: iss.title));
        add(SelectContact(iss));
        feedback = 'ORBIT: Locked on ISS';
      }
    } else if (cmd.contains('satellite')) {
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
      } else {
        feedback = 'MILITARY: No military transponders active in sector';
      }
    } else if (cmd.contains('vessel') || cmd.contains('ship') || cmd.contains('carrier')) {
      if (state.vessels.isNotEmpty) {
        final vessel = state.vessels.first;
        add(CenterOnLocation(vessel.position, 9.0, label: vessel.title));
        add(SelectContact(vessel));
        feedback = 'AIS: Tracking ${vessel.title}';
      }
    } else if (cmd.contains('cctv') || cmd.contains('surveillance camera')) {
      if (state.cctvCameras.isNotEmpty) {
        final cam = state.cctvCameras.first;
        add(CenterOnLocation(cam.position, 12.0, label: cam.title));
        add(SelectContact(cam));
        feedback = 'CCTV: Stream locked on ${cam.title}';
      }
    } else if (cmd.contains('pipeline') || cmd.contains('infrastructure') || cmd.contains('cable')) {
      if (state.infrastructure.isNotEmpty) {
        final infra = state.infrastructure.first;
        add(CenterOnLocation(infra.position, 10.0, label: infra.title));
        add(SelectContact(infra));
        feedback = 'INFRASTRUCTURE: Locked on ${infra.title}';
      }
    }
    // 25. Layer Toggles
    else if (cmd.contains('toggle wildfire') || cmd.contains('wildfires layer')) {
      add(const ToggleLayer(GeointLayer.wildfires));
      feedback = 'LAYER: Toggled NASA FIRMS Wildfires';
    } else if (cmd.contains('toggle launch') || cmd.contains('space launches layer')) {
      add(const ToggleLayer(GeointLayer.spaceLaunches));
      feedback = 'LAYER: Toggled Space Launches & Trajectories';
    } else if (cmd.contains('toggle flight') || cmd.contains('flights layer')) {
      add(const ToggleLayer(GeointLayer.flights));
      feedback = 'LAYER: Toggled ADS-B Commercial Flights';
    } else if (cmd.contains('toggle satellite') || cmd.contains('satellites layer')) {
      add(const ToggleLayer(GeointLayer.satellites));
      feedback = 'LAYER: Toggled Low Earth Orbit Satellites';
    } else if (cmd.contains('toggle vessel') || cmd.contains('ships layer')) {
      add(const ToggleLayer(GeointLayer.vessels));
      feedback = 'LAYER: Toggled AIS Maritime Vessels';
    } else if (cmd.contains('toggle earthquake') || cmd.contains('seismic layer')) {
      add(const ToggleLayer(GeointLayer.earthquakes));
      feedback = 'LAYER: Toggled USGS Seismic Events';
    } else if (cmd.contains('toggle cctv') || cmd.contains('cameras layer')) {
      add(const ToggleLayer(GeointLayer.cctv));
      feedback = 'LAYER: Toggled Traffic & Security CCTV';
    } else if (cmd.contains('toggle infrastructure') || cmd.contains('pipelines layer')) {
      add(const ToggleLayer(GeointLayer.infrastructure));
      feedback = 'LAYER: Toggled Subsea Cables & Pipelines';
    } else if (cmd.contains('toggle annotation') || cmd.contains('annotations layer')) {
      add(const ToggleLayer(GeointLayer.annotations));
      feedback = 'LAYER: Toggled Tactical Annotations';
    }
    // 26. Basemap Changes
    else if (cmd.contains('basemap dark') || cmd.contains('dark map')) {
      add(const ChangeBasemap(BasemapType.dark));
      feedback = 'BASEMAP: Changed to Tactical Dark';
    } else if (cmd.contains('basemap street') || cmd.contains('osm')) {
      add(const ChangeBasemap(BasemapType.street));
      feedback = 'BASEMAP: Changed to OpenStreetMap';
    } else if (cmd.contains('basemap satellite') || cmd.contains('satellite map')) {
      add(const ChangeBasemap(BasemapType.satellite));
      feedback = 'BASEMAP: Changed to ESRI World Imagery';
    }
    // 27. Sitrep / Summary
    else if (cmd.contains('sitrep') || cmd.contains('status') || cmd.contains('summary') || cmd.contains('report')) {
      feedback = 'SITREP: ${state.totalActiveContacts} active contacts across 8 synchronized feeds';
    }
    // 28. Geographic Sectors
    else if (cmd.contains('tokyo')) {
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
    } else if (cmd.contains('washington') || cmd.contains('pentagon')) {
      add(const CenterOnLocation(LatLng(38.8951, -77.0364), 11.0,
          label: 'WASHINGTON D.C. SECTOR'));
      feedback = 'VECTOR: Flying to Washington D.C.';
    } else if (cmd.contains('paris')) {
      add(const CenterOnLocation(LatLng(48.8566, 2.3522), 11.0,
          label: 'PARIS SECTOR'));
      feedback = 'VECTOR: Flying to Paris, France';
    } else if (cmd.contains('dubai')) {
      add(const CenterOnLocation(LatLng(25.2048, 55.2708), 11.0,
          label: 'DUBAI SECTOR'));
      feedback = 'VECTOR: Flying to Dubai, UAE';
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

  void _onToggleMeasureTool(
      ToggleMeasureTool event, Emitter<GodsEyeViewState> emit) {
    final enable = event.enable ?? !state.isMeasureToolActive;
    emit(state.copyWith(
      isMeasureToolActive: enable,
      measurementPoints: enable ? state.measurementPoints : const [],
      clearMeasuredDistance: !enable,
      intelligenceSummary: enable
          ? 'TACTICAL RULER ACTIVE // TAP TWO POINTS ON THE GLOBE'
          : 'TACTICAL RULER DEACTIVATED',
    ));
  }

  void _onAddMeasurementPoint(
      AddMeasurementPoint event, Emitter<GodsEyeViewState> emit) {
    final pts = List<LatLng>.from(state.measurementPoints);
    if (pts.length >= 2) {
      pts.clear();
    }
    pts.add(event.point);

    double? distanceKm;
    String summary;
    if (pts.length == 1) {
      summary =
          'POINT A MARKED [${pts[0].latitude.toStringAsFixed(2)}°, ${pts[0].longitude.toStringAsFixed(2)}°] // TAP POINT B';
    } else {
      distanceKm = _calculateDistanceKm(pts[0], pts[1]);
      final nm = distanceKm * 0.539957;
      summary =
          'DISTANCE: ${distanceKm.toStringAsFixed(1)} KM (${nm.toStringAsFixed(1)} NM)';
    }

    emit(state.copyWith(
      measurementPoints: pts,
      measuredDistanceKm: distanceKm,
      clearMeasuredDistance: pts.length < 2,
      intelligenceSummary: summary,
    ));
  }

  void _onClearMeasurements(
      ClearMeasurements event, Emitter<GodsEyeViewState> emit) {
    emit(state.copyWith(
      measurementPoints: const [],
      clearMeasuredDistance: true,
      intelligenceSummary: 'TACTICAL MEASUREMENTS CLEARED',
    ));
  }

  void _onStartCinematicTour(
      StartCinematicTour event, Emitter<GodsEyeViewState> emit) {
    _tourTimer?.cancel();
    final tour = event.tour;
    if (tour.waypoints.isEmpty) return;

    final firstWp = tour.waypoints[0];
    emit(state.copyWith(
      activeTour: tour,
      activeTourWaypointIndex: 0,
      cameraCenter: firstWp.position,
      cameraZoom: firstWp.zoom,
      cameraHeading: 0.0,
      intelligenceSummary:
          'TOUR INITIALIZED: ${tour.name.toUpperCase()} // ${firstWp.title}',
    ));

    _tourTimer = Timer(Duration(seconds: firstWp.durationSeconds), () {
      add(const NextTourWaypoint());
    });
  }

  void _onNextTourWaypoint(
      NextTourWaypoint event, Emitter<GodsEyeViewState> emit) {
    final tour = state.activeTour;
    if (tour == null) return;

    final nextIndex = state.activeTourWaypointIndex + 1;
    if (nextIndex >= tour.waypoints.length) {
      _tourTimer?.cancel();
      emit(state.copyWith(
        clearActiveTour: true,
        activeTourWaypointIndex: 0,
        intelligenceSummary:
            'CINEMATIC TOUR COMPLETED // ${tour.name.toUpperCase()}',
      ));
      return;
    }

    final wp = tour.waypoints[nextIndex];
    emit(state.copyWith(
      activeTourWaypointIndex: nextIndex,
      cameraCenter: wp.position,
      cameraZoom: wp.zoom,
      cameraHeading: 0.0,
      intelligenceSummary:
          'TOUR [${nextIndex + 1}/${tour.waypoints.length}]: ${wp.title} // ${wp.subtitle}',
    ));

    _tourTimer = Timer(Duration(seconds: wp.durationSeconds), () {
      add(const NextTourWaypoint());
    });
  }

  void _onStopCinematicTour(
      StopCinematicTour event, Emitter<GodsEyeViewState> emit) {
    _tourTimer?.cancel();
    emit(state.copyWith(
      clearActiveTour: true,
      activeTourWaypointIndex: 0,
      intelligenceSummary:
          'CINEMATIC TOUR ABORTED // RETURNING MANUAL FLIGHT CONTROL',
    ));
  }

  double _calculateDistanceKm(LatLng p1, LatLng p2) {
    const r = 6371.0;
    final dLat = (p2.latitude - p1.latitude) * (math.pi / 180.0);
    final dLon = (p2.longitude - p1.longitude) * (math.pi / 180.0);
    final lat1 = p1.latitude * (math.pi / 180.0);
    final lat2 = p2.latitude * (math.pi / 180.0);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLon / 2) * math.sin(dLon / 2) * math.cos(lat1) * math.cos(lat2);
    return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }
}
