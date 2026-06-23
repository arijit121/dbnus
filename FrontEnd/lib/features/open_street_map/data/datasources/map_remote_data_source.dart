import 'dart:convert';

import 'package:dbnus/core/network/api_client/imp/api_repo_imp.dart';
import 'package:dbnus/core/network/api_client/repo/api_repo.dart';
import 'package:dbnus/core/network/models/api_return_model.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';

import '../models/route_info_model.dart';
import '../models/search_place_model.dart';
import 'map_data_source.dart';

class MapRemoteDataSourceImpl implements MapDataSource {
  static const String _searchUrl = "https://nominatim.openstreetmap.org/search";
  static const String _routeUrl =
      "https://router.project-osrm.org/route/v1/driving";

  @override
  Future<List<SearchPlaceModel>> searchPlaces(String query) async {
    if (query.trim().isEmpty) return [];
    try {
      ApiReturnModel? v = await ApiEngine.instance.callApi(
        tag: "PlaceSearch",
        uri: _searchUrl,
        queryParameters: {
          "format": "geojson",
          "q": query,
          "limit": 8,
          "addressdetails": 1,
        },
        method: Method.get,
      );
      if (v?.statusCode == 200 && v?.responseString != null) {
        final decoded = json.decode(v!.responseString!);
        final features = decoded['features'] as List? ?? [];
        return features
            .map((f) => SearchPlaceModel.fromJson(f as Map<String, dynamic>))
            .toList();
      }
    } catch (e, s) {
      AppLog.e(e.toString(), stackTrace: s);
    }
    return [];
  }

  @override
  Future<RouteInfoModel?> getRoute({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) async {
    try {
      final coordinates = "$fromLng,$fromLat;$toLng,$toLat";
      ApiReturnModel? v = await ApiEngine.instance.callApi(
        tag: "RouteDirections",
        uri: "$_routeUrl/$coordinates",
        queryParameters: {
          "overview": "full",
          "geometries": "geojson",
          "steps": "true",
        },
        method: Method.get,
      );
      if (v?.statusCode == 200 && v?.responseString != null) {
        final decoded = json.decode(v!.responseString!);
        return RouteInfoModel.fromJson(decoded);
      }
    } catch (e, s) {
      AppLog.e(e.toString(), stackTrace: s);
    }
    return null;
  }
}
