import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'package:dbnus/shared/constants/color_const.dart';

class ThemeConst {
  static SystemUiOverlayStyle systemOverlayStyle = const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemStatusBarContrastEnforced: true,
    statusBarColor: Colors.transparent,
  );

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ),
    titleSpacing: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: const Color(0xFF0F172A),
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
    titleTextStyle: customizeTextStyle(
        fontColor: const Color(0xFF0F172A),
        fontSize: 16,
        fontWeight: FontWeight.w600),
    elevation: 0,
    centerTitle: false,
  );

  static AppBarTheme darkAppBarTheme = AppBarTheme(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
    titleSpacing: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: const Color(0xFFF8FAFC),
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Color(0xFFF8FAFC)),
    titleTextStyle: customizeTextStyle(
        fontColor: const Color(0xFFF8FAFC),
        fontSize: 16,
        fontWeight: FontWeight.w600),
    elevation: 0,
    centerTitle: false,
  );

  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: customizeTextStyle(fontColor: const Color(0xFF0F172A)),
    bodyMedium: customizeTextStyle(fontColor: const Color(0xFF334155)),
    bodySmall: customizeTextStyle(fontColor: const Color(0xFF64748B)),
    labelLarge: customizeTextStyle(fontColor: const Color(0xFF0F172A)),
    labelMedium: customizeTextStyle(fontColor: const Color(0xFF475569)),
    labelSmall: customizeTextStyle(fontColor: const Color(0xFF64748B)),
    titleLarge: customizeTextStyle(fontColor: const Color(0xFF0F172A), fontWeight: FontWeight.w600),
    titleMedium: customizeTextStyle(fontColor: const Color(0xFF1E293B), fontWeight: FontWeight.w600),
    titleSmall: customizeTextStyle(fontColor: const Color(0xFF334155), fontWeight: FontWeight.w500),
    displayLarge: customizeTextStyle(fontColor: const Color(0xFF0F172A)),
    displayMedium: customizeTextStyle(fontColor: const Color(0xFF1E293B)),
    displaySmall: customizeTextStyle(fontColor: const Color(0xFF334155)),
    headlineLarge: customizeTextStyle(fontColor: const Color(0xFF0F172A)),
    headlineMedium: customizeTextStyle(fontColor: const Color(0xFF1E293B)),
    headlineSmall: customizeTextStyle(fontColor: const Color(0xFF334155)),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: customizeTextStyle(fontColor: const Color(0xFFF8FAFC)),
    bodyMedium: customizeTextStyle(fontColor: const Color(0xFFE2E8F0)),
    bodySmall: customizeTextStyle(fontColor: const Color(0xFF94A3B8)),
    labelLarge: customizeTextStyle(fontColor: const Color(0xFFF8FAFC)),
    labelMedium: customizeTextStyle(fontColor: const Color(0xFF94A3B8)),
    labelSmall: customizeTextStyle(fontColor: const Color(0xFF64748B)),
    titleLarge: customizeTextStyle(fontColor: const Color(0xFFF8FAFC), fontWeight: FontWeight.w600),
    titleMedium: customizeTextStyle(fontColor: const Color(0xFFF1F5F9), fontWeight: FontWeight.w600),
    titleSmall: customizeTextStyle(fontColor: const Color(0xFFE2E8F0), fontWeight: FontWeight.w500),
    displayLarge: customizeTextStyle(fontColor: const Color(0xFFF8FAFC)),
    displayMedium: customizeTextStyle(fontColor: const Color(0xFFF1F5F9)),
    displaySmall: customizeTextStyle(fontColor: const Color(0xFFE2E8F0)),
    headlineLarge: customizeTextStyle(fontColor: const Color(0xFFF8FAFC)),
    headlineMedium: customizeTextStyle(fontColor: const Color(0xFFF1F5F9)),
    headlineSmall: customizeTextStyle(fontColor: const Color(0xFFE2E8F0)),
  );

  static ThemeData theme = ThemeData(
    pageTransitionsTheme: kIsWeb ? NoTransitionsOnWeb() : null,
    colorSchemeSeed: ColorConst.baseHexColor,
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    brightness: Brightness.light,
    appBarTheme: lightAppBarTheme,
    textTheme: lightTextTheme,
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    pageTransitionsTheme: kIsWeb ? NoTransitionsOnWeb() : null,
    colorSchemeSeed: ColorConst.baseHexColor,
    scaffoldBackgroundColor: const Color(0xFF090A0F),
    brightness: Brightness.dark,
    appBarTheme: darkAppBarTheme,
    textTheme: darkTextTheme,
    cardTheme: const CardThemeData(
      color: Color(0xFF131520),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: Color(0xFF1E293B), width: 1),
      ),
    ),
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

