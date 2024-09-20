import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/navigationService.dart';
import '../../../utils/routes/routes_name.dart';

class CrashUtils {
  String crashUiKey = "crashUiKeyPref";

  Future<void> setValue({required bool value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(crashUiKey, value);
  }

  Future<void> navigateToCrashPage(Map<String, dynamic>? args) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool nav = prefs.getBool(crashUiKey) ?? false;
    await setValue(value: true);
    if (!nav) {
      await Navigator.pushNamedAndRemoveUntil(
          CurrentContext().context, MyRoutes.crashUi, ModalRoute.withName('/'),
          arguments: args);
    }
  }
}
