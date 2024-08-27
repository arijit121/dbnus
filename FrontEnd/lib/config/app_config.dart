import 'dart:io';

// import 'package:custom_platform_device_id/platform_device_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_html/html.dart' as html;

import '../data/connection/connection_status.dart';
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
    if (kIsWeb && kDebugMode) {
      return "55";
    }
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
        return Platform.isAndroid
            ? "A"
            : Platform.isIOS
            ? "I"
            : "";
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
        return Platform.operatingSystem;
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

      // deviceId = await PlatformDeviceId.getDeviceId;
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
}
