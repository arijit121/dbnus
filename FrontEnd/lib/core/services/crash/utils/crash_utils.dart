import 'dart:convert';

import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/navigation/router_name.dart';

class CrashUtils {
  static const String crashUiKey = "CrashUiKeyPref";
  static const String crashKey = "CrashKey";

  static Future<void> setValue({required bool value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(crashUiKey, value);
  }

  static Future<void> navigateToCrashPage(Map<String, dynamic>? args) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool nav = prefs.getBool(crashUiKey) ?? false;
    await CrashUtils.setValue(value: true);

    if (!nav) {
      CustomRoute.pushNamed(name: RouteName.error, arguments: args);
    }
  }

  static Future<void> logCrash({Map<String, dynamic>? args}) async {
    Map<String, dynamic> body = args ?? {};
    body.addAll({"current_route": CustomRoute.currentRoute()});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(crashKey, json.encode(body));
    AppLog.i(body, tag: "Log Crash");
  }
}
