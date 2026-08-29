import 'dart:async';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;
import 'package:uuid/uuid.dart';

import '../../shared/extensions/logger_extension.dart';
import '../models/position.dart';
import '../storage/local_preferences.dart';

class AppConfig {
  Future<String?> getAppVersion() async {
    return "1.0.0";
  }

  Future<String?> getAppPackageName() async {
    return "com.dbnus.app";
  }

  Future<String?> getAppVersionCode() async {
    return "1";
  }

  Future<String?> _getBrowserId() async {
    try {
      final localPrefs = LocalPreferences();
      String? id = await localPrefs.getString(key: LocalPreferences.browserId);
      if (id != null && id.isNotEmpty) {
        return id;
      }
      id = const Uuid().v4();
      await localPrefs.setString(key: LocalPreferences.browserId, value: id);
      return id;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return const Uuid().v4();
    }
  }

  Future<String?> getUserAgent() async {
    try {
      return web.window.navigator.userAgent;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  Future<String?> getAppType() async {
    try {
      final ua = web.window.navigator.userAgent.toLowerCase();
      if (ua.contains("mobile") || ua.contains("android") || ua.contains("iphone")) {
        return "msite";
      }
      return "web";
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return "web";
  }

  String? getOsName() {
    return "web";
  }

  Future<String?> getDeviceId() async {
    return await _getBrowserId();
  }

  Future<String?> getDeviceName() async {
    try {
      return web.window.navigator.appName;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<String?> getDeviceOsInfo() async {
    try {
      return web.window.navigator.userAgent;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  String? getDeviceWidth() {
    try {
      return web.window.screen.width.toString();
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  String? getDeviceHeight() {
    try {
      return web.window.screen.height.toString();
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  Future<String?> getNetworkInfo() async {
    try {
      return web.window.navigator.onLine ? "online" : "offline";
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }

  Future<String?> getWifiIpV4() async {
    return null;
  }

  Future<String?> getWifiIpV6() async {
    return null;
  }

  Future<Position?> getCurrentPosition({bool? handleDeniedForever}) async {
    try {
      final geolocation = web.window.navigator.geolocation;
      final completer = Completer<Position?>();
      geolocation.getCurrentPosition(
        (web.GeolocationPosition pos) {
          completer.complete(
            Position(
              latitude: pos.coords.latitude.toDouble(),
              longitude: pos.coords.longitude.toDouble(),
              timestamp: DateTime.fromMillisecondsSinceEpoch(pos.timestamp),
              accuracy: pos.coords.accuracy.toDouble(),
              altitude: pos.coords.altitude?.toDouble() ?? 0.0,
              altitudeAccuracy: pos.coords.altitudeAccuracy?.toDouble() ?? 0.0,
              heading: pos.coords.heading?.toDouble() ?? 0.0,
              headingAccuracy: 0.0,
              speed: pos.coords.speed?.toDouble() ?? 0.0,
              speedAccuracy: 0.0,
            ),
          );
        }.toJS,
        (web.GeolocationPositionError err) {
          completer.complete(null);
        }.toJS,
      );
      return completer.future;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return null;
    }
  }
}
