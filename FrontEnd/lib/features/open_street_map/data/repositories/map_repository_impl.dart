import 'package:dbnus/features/open_street_map/domain/entities/route_info.dart';
import 'package:dbnus/features/open_street_map/domain/entities/search_place.dart';
import 'package:dbnus/features/open_street_map/domain/repositories/map_repository.dart';

import '../datasources/map_data_source.dart';

class MapRepositoryImpl implements MapRepository {
  final MapDataSource remoteDataSource;

  MapRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SearchPlace>> searchPlaces(String query) async {
    return await remoteDataSource.searchPlaces(query);
  }

  @override
  Future<RouteInfo?> getRoute({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) async {
    return await remoteDataSource.getRoute(
      fromLat: fromLat,
      fromLng: fromLng,
      toLat: toLat,
      toLng: toLng,
    );
  }
}
