import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extension/hex_color.dart';
import 'color_const.dart';

class ThemeConst {
  static SystemUiOverlayStyle systemOverlayStyle = const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemStatusBarContrastEnforced: true);

  static ThemeData theme = ThemeData(
    colorSchemeSeed: HexColor.fromHex(ColorConst.baseHexColor),
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(systemOverlayStyle: systemOverlayStyle),
  );

  static ThemeData darkTheme = ThemeData(
    colorSchemeSeed: HexColor.fromHex(ColorConst.baseHexColor),
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(systemOverlayStyle: systemOverlayStyle),
  );
}
