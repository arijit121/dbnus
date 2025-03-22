import 'dart:convert';

import '../data/model/user_model.dart';
import '../extension/logger_extension.dart';
import 'local_preferences.dart' deferred as local_preferences;

class UserPreference {
  Future<bool?> isLogin() async {
    try {
      await local_preferences.loadLibrary();
      String? userVal = await local_preferences.LocalPreferences()
          .getString(key: local_preferences.LocalPreferences.userDetailsKey);
      if (userVal != null) {
        Map<String, dynamic> userJson = json.decode(userVal);
        UserModel userModel = UserModel.fromJson(userJson);
        return userModel.custUserId?.isNotEmpty;
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<UserModel?> getData() async {
    try {
      await local_preferences.loadLibrary();
      String? userVal = await local_preferences.LocalPreferences()
          .getString(key: local_preferences.LocalPreferences.userDetailsKey);
      if (userVal != null) {
        Map<String, dynamic> userJson = json.decode(userVal);
        UserModel userModel = UserModel.fromJson(userJson);
        return userModel;
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<void> saveData({required UserModel userModel}) async {
    try {
      await local_preferences.loadLibrary();
      await local_preferences.LocalPreferences().setString(
          key: local_preferences.LocalPreferences.userDetailsKey,
          value: json.encode(userModel.toJson()));
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<bool> clearData() async {
    await local_preferences.loadLibrary();
    return await local_preferences.LocalPreferences()
        .clearKey(key: local_preferences.LocalPreferences.userDetailsKey);
  }
}
