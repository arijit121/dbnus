// ignore_for_file: unnecessary_this

import '../../extension/logger_extension.dart';

class ForwardGeocoding {
  double? latitude;
  double? longitude;

  ForwardGeocoding({this.latitude, this.longitude});

  ForwardGeocoding.fromJson(List json) {
    try {
      longitude = json[0];
      latitude = json[1];
    } catch (e, s) {
      AppLog.e(e, stackTrace: s);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
