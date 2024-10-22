import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extension/hex_color.dart';
import 'color_const.dart';

class ThemeConst {
  static SystemUiOverlayStyle systemOverlayStyle = const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemStatusBarContrastEnforced: true,
    statusBarColor: Colors.white,
  );

  static AppBarTheme appBarTheme =
      AppBarTheme(systemOverlayStyle: systemOverlayStyle, titleSpacing: 0);

  static ThemeData theme = ThemeData(
    pageTransitionsTheme: kIsWeb ? NoTransitionsOnWeb() : null,
    colorSchemeSeed: ColorConst.baseHexColor,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    appBarTheme: appBarTheme,
  );

  static ThemeData darkTheme = ThemeData(
    pageTransitionsTheme: kIsWeb ? NoTransitionsOnWeb() : null,
    colorSchemeSeed: ColorConst.baseHexColor,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.dark,
    appBarTheme: appBarTheme,
  );
}

class NoTransitionsOnWeb extends PageTransitionsTheme {
  @override
  Widget buildTransitions<T>(
    route,
    context,
    animation,
    secondaryAnimation,
    child,
  ) {
    if (kIsWeb) {
      return child;
    }
    return super.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
