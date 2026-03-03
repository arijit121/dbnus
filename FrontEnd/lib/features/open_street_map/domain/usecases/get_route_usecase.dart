import 'package:dbnus/features/open_street_map/domain/entities/route_info.dart';
import 'package:dbnus/features/open_street_map/domain/repositories/map_repository.dart';

class GetRouteUseCase {
  final MapRepository repository;

  GetRouteUseCase(this.repository);

  Future<RouteInfo?> call({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) async {
    return await repository.getRoute(
      fromLat: fromLat,
      fromLng: fromLng,
      toLat: toLat,
      toLng: toLng,
    );
  }
}
