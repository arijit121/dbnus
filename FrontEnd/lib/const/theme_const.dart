import 'package:dbnus/widget/custom_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_const.dart';

class ThemeConst {
  static SystemUiOverlayStyle systemOverlayStyle = const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemStatusBarContrastEnforced: true,
    statusBarColor: Colors.white,
  );

  static AppBarTheme appBarTheme = AppBarTheme(
    systemOverlayStyle: systemOverlayStyle,
    titleSpacing: 0,
    color: Colors.white,
    foregroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    shadowColor: kIsWeb ? ColorConst.grey : ColorConst.lightGrey,
    iconTheme: IconThemeData(color: ColorConst.primaryDark),
    elevation: 0.5,
  );

  static TextTheme textTheme = TextTheme(
    bodyLarge: customizeTextStyle(
        fontColor: ColorConst.primaryDark), // Replaces bodyText1
    bodyMedium: customizeTextStyle(
        fontColor: ColorConst.primaryDark), // Replaces bodyText2
    bodySmall: customizeTextStyle(fontColor: ColorConst.primaryDark),
    // For smaller body text
  );

  static ThemeData theme = ThemeData(
    pageTransitionsTheme: kIsWeb ? NoTransitionsOnWeb() : null,
    colorSchemeSeed: ColorConst.baseHexColor,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    appBarTheme: appBarTheme,
    textTheme: textTheme,
  );

  static ThemeData darkTheme = ThemeData(
    pageTransitionsTheme: kIsWeb ? NoTransitionsOnWeb() : null,
    colorSchemeSeed: ColorConst.baseHexColor,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.dark,
    appBarTheme: appBarTheme,
    textTheme: textTheme,
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
