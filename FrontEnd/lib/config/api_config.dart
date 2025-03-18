import '../data/model/app_type_version_param.dart';
import '../data/model/headers.dart';
import 'app_config.dart' deferred as app_config;

class ApiConfig {
  Future<Map<String, String>> getHeaders(
      {bool? isPinCodeRequired,
      bool? onlyContentType,
      bool? noToken,
      ContentType? contentType = ContentType.json,
      bool? withoutOldHeader}) async {
    await Future.wait([
      app_config.loadLibrary(),
    ]);
    Headers headers;
    if (onlyContentType == true) {
      headers = Headers(contentType: contentType?.value);
    } else {
      headers = Headers(
        contentType: contentType?.value,
        appType: app_config.AppConfig().getAppType(),
        appVersion: await app_config.AppConfig().getAppVersion(),
        deviceId: await app_config.AppConfig().getDeviceId(),
        deviceDensityType: "xhdpi",
        deviceName: await app_config.AppConfig().getDeviceName(),
        networkInfo: await app_config.AppConfig().getNetworkInfo(),
        deviceWidth: app_config.AppConfig().getDeviceWidth(),
        deviceOsInfo: await app_config.AppConfig().getDeviceOsInfo(),
        deviceHeight: app_config.AppConfig().getDeviceHeight(),
        deviceDensity: "560",
        appVersionCode: await app_config.AppConfig().getAppVersionCode(),
        authorization: "Basic YWRtaW46MTIzNA==",
        deviceIpV6: await app_config.AppConfig().getWifiIpV6(),
        deviceIpV4: await app_config.AppConfig().getWifiIpV4(),
      );
    }
    return headers.toJson();
  }

  Future<Map<String, dynamic>> getParams({
    bool? isPinCodeRequired,
    // bool? warehouseID,
    // bool? isLab,
  }) async {
    await Future.wait([
      app_config.loadLibrary(),
    ]);
    Params appTypeVersionParam = Params(
      appType: app_config.AppConfig().getAppType(),
      appVersion: await app_config.AppConfig().getAppVersion(),
    );
    Map<String, dynamic> json = appTypeVersionParam.toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}

enum ContentType {
  json('application/json'),
  urlencoded_char_utf8('application/x-www-form-urlencoded; charset=utf-8'),
  textplain_char_utf8('text/plain; charset=utf-8'),
  xml('application/xml');

  final String value;

  const ContentType(this.value);
}
