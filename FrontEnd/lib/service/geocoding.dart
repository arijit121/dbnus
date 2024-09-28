import 'dart:convert';

import '../data/api_client/imp/api_repo_imp.dart';
import '../data/api_client/repo/api_repo.dart';
import '../data/model/api_return_model.dart';
import '../data/model/forward_geocoding.dart';
import '../data/model/reverse_geocoding.dart';
import '../extension/logger_extension.dart';

class Geocoding {
  final String _reverseGeocode = "https://nominatim.openstreetmap.org/reverse";
  final String _forwardGeocode = "https://nominatim.openstreetmap.org/search";

  ///
  ///
  /// Free Geocoding API
  /// Convert Between Addresses & Geographic Coordinates
  /// Geocoding API Endpoint URLs:
  /// Forward OpenStreetMap: https://nominatim.openstreetmap.org/search?format=geojson&q={address}
  ///
  /// Reverse OpenStreetMap: https://nominatim.openstreetmap.org/reverse?format=geojson&lat={latitude}&lon={longitude}
  ///

  Geocoding();

  /// Enter latitude , longitude
  ///
  /// And get reverse geocoding value
  ///
  /// Example:-
  ///
  ///{
  ///     "type": "FeatureCollection",
  ///     "licence": "Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright",
  ///     "features": [
  ///         {
  ///             "type": "Feature",
  ///             "properties": {
  ///                 "place_id": 140892467,
  ///                 "osm_type": "node",
  ///                 "osm_id": 3110596255,
  ///                 "place_rank": 30,
  ///                 "category": "place",
  ///                 "type": "house",
  ///                 "importance": 0.00000999999999995449,
  ///                 "addresstype": "place",
  ///                 "name": "",
  ///                 "display_name": "1, Løvenbergvegen, Mogreina, Løvenberg, Ullensaker, Viken, 2054, Norway",
  ///                 "address": {
  ///                     "house_number": "1",
  ///                     "road": "Løvenbergvegen",
  ///                     "quarter": "Mogreina",
  ///                     "farm": "Løvenberg",
  ///                     "municipality": "Ullensaker",
  ///                     "county": "Viken",
  ///                     "ISO3166-2-lvl4": "NO-30",
  ///                     "postcode": "2054",
  ///                     "country": "Norway",
  ///                     "country_code": "no"
  ///                 }
  ///             },
  ///             "bbox": [
  ///                 11.1658072,
  ///                 60.2300796,
  ///                 11.1659072,
  ///                 60.2301796
  ///             ],
  ///             "geometry": {
  ///                 "type": "Point",
  ///                 "coordinates": [
  ///                     11.1658572,
  ///                     60.2301296
  ///                 ]
  ///             }
  ///         }
  ///     ]
  /// }
  ///
  ///

  Future<ReverseGeocoding?> reverseGeocoding(
      {required double latitude, required double longitude}) async {
    try {
      ApiReturnModel? v = await apiRepo().callApi(
          tag: "ReverseGeocoding",
          uri: _reverseGeocode,
          queryParameters: {
            "lat": latitude,
            "lon": longitude,
            "format": "geojson"
          },
          method: Method.get);

      if (v?.statusCode == 200 && v?.responseString != null) {
        return ReverseGeocoding.fromJson(
            json.decode(v?.responseString ?? '')['features'][0]['properties']);
      } else {
        AppLog.i(v?.responseString ?? "");
      }
    } catch (e) {
      AppLog.e(e.toString());
    }
    return null;
  }

  ///
  /// Enter Address Line and get lat-long
  ///
  /// Example
  ///
  ///
  ///  {
  ///     "type": "FeatureCollection",
  ///     "licence": "Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright",
  ///     "features": [
  ///         {
  ///             "type": "Feature",
  ///             "properties": {
  ///                 "place_id": 51712658,
  ///                 "osm_type": "node",
  ///                 "osm_id": 2846295644,
  ///                 "place_rank": 30,
  ///                 "category": "place",
  ///                 "type": "house",
  ///                 "importance": 0.00000999999999995449,
  ///                 "addresstype": "place",
  ///                 "name": "",
  ///                 "display_name": "17, Strada Pictor Alexandru Romano, Cartierul Armenesc, Sector 2, Bucharest, 023964, Romania"
  ///             },
  ///             "bbox": [
  ///                 26.1156689,
  ///                 44.4354754,
  ///                 26.1157689,
  ///                 44.4355754
  ///             ],
  ///             "geometry": {
  ///                 "type": "Point",
  ///                 "coordinates": [
  ///                     26.1157189,
  ///                     44.4355254
  ///                 ]
  ///             }
  ///         }
  ///     ]
  /// }
  ///
  ///

  Future<ForwardGeocoding?> forwardGeocoding({required String address}) async {
    try {
      ApiReturnModel? v = await apiRepo().callApi(
          tag: "ForwardGeocoding",
          uri: _forwardGeocode,
          queryParameters: {"format": "geojson", "q": address},
          method: Method.get);
      if (v?.statusCode == 200 && v?.responseString != null) {
        return ForwardGeocoding.fromJson(
            json.decode(v?.responseString ?? "")['features'][0]['geometry']
                ['coordinates']);
      } else {
        AppLog.i(v?.responseString ?? "");
      }
    } catch (e) {
      AppLog.e(e.toString());
    }
    return null;
  }
}
