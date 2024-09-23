import 'package:dbnus/router/custom_router/custom_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../router/router_name.dart';

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
      CustomRoute().pushNamed(name: RouteName.error, arguments: args);
    }
  }
}
