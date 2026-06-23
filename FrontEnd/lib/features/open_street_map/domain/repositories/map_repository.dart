import 'package:dbnus/features/open_street_map/domain/entities/route_info.dart';
import 'package:dbnus/features/open_street_map/domain/entities/search_place.dart';

abstract class MapRepository {
  Future<List<SearchPlace>> searchPlaces(String query);
  Future<RouteInfo?> getRoute(
      {required double fromLat,
      required double fromLng,
      required double toLat,
      required double toLng});
}
