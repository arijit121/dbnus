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
      bool? noAuthentication}) async {
    Headers headers = onlyContentType == true
        ? Headers(
            contentType: "application/json",
          )
        : Headers(
            browserId: kIsWeb ? "${await AppConfig().getBrowserId()}" : null,
            appType: AppConfig().getAppType(),
            appVersion: await AppConfig().getAppVersion(),
            contentType: "application/json",
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
          );
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
