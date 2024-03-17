import '../../extension/logger_extension.dart';

class Params {
  String? appType;
  String? appVersion;
  String? pinCode;

  Params({this.appType, this.appVersion, this.pinCode});

  Params.fromJson(Map<String, dynamic> json) {
    try {
      appType = json['AppType'];
      appVersion = json['AppVersion'];
      pinCode = json['Pincode'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (appType != null) {
      data['AppType'] = appType;
    }
    if (appVersion != null) {
      data['AppVersion'] = appVersion;
    }
    if (pinCode != null) {
      data['Pincode'] = pinCode;
    }
    return data;
  }
}
