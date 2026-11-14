import 'package:material_ui/material_ui.dart';

/// Sensor and optics modes mirroring the God's Eye View GLSL shader presets.
enum SensorMode {
  normal,
  crt,
  nvg,
  flir,
  anime,
  noir,
  snow;

  String get displayName {
    switch (this) {
      case SensorMode.normal:
        return 'NORMAL';
      case SensorMode.crt:
        return 'CRT';
      case SensorMode.nvg:
        return 'NVG';
      case SensorMode.flir:
        return 'FLIR';
      case SensorMode.anime:
        return 'ANIME';
      case SensorMode.noir:
        return 'NOIR';
      case SensorMode.snow:
        return 'SNOW';
    }
  }

  String get fullTitle {
    switch (this) {
      case SensorMode.normal:
        return 'NORMAL OPTICAL';
      case SensorMode.crt:
        return 'CRT PHOSPHOR';
      case SensorMode.nvg:
        return 'NVG SURVEILLANCE';
      case SensorMode.flir:
        return 'FLIR / THERMAL';
      case SensorMode.anime:
        return 'ANIME CYBER';
      case SensorMode.noir:
        return 'NOIR MONOCHROME';
      case SensorMode.snow:
        return 'SNOW / FROST IR';
    }
  }

  int get keyNumber {
    switch (this) {
      case SensorMode.normal:
        return 1;
      case SensorMode.crt:
        return 2;
      case SensorMode.nvg:
        return 3;
      case SensorMode.flir:
        return 4;
      case SensorMode.anime:
        return 5;
      case SensorMode.noir:
        return 6;
      case SensorMode.snow:
        return 7;
    }
  }

  String get iconSymbol {
    switch (this) {
      case SensorMode.normal:
        return '◯';
      case SensorMode.crt:
        return '▦';
      case SensorMode.nvg:
        return '🌙';
      case SensorMode.flir:
        return '🌡️';
      case SensorMode.anime:
        return '✦';
      case SensorMode.noir:
        return '◐';
      case SensorMode.snow:
        return '❄';
    }
  }

  String get shortCode {
    return 'OPT-$keyNumber';
  }

  Color get hudColor {
    switch (this) {
      case SensorMode.normal:
        return const Color(0xFF00D4FF); // #00d4ff Cyan
      case SensorMode.crt:
        return const Color(0xFF00FF66); // Retro phosphor green
      case SensorMode.nvg:
        return const Color(0xFF39FF14); // Phosphor NVG green
      case SensorMode.flir:
        return const Color(0xFFFF9100); // Amber thermal
      case SensorMode.anime:
        return const Color(0xFFFF007F); // Cyber neon magenta
      case SensorMode.noir:
        return const Color(0xFFE0E0E0); // White tactical
      case SensorMode.snow:
        return const Color(0xFF80D8FF); // Frost cyan
    }
  }
}
