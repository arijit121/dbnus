import 'package:dbnus/features/open_street_map/domain/entities/search_place.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';

class SearchPlaceModel extends SearchPlace {
  SearchPlaceModel({
    super.placeId,
    super.displayName,
    super.latitude,
    super.longitude,
    super.type,
    super.category,
    super.addressType,
    super.name,
  });

  factory SearchPlaceModel.fromJson(Map<String, dynamic> json) {
    try {
      final geometry = json['geometry'];
      final properties = json['properties'] ?? json;
      final coords = geometry?['coordinates'] as List?;
      return SearchPlaceModel(
        placeId: properties['place_id'],
        displayName: properties['display_name'] ?? json['display_name'],
        latitude: coords != null ? (coords[1] as num).toDouble() : null,
        longitude: coords != null ? (coords[0] as num).toDouble() : null,
        type: properties['type'] ?? json['type'],
        category: properties['category'] ?? json['category'],
        addressType: properties['addresstype'] ?? json['addresstype'],
        name: properties['name'] ?? json['name'],
      );
    } catch (e, s) {
      AppLog.e(e.toString(), stackTrace: s);
      return SearchPlaceModel();
    }
  }
}
