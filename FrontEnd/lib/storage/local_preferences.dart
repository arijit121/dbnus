import 'package:shared_preferences/shared_preferences.dart'
    deferred as shared_preferences;

import '../extension/logger_extension.dart';

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

  Future<void> setBool({required String key, required bool value}) async {
    try {
      await shared_preferences.loadLibrary();
      final prefs = await shared_preferences.SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<bool?> getBool({required String key}) async {
    try {
      await shared_preferences.loadLibrary();
      final prefs = await shared_preferences.SharedPreferences.getInstance();
      return prefs.getBool(key);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<void> setString({required String key, required String value}) async {
    try {
      await shared_preferences.loadLibrary();
      final prefs = await shared_preferences.SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<String?> getString({required String key}) async {
    try {
      await shared_preferences.loadLibrary();
      final prefs = await shared_preferences.SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<bool> clearKey({required String key}) async {
    await shared_preferences.loadLibrary();
    final prefs = await shared_preferences.SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}
