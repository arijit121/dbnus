import 'dart:convert';

import 'package:dbnus/router/custom_router/custom_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../extension/logger_extension.dart';
import '../../../router/router_name.dart';

class CrashUtils {
  String crashUiKey = "CrashUiKeyPref";
  String crashKey = "CrashKey";

  Future<void> setValue({required bool value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(crashUiKey, value);
  }

  Future<void> navigateToCrashPage(Map<String, dynamic>? args) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool nav = prefs.getBool(crashUiKey) ?? false;
    await setValue(value: true);

    if (!nav) {
      CustomRoute().pushNamed(name: RouteName.error, arguments: args);
    }
  }

  Future<void> logCrash({Map<String, dynamic>? args}) async {
    Map<String, dynamic> body = args ?? {};
    body.addAll({"current_route": CustomRoute().currentRoute()});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(crashKey, json.encode(body));
    AppLog.i(body, tag: "Log Crash");
  }
}
