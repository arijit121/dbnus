import 'package:dbnus/features/gods_eye_view/data/datasources/earthquake_remote_datasource.dart';
import 'package:dbnus/features/gods_eye_view/data/datasources/flight_remote_datasource.dart';
import 'package:dbnus/features/gods_eye_view/data/datasources/geoint_static_datasource.dart';
import 'package:dbnus/features/gods_eye_view/data/datasources/space_launch_datasource.dart';
import 'package:dbnus/features/gods_eye_view/data/datasources/wildfire_remote_datasource.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';
import 'package:dbnus/features/gods_eye_view/domain/repositories/gods_eye_view_repository.dart';

class GodsEyeViewRepositoryImpl implements GodsEyeViewRepository {
  final FlightRemoteDataSource flightDataSource;
  final EarthquakeRemoteDataSource earthquakeDataSource;
  final GeointStaticDataSource staticDataSource;
  final WildfireRemoteDataSource wildfireDataSource;
  final SpaceLaunchDataSource spaceLaunchDataSource;

  GodsEyeViewRepositoryImpl({
    FlightRemoteDataSource? flightDataSource,
    EarthquakeRemoteDataSource? earthquakeDataSource,
    GeointStaticDataSource? staticDataSource,
    WildfireRemoteDataSource? wildfireDataSource,
    SpaceLaunchDataSource? spaceLaunchDataSource,
  })  : flightDataSource = flightDataSource ?? FlightRemoteDataSourceImpl(),
        earthquakeDataSource =
            earthquakeDataSource ?? EarthquakeRemoteDataSourceImpl(),
        staticDataSource = staticDataSource ?? GeointStaticDataSourceImpl(),
        wildfireDataSource =
            wildfireDataSource ?? WildfireRemoteDataSourceImpl(),
        spaceLaunchDataSource =
            spaceLaunchDataSource ?? SpaceLaunchDataSourceImpl();

  @override
  Future<List<FlightContact>> getFlights() async {
    return await flightDataSource.fetchFlights();
  }

  @override
  Future<List<SatelliteContact>> getSatellites() async {
    return staticDataSource.getSatellites();
  }

  @override
  Future<List<VesselContact>> getVessels() async {
    return staticDataSource.getVessels();
  }

  @override
  Future<List<EarthquakeContact>> getEarthquakes() async {
    return await earthquakeDataSource.fetchEarthquakes();
  }

  @override
  Future<List<CctvCameraContact>> getCctvCameras() async {
    return staticDataSource.getCctvCameras();
  }

  @override
  Future<List<InfrastructureContact>> getInfrastructure() async {
    return staticDataSource.getInfrastructure();
  }

  @override
  Future<List<WildfireContact>> getWildfires() async {
    return await wildfireDataSource.fetchWildfires();
  }

  @override
  Future<List<SpaceLaunchContact>> getSpaceLaunches() async {
    return spaceLaunchDataSource.getSpaceLaunches();
  }

  @override
  List<CinematicTour> getCinematicTours() {
    return spaceLaunchDataSource.getCinematicTours();
  }
}
