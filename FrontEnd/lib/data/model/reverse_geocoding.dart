// ignore_for_file: unnecessary_new

import '../../extension/logger_extension.dart';

class ReverseGeocoding {
  int? placeId;
  String? osmType;
  int? osmId;
  int? placeRank;
  String? category;
  String? type;
  double? importance;
  String? addresstype;
  String? name;
  String? displayName;
  Address? address;

  ReverseGeocoding(
      {this.placeId,
      this.osmType,
      this.osmId,
      this.placeRank,
      this.category,
      this.type,
      this.importance,
      this.addresstype,
      this.name,
      this.displayName,
      this.address});

  ReverseGeocoding.fromJson(Map<String, dynamic> json) {
    try {
      placeId = json['place_id'];
      osmType = json['osm_type'];
      osmId = json['osm_id'];
      placeRank = json['place_rank'];
      category = json['category'];
      type = json['type'];
      importance = json['importance'];
      addresstype = json['addresstype'];
      name = json['name'];
      displayName = json['display_name'];
      address = json['address'] != null
          ? new Address.fromJson(json['address'])
          : null;
    } catch (e, s) {
      AppLog.e(e, stackTrace: s);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['place_id'] = placeId;
    data['osm_type'] = osmType;
    data['osm_id'] = osmId;
    data['place_rank'] = placeRank;
    data['category'] = category;
    data['type'] = type;
    data['importance'] = importance;
    data['addresstype'] = addresstype;
    data['name'] = name;
    data['display_name'] = displayName;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class Address {
  String? village;
  String? province;
  String? state;
  String? iSO31662Lvl4;
  String? country;
  String? countryCode;

  Address(
      {this.village,
      this.province,
      this.state,
      this.iSO31662Lvl4,
      this.country,
      this.countryCode});

  Address.fromJson(Map<String, dynamic> json) {
    try {
      village = json['village'];
      province = json['province'];
      state = json['state'];
      iSO31662Lvl4 = json['ISO3166-2-lvl4'];
      country = json['country'];
      countryCode = json['country_code'];
    } catch (e, s) {
      AppLog.e(e, stackTrace: s);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['village'] = village;
    data['province'] = province;
    data['state'] = state;
    data['ISO3166-2-lvl4'] = iSO31662Lvl4;
    data['country'] = country;
    data['country_code'] = countryCode;
    return data;
  }
}
