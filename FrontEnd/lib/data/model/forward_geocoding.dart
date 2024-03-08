class ForwardGeocoding {
  List<EncodingData>? encodingData;

  ForwardGeocoding({this.encodingData});

  ForwardGeocoding.fromJson(Map<String, dynamic> json) {
    if (json['encoding_data'] != null) {
      encodingData = <EncodingData>[];
      json['encoding_data'].forEach((v) {
        encodingData!.add(EncodingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (encodingData != null) {
      data['encoding_data'] = encodingData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EncodingData {
  int? placeId;
  String? licence;
  String? poweredBy;
  String? osmType;
  int? osmId;
  List<String>? boundingBox;
  String? lat;
  String? lon;
  String? displayName;
  String? classData;
  String? type;
  double? importance;

  EncodingData(
      {this.placeId,
      this.licence,
      this.poweredBy,
      this.osmType,
      this.osmId,
      this.boundingBox,
      this.lat,
      this.lon,
      this.displayName,
      this.classData,
      this.type,
      this.importance});

  EncodingData.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    licence = json['licence'];
    poweredBy = json['powered_by'];
    osmType = json['osm_type'];
    osmId = json['osm_id'];
    boundingBox = json['boundingbox'].cast<String>();
    lat = json['lat'];
    lon = json['lon'];
    displayName = json['display_name'];
    classData = json['class'];
    type = json['type'];
    importance = json['importance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['place_id'] = placeId;
    data['licence'] = licence;
    data['powered_by'] = poweredBy;
    data['osm_type'] = osmType;
    data['osm_id'] = osmId;
    data['boundingbox'] = boundingBox;
    data['lat'] = lat;
    data['lon'] = lon;
    data['display_name'] = displayName;
    data['class'] = classData;
    data['type'] = type;
    data['importance'] = importance;
    return data;
  }
}
