import 'dart:async';
import 'package:universal_web/web.dart' as web;
import '../../shared/extensions/logger_extension.dart';
import '../services/value_handler.dart';

class LocalPreferences {
  static const String intoPageVisitedKey = "IntoPageVisited";
  static const String userDetailsKey = "userDetails";
  static const String pinCodeKey = "pinCode";
  static const String isPinCodeAsked = "isPinCodeAsked";
  static const String browserId = "BrowserId";
  static const String hiveEncryptionKey = "HiveEncryptionKey";
  static const String localizationKey = "LocalizationKey";
  static const String webTryCatchPaymentData = "WebTryCatchPaymentData";
  static const String ssIpV4 = "SSIpV4";
  static const String ssIpV6 = "SSIpV6";

  Future<void> setBool({
    required String key,
    required bool value,
    bool isSecureStorage = false,
  }) async {
    try {
      web.window.localStorage.setItem(key, value.toString());
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<bool?> getBool({
    required String key,
    bool isSecureStorage = false,
  }) async {
    try {
      final val = web.window.localStorage.getItem(key);
      return ValueHandler.boolify(val);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<void> setString({
    required String key,
    required String value,
    bool isSecureStorage = false,
  }) async {
    try {
      web.window.localStorage.setItem(key, value);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<String?> getString({
    required String key,
    bool isSecureStorage = false,
  }) async {
    try {
      return web.window.localStorage.getItem(key);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<bool> clearKey({
    required String key,
    bool isSecureStorage = false,
  }) async {
    try {
      web.window.localStorage.removeItem(key);
      return true;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return false;
  }
}
