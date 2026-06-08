import 'dart:convert';

import '../network/api_client/imp/api_repo_imp.dart';
import '../network/api_client/repo/api_repo.dart';
import '../network/models/api_return_model.dart';
import 'models/forward_geocoding.dart';
import 'models/reverse_geocoding.dart';
import '../../shared/extensions/logger_extension.dart';

class Geocoding {
  static const String _reverseGeocode =
      "https://nominatim.openstreetmap.org/reverse";
  static const String _forwardGeocode =
      "https://nominatim.openstreetmap.org/search";

  Geocoding();

  static Future<ReverseGeocoding?> reverseGeocoding({
    required double latitude,
    required double longitude,
  }) async {
    try {
      ApiReturnModel? v = await ApiEngine.instance.callApi(
        tag: "ReverseGeocoding",
        uri: _reverseGeocode,
        queryParameters: {
          "lat": latitude,
          "lon": longitude,
          "format": "geojson",
        },
        method: Method.get,
      );

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

  static Future<ForwardGeocoding?> forwardGeocoding({
    required String address,
  }) async {
    try {
      ApiReturnModel? v = await ApiEngine.instance.callApi(
        tag: "ForwardGeocoding",
        uri: _forwardGeocode,
        queryParameters: {"format": "geojson", "q": address},
        method: Method.get,
      );
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
