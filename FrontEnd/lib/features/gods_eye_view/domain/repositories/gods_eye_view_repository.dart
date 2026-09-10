import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';

abstract class GodsEyeViewRepository {
  Future<List<FlightContact>> getFlights();
  Future<List<SatelliteContact>> getSatellites();
  Future<List<VesselContact>> getVessels();
  Future<List<EarthquakeContact>> getEarthquakes();
  Future<List<CctvCameraContact>> getCctvCameras();
  Future<List<InfrastructureContact>> getInfrastructure();
}
