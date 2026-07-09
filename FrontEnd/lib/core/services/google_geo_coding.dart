import 'dart:convert';

import 'package:sastasundar/service/value_handler.dart';
import 'package:uuid/uuid.dart';

import '../../../data/api_client/imp/api_repo_imp.dart';
import '../../../data/api_client/repo/api_repo.dart';
import '../../../data/model/api_return_model.dart';
import '../../../data/model/location_model.dart';
import '../../../extension/logger_extension.dart';
import '../../../storage/local_preferences.dart';

class GoogleGeoCodingV2 {
  final String _key = "AIzaSyDz0x8H1ijyGAbQEtsznK3glcrUEEtNA4M";
  final String _geocodeApi =
      "https://maps.googleapis.com/maps/api/geocode/json";
  final String _placesApi = "https://places.googleapis.com/v1/places";

  String? _extractAddressName(List<dynamic> addressComponents) {
    // Priority 1: establishment or point_of_interest
    for (var component in addressComponents) {
      List<dynamic> types = component['types'] ?? [];
      if (types.any((t) =>
          ["establishment", "point_of_interest", "landmark"].contains(t))) {
        return component['longText'] ??
            component['long_name'] ??
            component['shortText'] ??
            component['short_name'];
      }
    }
    // Priority 2: premise (if not just numeric)
    for (var component in addressComponents) {
      List<dynamic> types = component['types'] ?? [];
      if (types.contains("premise")) {
        String val = (component['longText'] ??
                component['long_name'] ??
                component['shortText'] ??
                component['short_name'] ??
                "")
            .toString();
        if (!RegExp(r'^\d+$').hasMatch(val)) {
          return val;
        }
      }
    }
    // Priority 3: sublocality or neighborhood
    for (var component in addressComponents) {
      List<dynamic> types = component['types'] ?? [];
      if (types.any((t) =>
          ["sublocality", "sublocality_level_1", "neighborhood"].contains(t))) {
        return component['longText'] ??
            component['long_name'] ??
            component['shortText'] ??
            component['short_name'];
      }
    }
    return null;
  }

  String? _formatAddress(String? address, {String? addressName}) {
    if (address == null) return null;
    // // Remove plus code (e.g. VJ64+G9H)
    // address =
    //     address.replaceAll(RegExp(r'^[A-Z0-9]{4}\+[A-Z0-9]{2,3},?\s*'), '');
    // // Remove leading house/plot/range numbers (e.g. 16-315, or 32,)
    // address = address.replaceFirst(RegExp(r'^\d+[-\d/]*\b,?\s*'), '');
    if (ValueHandler().isTextNotEmptyOrNull(addressName)) {
      List<String> parts = address.split(', ');
      parts.removeWhere((element) {
        String cleanElement = element.trim().toLowerCase();
        String cleanName = addressName!.trim().toLowerCase();
        List<String> cleanElementParts = cleanElement.split(' ');
        List<String> cleanNameParts = cleanName.split(' ');
        return cleanElement == cleanName ||
            cleanElementParts.any((part) => cleanNameParts.contains(part));
      });
      address = parts.join(', ');
    }
    // Clean up any double commas or leading/trailing separators resulting from removal
    address = address.replaceAll(RegExp(r',\s*,'), ',').trim();
    if (address.startsWith(',')) address = address.substring(1).trim();
    if (address.endsWith(',')) {
      address = address.substring(0, address.length - 1).trim();
    }
    return address;
  }

  String? _formatAddress2(String? address) {
    if (address == null) return null;
    // Remove plus code (e.g. VJ64+G9H)
    address =
        address.replaceAll(RegExp(r'^[A-Z0-9]{4}\+[A-Z0-9]{2,3},?\s*'), '');
    // Remove leading house/plot/range numbers (e.g. 16-315, or 32,)
    address = address.replaceFirst(RegExp(r'^\d+[-\d/]*\b,?\s*'), '');

    // Clean up any double commas or leading/trailing separators resulting from removal
    address = address.replaceAll(RegExp(r',\s*,'), ',').trim();
    if (address.startsWith(',')) address = address.substring(1).trim();
    if (address.endsWith(',')) {
      address = address.substring(0, address.length - 1).trim();
    }
    return address;
  }

