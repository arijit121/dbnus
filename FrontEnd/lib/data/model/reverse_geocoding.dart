import '../../extension/logger_extension.dart';

class ReverseGeocoding {
  String? result;
  Addressparts? addressparts;

  ReverseGeocoding({this.result, this.addressparts});

  ReverseGeocoding.fromJson(Map<String, dynamic> json) {
    try {
      result = json['result'];
      addressparts = json['addressparts'] != null
          ? Addressparts.fromJson(json['addressparts'])
          : null;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    if (addressparts != null) {
      data['addressparts'] = addressparts!.toJson();
    }
    return data;
  }
}

class Addressparts {
  String? suburb;
  String? city;
  String? stateDistrict;
  String? state;
  String? iSO31662Lvl4;
  String? postcode;
  String? country;
  String? countryCode;

  Addressparts(
      {this.suburb,
      this.city,
      this.stateDistrict,
      this.state,
      this.iSO31662Lvl4,
      this.postcode,
      this.country,
      this.countryCode});

  Addressparts.fromJson(Map<String, dynamic> json) {
    try {
      suburb = json['suburb'];
      city = json['city'];
      stateDistrict = json['state_district'];
      state = json['state'];
      iSO31662Lvl4 = json['ISO3166-2-lvl4'];
      postcode = json['postcode'];
      country = json['country'];
      countryCode = json['country_code'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['suburb'] = suburb;
    data['city'] = city;
    data['state_district'] = stateDistrict;
    data['state'] = state;
    data['ISO3166-2-lvl4'] = iSO31662Lvl4;
    data['postcode'] = postcode;
    data['country'] = country;
    data['country_code'] = countryCode;
    return data;
  }
}
