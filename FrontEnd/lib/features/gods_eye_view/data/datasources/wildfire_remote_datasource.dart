import 'package:latlong2/latlong.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';

abstract class WildfireRemoteDataSource {
  Future<List<WildfireContact>> fetchWildfires();
}

class WildfireRemoteDataSourceImpl implements WildfireRemoteDataSource {
  @override
  Future<List<WildfireContact>> fetchWildfires() async {
    // NASA FIRMS (Fire Information for Resource Management System) active fire catalog
    return [
      WildfireContact(
        id: 'wf_california_01',
        title: 'SIERRA COMPLEX THERMAL HOTSPOT',
        position: const LatLng(39.872, -121.341),
        frpMw: 642.5,
        brightnessKelvin: 384.2,
        confidence: 'high',
        acquisitionTime: DateTime.now().subtract(const Duration(minutes: 38)),
        region: 'California, USA',
      ),
      WildfireContact(
        id: 'wf_amazon_02',
        title: 'PARA BASIN BIOMASS BURNING',
        position: const LatLng(-4.521, -54.912),
        frpMw: 1210.0,
        brightnessKelvin: 412.8,
        confidence: 'high',
        acquisitionTime: DateTime.now().subtract(const Duration(hours: 2)),
        region: 'Amazonas, Brazil',
      ),
      WildfireContact(
        id: 'wf_australia_03',
        title: 'KIMBERLEY GRASSLAND BURN',
        position: const LatLng(-17.291, 126.834),
        frpMw: 415.8,
        brightnessKelvin: 356.4,
        confidence: 'nominal',
        acquisitionTime: DateTime.now().subtract(const Duration(hours: 4)),
        region: 'Western Australia',
      ),
      WildfireContact(
        id: 'wf_siberia_04',
        title: 'TAIGA THERMAL ANOMALY',
        position: const LatLng(61.240, 98.412),
        frpMw: 890.3,
        brightnessKelvin: 395.1,
        confidence: 'high',
        acquisitionTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
        region: 'Siberia, Russian Federation',
      ),
      WildfireContact(
        id: 'wf_congo_05',
        title: 'CONGO RIVER SAVANNA FIRE',
        position: const LatLng(-2.140, 22.870),
        frpMw: 530.0,
        brightnessKelvin: 368.5,
        confidence: 'nominal',
        acquisitionTime: DateTime.now().subtract(const Duration(hours: 3)),
        region: 'Equateur, DR Congo',
      ),
      WildfireContact(
        id: 'wf_greece_06',
        title: 'PELOPONNESE BRUSH HOTSPOT',
        position: const LatLng(37.621, 21.942),
        frpMw: 310.2,
        brightnessKelvin: 345.9,
        confidence: 'high',
        acquisitionTime: DateTime.now().subtract(const Duration(minutes: 54)),
        region: 'Peloponnese, Greece',
      ),
      WildfireContact(
        id: 'wf_indonesia_07',
        title: 'SUMATRA PEATLAND EMISSION',
        position: const LatLng(0.321, 101.450),
        frpMw: 785.6,
        brightnessKelvin: 398.0,
        confidence: 'high',
        acquisitionTime: DateTime.now().subtract(const Duration(hours: 5)),
        region: 'Riau, Indonesia',
      ),
    ];
  }
}
