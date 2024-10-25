import 'package:flutter/foundation.dart';

import '../data/model/app_type_version_param.dart';
import '../data/model/headers.dart';
import '../storage/user_preference.dart';
import 'app_config.dart';

class ApiConfig {
  Future<Map<String, String>> getHeaders(
      {bool? isPinCodeRequired,
      bool? isSearchUrl,
      bool? isArticleUrl,
      bool? onlyContentType,
      bool? noAuthentication,
      ContentType? contentType = ContentType.json}) async {
    Headers headers = onlyContentType == true
        ? Headers(
            contentType: contentType?.value,
          )
        : Headers(
            browserId: kIsWeb ? "${await AppConfig().getDeviceId()}" : null,
            appType: AppConfig().getAppType(),
            appVersion: await AppConfig().getAppVersion(),
            contentType: contentType?.value,
            authorization: "Basic YWRtaW46YWRtaW4=",
            deviceId: kIsWeb ? null : await AppConfig().getDeviceId(),
            deviceDensityType: "xhdpi",
            deviceName: await AppConfig().getDeviceName(),
            networkInfo: await AppConfig().getNetworkInfo(),
            deviceWidth: AppConfig().getDeviceWidth(),
            deviceOsInfo: await AppConfig().getDeviceOsInfo(),
            deviceHeight: AppConfig().getDeviceHeight(),
            deviceDensity: "560",
            appVersionCode: await AppConfig().getAppVersionCode(),
            rtoken: noAuthentication == true
                ? null
                : (await UserPreference().getData())?.rtoken,
            accessToken: noAuthentication == true
                ? null
                : (await UserPreference().getData())?.accessToken,
            deviceIpV6: await AppConfig().getWifiIpV6(),
            deviceIpV4: await AppConfig().getWifiIpV4());
    return headers.toJson();
  }

  Future<Map<String, dynamic>> getParams({bool? isPinCodeRequired}) async {
    Params appTypeVersionParam = Params(
      appType: AppConfig().getAppType(),
      appVersion: await AppConfig().getAppVersion(),
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
