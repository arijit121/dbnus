import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart' as device_info_plus;
import 'package:flutter/foundation.dart';
import 'package:flutter_udid/flutter_udid.dart' deferred as flutter_udid;
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart'
    deferred as package_info_plus;
import 'package:uuid/uuid.dart' deferred as uuid;
import '../data/api_client/imp/api_repo_imp.dart' deferred as api_repo_imp;
import '../data/api_client/repo/api_repo.dart' deferred as api_repo;
import '../data/connection/connection_status.dart'
    deferred as connection_status;

// import '../data/model/api_return_model.dart';
import '../data/connection/utils/connection_utils.dart'
    deferred as connection_utils;
import '../extension/logger_extension.dart';
import '../service/JsService/provider/js_provider.dart' deferred as js_provider;
import '../service/value_handler.dart' deferred as value_handler;
import '../storage/local_preferences.dart' deferred as local_preferences;

import '../utils/screen_utils.dart';

class AppConfig {
  Future<String?> getAppVersion() async {
    try {
      await package_info_plus.loadLibrary();
      final packageInfo = await package_info_plus.PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  Future<String?> getAppPackageName() async {
    try {
      await package_info_plus.loadLibrary();
      final packageInfo = await package_info_plus.PackageInfo.fromPlatform();
      return packageInfo.packageName;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  Future<String?> getAppVersionCode() async {
    try {
      await package_info_plus.loadLibrary();
      final packageInfo = await package_info_plus.PackageInfo.fromPlatform();
      return packageInfo.buildNumber;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  Future<String?> _getBrowserId() async {
    try {
      await Future.wait(
          [local_preferences.loadLibrary(), value_handler.loadLibrary()]);
      String? browserId = await local_preferences.LocalPreferences()
          .getString(key: local_preferences.LocalPreferences.browserId);
      if (value_handler.ValueHandler().isTextNotEmptyOrNull(browserId)) {
        return browserId;
      } else {
        await Future.wait([uuid.loadLibrary(), js_provider.loadLibrary()]);
        String? browserId = await js_provider.JsProvider().getDeviceId();
        await local_preferences.LocalPreferences().setString(
            key: local_preferences.LocalPreferences.browserId,
            value: browserId ?? uuid.Uuid().v4());
        return browserId;
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      await uuid.loadLibrary();
      String id = uuid.Uuid().v4();
      await local_preferences.LocalPreferences().setString(
          key: local_preferences.LocalPreferences.browserId, value: id);
      return id;
    }
  }

  Future<String?> getUserAgent() async {
    try {
      await js_provider.loadLibrary();
      return js_provider.JsProvider().getUserAgent();
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  String? getAppType() {
    try {
      if (kIsWeb) {
        return "M";
      } else {
        return Platform.isAndroid
            ? "N"
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
      await flutter_udid.loadLibrary();
      String? deviceId;

      deviceId = await flutter_udid.FlutterUdid.udid;
      return deviceId;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  Future<String?> getDeviceName() async {
    try {
      if (kIsWeb) {
        final deviceInfo = device_info_plus.DeviceInfoPlugin();
        final webInfo = await deviceInfo.webBrowserInfo;
        return '${webInfo.browserName.name} - ${webInfo.platform}';
      } else if (Platform.isAndroid) {
        final deviceInfo = device_info_plus.DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.model;
      } else {
        final deviceInfo = device_info_plus.DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;

        return iosInfo.utsname.machine;
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<String?> getDeviceOsInfo() async {
    try {
      if (kIsWeb) {
        final deviceInfo = device_info_plus.DeviceInfoPlugin();
        final webInfo = await deviceInfo.webBrowserInfo;
        return '${webInfo.platform} ${webInfo.userAgent}';
      } else if (Platform.isAndroid) {
        final deviceInfo = device_info_plus.DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.version.release;
      } else {
        final deviceInfo = device_info_plus.DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;

        return iosInfo.systemVersion;
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  String? getDeviceWidth() {
    try {
      return ScreenUtils.aw().toString();
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  String? getDeviceHeight() {
    try {
      return ScreenUtils.ah().toString();
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  Future<String?> getNetworkInfo() async {
    try {
      await connection_status.loadLibrary();
      final connectionStatus = connection_status.ConnectionStatus.getInstance;
      String networkInfo = await connectionStatus.getNetworkInfo();
      return networkInfo;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  Future<String?> getWifiIpV4() async {
    try {
      await connection_utils.loadLibrary();
      return await connection_utils.ConnectionUtils().getIpV4();
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  Future<String?> getWifiIpV6() async {
    try {
      await connection_utils.loadLibrary();
      return await connection_utils.ConnectionUtils().getIpV6();
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  Future<String?> _getIpFromInternet(
      {required String tag, required String uri}) async {
    try {
      await Future.wait([
        connection_status.loadLibrary(),
        api_repo.loadLibrary(),
        api_repo_imp.loadLibrary()
      ]);
      final connectionStatus = connection_status.ConnectionStatus.getInstance;
      bool onlineStatus = await connectionStatus.checkConnection();
      if (onlineStatus) {
        final response = await api_repo
            .apiRepo()
            .callApi(tag: tag, uri: uri, method: api_repo_imp.Method.get);
        if (response?.responseString != null && response?.statusCode == 200) {
          var v = json.decode(response?.responseString ?? "");
          return v['ip'];
        }
      }
      return null;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  Future<Position?> getCurrentPosition({bool? handleDeniedForever}) async {
    try {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (kIsWeb || handleDeniedForever != true) {
          permission = await Geolocator.requestPermission();
        } else {
          await Geolocator.openAppSettings();
          permission = await Geolocator.checkPermission();
        }
        if (permission == LocationPermission.deniedForever) {
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }
      }

      return await Geolocator.getCurrentPosition();
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }
}