  Future<LocationModel?> searchNearby(
      {required double latitude, required double longitude}) async {
    try {
      ApiReturnModel? response = await apiRepo().callApi(
        tag: "SearchNearby",
        uri: "$_placesApi:searchNearby",
        method: Method.post,
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _key,
          'X-Goog-FieldMask':
              'places.id,places.displayName,places.location,places.types,places.formattedAddress,places.viewport',
        },
        bodyData: BodyData.raw(
          body: {
            "maxResultCount": 3,
            "locationRestriction": {
              "circle": {
                "center": {
                  "latitude": latitude,
                  "longitude": longitude,
                },
                "radius": 25
              }
            }
          },
        ),
      );

      if (response?.statusCode == 200 && response?.responseString != null) {
        Map<String, dynamic> data = jsonDecode(response!.responseString!);
        List<dynamic> places = data['places'] ?? [];
        if (places.isNotEmpty) {
          // Pass 1: Look for establishment/POI/premise
          Map<String, dynamic>? bestPlace;
          for (var place in places) {
            List<dynamic> types = place['types'] ?? [];
            if (types.any((t) => [
                  "establishment",
                  "point_of_interest",
                  "landmark",
                  "premise"
                ].contains(t))) {
              bestPlace = place as Map<String, dynamic>?;
              break;
            }
          }
          bestPlace ??= places[0] as Map<String, dynamic>?;
          if (bestPlace != null) {
            String? addressName = bestPlace['displayName']?['text'];
            String? address = _formatAddress(bestPlace['formattedAddress'],
                addressName: addressName);

            double? placeLat = bestPlace['location']?['latitude'];
            double? placeLng = bestPlace['location']?['longitude'];

            double? neLat;
            double? neLng;
            double? swLat;
            double? swLng;

            var viewport = bestPlace['viewport'];
            if (viewport != null) {
              var low = viewport['low'];
              var high = viewport['high'];
              if (low != null && high != null) {
                neLat = high['latitude'];
                neLng = high['longitude'];
                swLat = low['latitude'];
                swLng = low['longitude'];
              }
            }

            String? postalCode;
            if (address != null) {
              final match = RegExp(r'\b\d{6}\b').firstMatch(address);
              if (match != null) {
                postalCode = match.group(0);
              }
            }

            return LocationModel(
              locationId: bestPlace['id'],
              addressName: addressName,
              address: address,
              lat: placeLat ?? latitude,
              lng: placeLng ?? longitude,
              neLat: neLat,
              neLng: neLng,
              swLat: swLat,
              swLng: swLng,
              pinCode: postalCode,
            );
          }
        }
      } else {
        AppLog.i(
            "searchNearby failed with status: ${response?.statusCode}, body: ${response?.responseString}");
      }
    } catch (e, s) {
      AppLog.e(e.toString(), stackTrace: s);
    }
    return null;
  }

  Future<LocationModel?> reverseGeocoding(
      {required double latitude, required double longitude}) async {
    try {
      ApiReturnModel? v = await apiRepo().callApi(
          tag: "ReverseGeocoding",
          uri: _geocodeApi,
          headers: {'Content-Type': 'application/json'},
          queryParameters: {"latlng": "$latitude,$longitude", "key": _key},
          method: Method.get);

      if (v?.statusCode == 200 && v?.responseString != null) {
        Map<String, dynamic> data = jsonDecode(v!.responseString!);
        List<dynamic> results = data['results'] ?? [];
        if (results.isEmpty) return null;

        Map<String, dynamic>? firstAddress;

        // Pass 1: Look for establishment/POI/premise
        for (final result in results) {
          var typesRaw = result['types'];
          if (typesRaw is List) {
            List<String> types = typesRaw.map((e) => e.toString()).toList();
            if (types.any((t) => [
                  "establishment",
                  "point_of_interest",
                  "premise"
                ].contains(t))) {
              firstAddress = result;
              break;
            }
          }
        }

        // Pass 2: Fallback to street_address
        if (firstAddress == null) {
          for (final result in results) {
            var typesRaw = result['types'];
            if (typesRaw is List) {
              List<String> types = typesRaw.map((e) => e.toString()).toList();
              if (types.contains("street_address")) {
                firstAddress = result;
                break;
              }
            }
          }
        }

        // Pass 3: Fallback to first result
        firstAddress ??= results.isNotEmpty ? results[0] : null;

        String? addressName;
        String? formattedAddress;
        String? postalCode;
        double? neLat;
        double? neLng;
        double? swLat;
        double? swLng;

        if (firstAddress != null) {
          formattedAddress = _formatAddress(firstAddress['formatted_address']);

          var addressComponents = firstAddress['address_components'] as List?;
          if (addressComponents != null) {
            addressName = _extractAddressName(addressComponents);

            // Find postal code
            for (var component in addressComponents) {
              List<dynamic> types = component['types'] ?? [];
              if (types.contains('postal_code')) {
                postalCode = component['short_name'] ?? component['long_name'];
                break;
              }
            }
          }
          addressName ??= formattedAddress?.split(',').first.trim();

          var geometry = firstAddress['geometry'];
          if (geometry != null) {
            var bounds = geometry['bounds'] ?? geometry['viewport'];
            if (bounds != null) {
              var ne = bounds['northeast'];
              var sw = bounds['southwest'];
              if (ne != null) {
                neLat = ne['lat'] != null
                    ? double.tryParse(ne['lat'].toString())
                    : null;
                neLng = ne['lng'] != null
                    ? double.tryParse(ne['lng'].toString())
                    : null;
              }
              if (sw != null) {
                swLat = sw['lat'] != null
                    ? double.tryParse(sw['lat'].toString())
                    : null;
                swLng = sw['lng'] != null
                    ? double.tryParse(sw['lng'].toString())
                    : null;
              }
            }
          }
        }

        return LocationModel(
            pinCode: postalCode,
            address: formattedAddress,
            addressName: addressName,
            lat: latitude,
            lng: longitude,
            neLat: neLat,
            neLng: neLng,
            swLat: swLat,
            swLng: swLng);
      } else {
        AppLog.i(v?.responseString ?? "");
      }
    } catch (e) {
      AppLog.e(e.toString());
    }
    return null;
  }

  Future<LocationModel?> reverseGeocodingV2(
      {required double latitude, required double longitude}) async {
    LocationModel? v =
        await searchNearby(latitude: latitude, longitude: longitude);
    v ??= await reverseGeocoding(latitude: latitude, longitude: longitude);
    if (v != null) {
      List<LocationModel>? v1 = await placeAutocomplete(input: v.address ?? "");
      v.address = _formatAddress2(v.address);
      String? name = (v1?.isNotEmpty == true &&
              ValueHandler().isTextNotEmptyOrNull(v1?.firstOrNull?.addressName))
          ? _formatAddress2(v1?.firstOrNull?.addressName)
          : null;
      if (ValueHandler().isTextNotEmptyOrNull(name)) {
        v.addressName = name;
        return v;
      }
      return v;
    }
    return null;
  }

  Future<LocationModel?> geocoding({required String address}) async {
    try {
      ApiReturnModel? v = await apiRepo().callApi(
          tag: "Geocoding",
          uri: _geocodeApi,
          headers: {'Content-Type': 'application/json'},
          queryParameters: {"address": address, "key": _key},
          method: Method.get);

      if (v?.statusCode == 200 && v?.responseString != null) {
        Map<String, dynamic> data = jsonDecode(v!.responseString!);
        List<dynamic> results = data['results'] ?? [];
        if (results.isEmpty) return null;
        var result = results[0];

        String? formattedAddress = result['formatted_address'];
        String? postalCode;
        double? neLat;
        double? neLng;
        double? swLat;
        double? swLng;
        double? lat;
        double? lng;

        var addressComponents = result['address_components'] as List?;
        if (addressComponents != null) {
          for (var component in addressComponents) {
            List<dynamic> types = component['types'] ?? [];
            if (types.contains('postal_code')) {
              postalCode = component['short_name'] ?? component['long_name'];
              break;
            }
          }
        }

        var geometry = result['geometry'];
        if (geometry != null) {
          var location = geometry['location'];
          if (location != null) {
            lat = location['lat'] != null
                ? double.tryParse(location['lat'].toString())
                : null;
            lng = location['lng'] != null
                ? double.tryParse(location['lng'].toString())
                : null;
          }
          var bounds = geometry['bounds'] ?? geometry['viewport'];
          if (bounds != null) {
            var ne = bounds['northeast'];
            var sw = bounds['southwest'];
            if (ne != null) {
              neLat = ne['lat'] != null
                  ? double.tryParse(ne['lat'].toString())
                  : null;
              neLng = ne['lng'] != null
                  ? double.tryParse(ne['lng'].toString())
                  : null;
            }
            if (sw != null) {
              swLat = sw['lat'] != null
                  ? double.tryParse(sw['lat'].toString())
                  : null;
              swLng = sw['lng'] != null
                  ? double.tryParse(sw['lng'].toString())
                  : null;
            }
          }
        }

        return LocationModel(
            pinCode: postalCode,
            address: formattedAddress,
            lat: lat,
            lng: lng,
            neLat: neLat,
            neLng: neLng,
            swLat: swLat,
            swLng: swLng);
      } else {
        AppLog.i(v?.responseString ?? "");
      }
    } catch (e) {
      AppLog.e(e.toString());
    }
    return null;
  }

  Future<List<LocationModel>?> placeAutocomplete(
      {required String input}) async {
    try {
      String sessionToken = await _getSessionToken();

      ApiReturnModel? response = await apiRepo().callApi(
          tag: "PlaceAutocomplete",
          uri: "$_placesApi:autocomplete",
          method: Method.post,
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': _key,
          },
          bodyData: BodyData.raw(body: {
            "input": input,
            "sessionToken": sessionToken,
            "includedRegionCodes": ["IN"]
          }));

      if (response?.statusCode == 200 && response?.responseString != null) {
        Map<String, dynamic> data = jsonDecode(response!.responseString!);
        List<dynamic> suggestions = data['suggestions'] ?? [];
        List<LocationModel> locationModels = [];
        for (var element in suggestions) {
          var placePrediction = element['placePrediction'];
          if (placePrediction != null) {
            List<dynamic> types = placePrediction['types'] ?? [];
            bool hasAny = types.any((t) => [
                  "street_address",
                  "premise",
                  "establishment",
                  "postal_code"
                ].contains(t));
            if (hasAny) {
              locationModels.add(LocationModel(
                  locationId: placePrediction["placeId"],
                  address: placePrediction["text"]?["text"]?.toString().trim(),
                  addressName: placePrediction["structuredFormat"]?["mainText"]
                          ?["text"]
                      ?.toString()));
            }
          }
        }
        return locationModels;
      } else {
        AppLog.i(response?.responseString ?? "No response");
      }
    } catch (e, s) {
      AppLog.e(e.toString(), stackTrace: s);
    }
    return null;
  }

  Future<LocationModel?> placeDetails({required String placeId}) async {
    try {
      String sessionToken = await _getSessionToken();

      ApiReturnModel? response = await apiRepo().callApi(
        tag: "PlaceDetails",
        uri: "$_placesApi/$placeId",
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _key,
          'X-Goog-FieldMask':
              'id,displayName,formattedAddress,location,viewport,addressComponents',
        },
        queryParameters: {"sessionToken": sessionToken},
        method: Method.get,
      );

      if (response?.statusCode == 200 && response?.responseString != null) {
        Map<String, dynamic> data = jsonDecode(response!.responseString!);
        String? addressName = data['displayName']?['text'];
        String? address = _formatAddress(
            data['formattedAddress'] ?? data['formatted_address'],
            addressName: addressName);

        String? postalCode;
        double? neLat;
        double? neLng;
        double? swLat;
        double? swLng;
        double? lat;
        double? lng;

        var addressComponents =
            data['addressComponents'] ?? data['address_components'];
        if (addressComponents is List) {
          // Extract address name if not already found
          if (addressName == null) {
            // Check for establishment, POI, or premise
            for (var component in addressComponents) {
              List<dynamic> types = component['types'] ?? [];
              if (types.any((t) => [
                    "establishment",
                    "point_of_interest",
                    "landmark"
                  ].contains(t))) {
                addressName = component['longText'] ??
                    component['long_name'] ??
                    component['shortText'] ??
                    component['short_name'];
                break;
              }
            }
            if (addressName == null) {
              for (var component in addressComponents) {
                List<dynamic> types = component['types'] ?? [];
                if (types.contains("premise")) {
                  String val = (component['longText'] ??
                          component['long_name'] ??
                          component['shortText'] ??
                          component['short_name'] ??
                          "")
                      .toString();
                  if (!RegExp(r'^\d+$').hasMatch(val)) {
                    addressName = val;
                    break;
                  }
                }
              }
            }
          }

          // Extract postal code
          for (var component in addressComponents) {
            List<dynamic> types = component['types'] ?? [];
            if (types.contains('postal_code')) {
              postalCode = component['shortText'] ??
                  component['short_name'] ??
                  component['longText'] ??
                  component['long_name'];
              break;
            }
          }
        }
        addressName ??= address?.split(',').first.trim();

        // Parse coordinates
        var location = data['location'] ?? data['geometry']?['location'];
        if (location != null) {
          var latVal = location['latitude'] ?? location['lat'];
          var lngVal = location['longitude'] ?? location['lng'];
          lat = latVal != null ? double.tryParse(latVal.toString()) : null;
          lng = lngVal != null ? double.tryParse(lngVal.toString()) : null;
        }

        // Parse viewport / bounds
        var viewport = data['viewport'] ??
            data['geometry']?['viewport'] ??
            data['geometry']?['bounds'];
        if (viewport != null) {
          var low = viewport['low'] ?? viewport['southwest'];
          var high = viewport['high'] ?? viewport['northeast'];
          if (low != null && high != null) {
            var lowLat = low['latitude'] ?? low['lat'];
            var lowLng = low['longitude'] ?? low['lng'];
            var highLat = high['latitude'] ?? high['lat'];
            var highLng = high['longitude'] ?? high['lng'];

            swLat = lowLat != null ? double.tryParse(lowLat.toString()) : null;
            swLng = lowLng != null ? double.tryParse(lowLng.toString()) : null;
            neLat =
                highLat != null ? double.tryParse(highLat.toString()) : null;
            neLng =
                highLng != null ? double.tryParse(highLng.toString()) : null;
          }
        }

        return LocationModel(
            locationId: placeId,
            pinCode: postalCode,
            address: address,
            addressName: addressName,
            lat: lat,
            lng: lng,
            neLat: neLat,
            neLng: neLng,
            swLat: swLat,
            swLng: swLng);
      } else {
        AppLog.i(response?.responseString ?? "No response");
      }
    } catch (e, s) {
      AppLog.e(e.toString(), stackTrace: s);
    }
    return null;
  }

  Future<String> _getSessionToken() async {
    String? sessionToken = await LocalPreferences()
        .getString(key: LocalPreferences.googleGeoCodingSessionToken);
    String? googleGeoCodingSessionTokenTime = await LocalPreferences()
        .getString(key: LocalPreferences.googleGeoCodingSessionTokenTime);
    Duration? duration;
    if (ValueHandler().isTextNotEmptyOrNull(googleGeoCodingSessionTokenTime)) {
      duration = ValueHandler().dateTimeCompare(
          dateTime: googleGeoCodingSessionTokenTime,
          compareWithDate: DateTime.now());
    }
    if (duration != null &&
        duration.inMinutes.abs() < 5 &&
        ValueHandler().isTextNotEmptyOrNull(sessionToken)) {
      return sessionToken!;
    } else {
      sessionToken = const Uuid().v4();
      await LocalPreferences().setString(
          key: LocalPreferences.googleGeoCodingSessionToken,
          value: sessionToken);
      await LocalPreferences().setString(
          key: LocalPreferences.googleGeoCodingSessionTokenTime,
          value: DateTime.now().toString());
      return sessionToken;
    }
  }
}
