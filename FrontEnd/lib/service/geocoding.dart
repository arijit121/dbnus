import 'dart:convert';

import 'package:genu/extension/logger_extension.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

import '../const/api_url_const.dart';
import '../data/api_client/imp/api_repo_imp.dart';
import '../data/api_client/repo/api_repo.dart';
import '../data/model/api_return_model.dart';
import '../data/model/forward_geocoding.dart';
import '../data/model/reverse_geocoding.dart';

class Geocoding {
  ///
  ///
  /// Free Geocoding API
  /// Convert Between Addresses & Geographic Coordinates
  /// Geocoding API Endpoint URLs:
  /// Forward Geocode: https://geocode.maps.co/search?q={address}
  ///
  /// Reverse Geocode: https://geocode.maps.co/reverse?lat={latitude}&lon={longitude}
  ///
  /// For examples & more details see "How To Geocode / Search?" below
  /// Please also be sure to read the "API Limitations / Rate Throttling"
  ///
  /// NOTE: Our API endpoints return JSON data by default. To return data in a different format, you can append "&format={format}", where {format} is one of the following: xml, json, jsonv2, geojson, geocodejson. Please remember to substitute {address}, {latitude} and {longitude} in the URLs above with your URL-encoded values.
  ///
  /// If you enjoy this free geocoding service, please help us by sharing our Map Maker service online.
  ///
  /// For Support: Help@Maps.co
  ///
  ///

  Geocoding();

  /// Enter latitude , longitude
  ///
  /// And get reverse geocoding value
  ///
  /// Example:-
  ///
  /// {
  ///    "place_id": 253692744,
  ///    "licence": "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
  ///    "powered_by": "Map Maker: https://maps.co",
  ///    "osm_type": "way",
  ///    "osm_id": 773799741,
  ///    "lat": "22.57706745979335",
  ///    "lon": "88.48882392677336",
  ///    "display_name": "New Town, Rajarhat, North 24 Parganas, West Bengal, 700156, India",
  ///    "address": {
  ///        "town": "New Town",
  ///        "county": "Rajarhat",
  ///        "state_district": "North 24 Parganas",
  ///        "state": "West Bengal",
  ///        "postcode": "700156",
  ///        "country": "India",
  ///        "country_code": "in"
  ///    },
  ///    "boundingbox": [
  ///        "22.5757142",
  ///        "22.5814173",
  ///        "88.4881895",
  ///        "88.4902436"
  ///    ]
  ///}
  ///

  Future<ReverseGeocoding?> reverseGeocoding(
      {required double latitude, required double longitude}) async {
    try {
      ApiReturnModel? v = await apiRepo().callApi(
          tag: "ReverseGeocoding",
          uri: ApiUrlConst.reverseGeocode,
          queryParameters: {"lat": latitude, "lon": longitude},
          method: Method.get);

      if (v?.statusCode == 200 && v?.responseString != null) {
        final xml2json = Xml2Json();
        xml2json.parse(v?.responseString ?? '');
        final jsonString = xml2json.toParker();
        final jsonObject = json.decode(jsonString);
        return ReverseGeocoding.fromJson(jsonObject["reversegeocode"]);
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
  /// {
  ///  "forward_geocoding": [
  ///    {
  ///      "place_id": 58435907,
  ///      "licence": "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
  ///      "powered_by": "Map Maker: https://maps.co",
  ///      "osm_type": "node",
  ///      "osm_id": 5044212195,
  ///      "boundingbox": [
  ///        "22.5815591",
  ///        "22.5816591",
  ///        "88.4526797",
  ///        "88.4527797"
  ///      ],
  ///      "lat": "22.5816091",
  ///      "lon": "88.4527297",
  ///      "display_name": "New Town, NBCC, AQ Block, New Town, Rajarhat, North 24 Parganas, West Bengal, 700 156, India",
  ///      "class": "highway",
  ///      "type": "bus_stop",
  ///      "importance": 0.9209999999999999
  ///    }
  ///  ]
  ///}
  ///
  ///

  Future<ForwardGeocoding?> forwardGeocoding({required String address}) async {
    try {
      var request = http.Request(
          'GET', Uri.parse('https://geocode.maps.co/search?q=$address'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String reponseBody = await response.stream.bytesToString();
        return ForwardGeocoding.fromJson(
            {"encoding_data": json.decode(reponseBody)});
      } else {
        AppLog.i(response.reasonPhrase ?? "");
      }
    } catch (e) {
      AppLog.e(e.toString());
    }
    return null;
  }
}
