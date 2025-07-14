import '../data/model/app_type_version_param.dart';
import '../data/model/headers.dart';
import '../extension/logger_extension.dart';
import 'app_config.dart' deferred as app_config;

class ApiConfig {
  static Future<Map<String, String>> getHeaders({
    bool? isPinCodeRequired,
    bool? onlyContentType,
    bool? noToken,
    ContentType? contentType = ContentType.json,
    bool? withoutOldHeader,
  }) async {
    try {
      await app_config.loadLibrary();

      if (onlyContentType == true) {
        return Headers(contentType: contentType?.value).toJson();
      }

      final appConfig = app_config.AppConfig();

      // Get all necessary app and device information

      final results = await Future.wait([
        appConfig.getAppVersion(),
        appConfig.getAppVersionCode(),
        appConfig.getDeviceId(),
        appConfig.getDeviceName(),
        appConfig.getDeviceOsInfo(),
        appConfig.getNetworkInfo(),
        appConfig.getWifiIpV4(),
        appConfig.getWifiIpV6(),
      ]);

      final appVersion = results[0];
      final appVersionCode = results[1];
      final deviceId = results[2];
      final deviceName = results[3];
      final deviceOsInfo = results[4];
      final networkInfo = results[5];
      final deviceIpV4 = results[6];
      final deviceIpV6 = results[7];

      final headers = Headers(
        contentType: contentType?.value,
        appType: appConfig.getAppType(),
        appVersion: appVersion,
        appVersionCode: appVersionCode,
        deviceId: deviceId,
        deviceName: deviceName,
        deviceOsInfo: deviceOsInfo,
        deviceWidth: appConfig.getDeviceWidth(),
        deviceHeight: appConfig.getDeviceHeight(),
        deviceDensity: "560",
        deviceDensityType: "xhdpi",
        networkInfo: networkInfo,
        authorization: "Basic YWRtaW46MTIzNA==",
        deviceIpV4: deviceIpV4,
        deviceIpV6: deviceIpV6,
      );

      return headers.toJson();
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return {};
    }
  }

  static Future<Map<String, dynamic>> getParams({
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
