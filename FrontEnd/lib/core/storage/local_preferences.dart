import 'package:shared_preferences/shared_preferences.dart'
    deferred as shared_preferences;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    deferred as secure_storage;
import 'package:dbnus/shared/extensions/logger_extension.dart';

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

  Future<void> setBool(
      {required String key,
      required bool value,
      bool isSecureStorage = false}) async {
    try {
      if (isSecureStorage) {
        await secure_storage.loadLibrary();
        final secureStorage = secure_storage.FlutterSecureStorage();
        await secureStorage.write(key: key, value: value.toString());
      } else {
        await shared_preferences.loadLibrary();
        final prefs = await shared_preferences.SharedPreferences.getInstance();
        await prefs.setBool(key, value);
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<bool?> getBool(
      {required String key, bool isSecureStorage = false}) async {
    try {
      if (isSecureStorage) {
        await secure_storage.loadLibrary();
        final secureStorage = secure_storage.FlutterSecureStorage();
        final val = await secureStorage.read(key: key);
        return ValueHandler.boolify(val);
      } else {
        await shared_preferences.loadLibrary();
        final prefs = await shared_preferences.SharedPreferences.getInstance();
        return prefs.getBool(key);
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<void> setString(
      {required String key,
      required String value,
      bool isSecureStorage = false}) async {
    try {
      if (isSecureStorage) {
        await secure_storage.loadLibrary();
        final secureStorage = secure_storage.FlutterSecureStorage();
        await secureStorage.write(key: key, value: value);
      } else {
        await shared_preferences.loadLibrary();
        final prefs = await shared_preferences.SharedPreferences.getInstance();
        await prefs.setString(key, value);
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<String?> getString(
      {required String key, bool isSecureStorage = false}) async {
    try {
      if (isSecureStorage) {
        await secure_storage.loadLibrary();
        final secureStorage = secure_storage.FlutterSecureStorage();
        return await secureStorage.read(key: key);
      } else {
        await shared_preferences.loadLibrary();
        final prefs = await shared_preferences.SharedPreferences.getInstance();
        return prefs.getString(key);
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<bool> clearKey(
      {required String key, bool isSecureStorage = false}) async {
    try {
      if (isSecureStorage) {
        await secure_storage.loadLibrary();
        final secureStorage = secure_storage.FlutterSecureStorage();
        await secureStorage.delete(key: key);
        return true;
      } else {
        await shared_preferences.loadLibrary();
        final prefs = await shared_preferences.SharedPreferences.getInstance();
        return await prefs.remove(key);
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return false;
  }
}
