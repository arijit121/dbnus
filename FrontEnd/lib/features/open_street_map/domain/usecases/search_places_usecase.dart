import 'package:dbnus/features/open_street_map/domain/entities/search_place.dart';
import 'package:dbnus/features/open_street_map/domain/repositories/map_repository.dart';

class SearchPlacesUseCase {
  final MapRepository repository;

  SearchPlacesUseCase(this.repository);

  Future<List<SearchPlace>> call(String query) async {
    return await repository.searchPlaces(query);
  }
}
