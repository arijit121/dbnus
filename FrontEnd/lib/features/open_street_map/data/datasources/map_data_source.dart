import '../models/route_info_model.dart';
import '../models/search_place_model.dart';

abstract class MapDataSource {
  Future<List<SearchPlaceModel>> searchPlaces(String query);
  Future<RouteInfoModel?> getRoute(
      {required double fromLat,
      required double fromLng,
      required double toLat,
      required double toLng});
}
