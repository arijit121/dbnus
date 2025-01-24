import 'dart:convert';
import 'dart:io';

// import 'package:custom_platform_device_id/platform_device_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_html/html.dart' as html;

import '../data/api_client/imp/api_repo_imp.dart';
import '../data/api_client/repo/api_repo.dart';
import '../data/connection/connection_status.dart';
import '../data/model/api_return_model.dart';
import '../extension/logger_extension.dart';
import '../service/JsService/provider/js_provider.dart';
import '../service/value_handler.dart';
import '../storage/local_preferences.dart';
import '../utils/screen_utils.dart';

class AppConfig {
  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> getAppPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  Future<String> getAppVersionCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  Future<String?> _getBrowserId() async {
    String? browserId =
        await LocalPreferences().getString(key: LocalPreferences.browserId);
    if (ValueHandler().isTextNotEmptyOrNull(browserId)) {
      return browserId;
    } else {
      String? browserId = await JsProvider().getDeviceId();
      await LocalPreferences()
          .setString(key: LocalPreferences.browserId, value: browserId ?? "");
      return browserId;
    }
  }

  String getUserAgent() {
    return html.window.navigator.userAgent;
  }

  String? getAppType() {
    try {
      if (kIsWeb) {
        return "M";
      } else {
        return Platform.operatingSystem[0].toUpperCase();
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  String? getOsName() {
    try {
      if (kIsWeb) {
        return "web";
      } else {
        return Platform.operatingSystem.toLowerCase();
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<String?> getDeviceId() async {
    try {
      if (kIsWeb) {
        return await _getBrowserId();
      }
      String? deviceId;

      deviceId = await FlutterUdid.udid;

      return deviceId;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<String?> getDeviceName() async {
    if (kIsWeb) {
      return null;
    } else if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    } else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return iosInfo.utsname.machine;
    }
  }

  Future<String?> getDeviceOsInfo() async {
    if (kIsWeb) {
      return null;
    } else if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.release;
    } else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return iosInfo.systemVersion;
    }
  }

  String getDeviceWidth() {
    return ScreenUtils.aw().toString();
  }

  String getDeviceHeight() {
    return ScreenUtils.ah().toString();
  }

  Future<String> getNetworkInfo() async {
    ConnectionStatus connectionStatus = ConnectionStatus.getInstance;
    String networkInfo = await connectionStatus.getNetworkInfo();
    return networkInfo;
  }

  Future<String?> getWifiIpV4() async {
    if (kIsWeb) {
      return await _getIpFromInternet(
          tag: 'WifiIpV4', uri: 'https://api.ipify.org?format=json');
    } else {
      final info = NetworkInfo();
      var wifiIP = await info.getWifiIP();
      if (ValueHandler().isTextNotEmptyOrNull(wifiIP)) {
        return wifiIP;
      } else {
        return await _getIpFromInternet(
            tag: 'WifiIpV4', uri: 'https://api.ipify.org?format=json');
      }
    }
  }

  Future<String?> getWifiIpV6() async {
    if (kIsWeb) {
      return await _getIpFromInternet(
          tag: 'WifiIpV6', uri: 'https://api6.ipify.org?format=json');
    } else {
      final info = NetworkInfo();
      var wifiIPv6 = await info.getWifiIPv6();
      if (ValueHandler().isTextNotEmptyOrNull(wifiIPv6)) {
        return wifiIPv6;
      } else {
        return await _getIpFromInternet(
            tag: 'WifiIpV6', uri: 'https://api6.ipify.org?format=json');
      }
    }
  }

  Future<String?> _getIpFromInternet(
      {required String tag, required String uri}) async {
    ConnectionStatus connectionStatus = ConnectionStatus.getInstance;
    bool onlineStatus = await connectionStatus.checkConnection();
    if (onlineStatus) {
      ApiReturnModel? response =
          await apiRepo().callApi(tag: tag, uri: uri, method: Method.get);
      if (response?.responseString != null && response?.statusCode == 200) {
        var v = json.decode(response?.responseString ?? "");
        return v['ip'];
      }
    }
    return null;
  }
}
