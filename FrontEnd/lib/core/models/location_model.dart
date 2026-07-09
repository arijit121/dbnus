
import '../../shared/extensions/logger_extension.dart';

class LocationModel {
  String? locationId;
  String? pinCode;
  String? address;
  String? addressName;
  double? lat;
  double? lng;
  double? neLat;
  double? neLng;
  double? swLat;
  double? swLng;

  LocationModel(
      {this.locationId,
      this.pinCode,
      this.address,
      this.addressName,
      this.lat,
      this.lng,
      this.neLat,
      this.neLng,
      this.swLat,
      this.swLng});

  LocationModel.fromJson(Map<String, dynamic> json) {
    try {
      locationId = json['locationId'];
      pinCode = json['pinCode'];
      address = json['address'];
      addressName = json['addressName'];
      lat = json['lat'];
      lng = json['long'];
      neLat = json['neLat'];
      neLng = json['neLng'];
      swLat = json['swLat'];
      swLng = json['swLng'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['locationId'] = locationId;
    data['pinCode'] = pinCode;
    data['address'] = address;
    data['addressName'] = addressName;
    data['lat'] = lat;
    data['long'] = lng;
    data['neLat'] = neLat;
    data['neLng'] = neLng;
    data['swLat'] = swLat;
    data['swLng'] = swLng;
    return data;
  }
}
