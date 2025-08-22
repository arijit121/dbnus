import 'package:dbnus/widget/custom_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_const.dart';

class ThemeConst {
  static SystemUiOverlayStyle systemOverlayStyle = const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemStatusBarContrastEnforced: true,
    statusBarColor: Colors.transparent,
  );

  static AppBarTheme appBarTheme = AppBarTheme(
    systemOverlayStyle: systemOverlayStyle,
    titleSpacing: 0,
    color: Colors.white,
    foregroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    shadowColor: kIsWeb ? ColorConst.grey : ColorConst.lightGrey,
    iconTheme: IconThemeData(color: ColorConst.primaryDark),
    titleTextStyle: customizeTextStyle(
        fontColor: ColorConst.primaryDark,
        fontSize: 16,
        fontWeight: FontWeight.w600),
    elevation: 0.5,
    centerTitle: false,
  );

  static AppBarTheme darkAppBarTheme = AppBarTheme(
    systemOverlayStyle: systemOverlayStyle,
    titleSpacing: 0,
    color: ColorConst.baseHexColor,
    foregroundColor: ColorConst.baseHexColor,
    surfaceTintColor: ColorConst.baseHexColor,
    shadowColor: kIsWeb ? Colors.white38 : ColorConst.lightGrey,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: customizeTextStyle(
        fontColor: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
    elevation: 0.5,
    centerTitle: false,
  );

  static TextTheme textTheme = TextTheme(
    bodyLarge: customizeTextStyle(fontColor: ColorConst.primaryDark),
    // Replaces bodyText1
    bodyMedium: customizeTextStyle(fontColor: ColorConst.primaryDark),
    // Replaces bodyText2
    bodySmall: customizeTextStyle(fontColor: ColorConst.primaryDark),
    // For smaller body text
    labelLarge: customizeTextStyle(fontColor: ColorConst.primaryDark),
    // Replaces button
    labelMedium: customizeTextStyle(fontColor: ColorConst.primaryDark),
    labelSmall: customizeTextStyle(fontColor: ColorConst.primaryDark),
    // Replaces overline
    titleLarge: customizeTextStyle(fontColor: ColorConst.primaryDark),
    // Replaces headline5
    titleMedium: customizeTextStyle(fontColor: ColorConst.primaryDark),
    // Replaces headline6
    titleSmall: customizeTextStyle(fontColor: ColorConst.primaryDark),
    // Replaces subtitle1
    displayLarge: customizeTextStyle(fontColor: ColorConst.primaryDark),
    // Replaces headline1
    displayMedium: customizeTextStyle(fontColor: ColorConst.primaryDark),
    // Replaces headline2
    displaySmall: customizeTextStyle(fontColor: ColorConst.primaryDark),
    // Replaces headline3
    headlineLarge: customizeTextStyle(fontColor: ColorConst.primaryDark),
    headlineMedium: customizeTextStyle(fontColor: ColorConst.primaryDark),
    // Replaces headline4
    headlineSmall: customizeTextStyle(fontColor: ColorConst.primaryDark),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: customizeTextStyle(fontColor: Colors.white),
    // Replaces bodyText1
    bodyMedium: customizeTextStyle(fontColor: Colors.white),
    // Replaces bodyText2
    bodySmall: customizeTextStyle(fontColor: Colors.white),
    // For smaller body text
    labelLarge: customizeTextStyle(fontColor: Colors.white),
    // Replaces button
    labelMedium: customizeTextStyle(fontColor: Colors.white),
    labelSmall: customizeTextStyle(fontColor: Colors.white),
    // Replaces overline
    titleLarge: customizeTextStyle(fontColor: Colors.white),
    // Replaces headline5
    titleMedium: customizeTextStyle(fontColor: Colors.white),
    // Replaces headline6
    titleSmall: customizeTextStyle(fontColor: Colors.white),
    // Replaces subtitle1
    displayLarge: customizeTextStyle(fontColor: Colors.white),
    // Replaces headline1
    displayMedium: customizeTextStyle(fontColor: Colors.white),
    // Replaces headline2
    displaySmall: customizeTextStyle(fontColor: Colors.white),
    // Replaces headline3
    headlineLarge: customizeTextStyle(fontColor: Colors.white),
    headlineMedium: customizeTextStyle(fontColor: Colors.white),
    // Replaces headline4
    headlineSmall: customizeTextStyle(fontColor: Colors.white),
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
    scaffoldBackgroundColor: ColorConst.baseHexColor,
    brightness: Brightness.dark,
    appBarTheme: darkAppBarTheme,
    textTheme: darkTextTheme,
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
