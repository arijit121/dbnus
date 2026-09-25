import 'package:flutter/services.dart';

import 'logger_extension.dart';

import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

export 'package:vibration/vibration.dart' show Vibration;
export 'package:vibration/vibration_presets.dart' show VibrationPreset;

class VibrationHapticFeedback {
  static Future<void> light() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (e, stackTrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stackTrace);
    }
  }

  static Future<void> medium() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (e, stackTrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stackTrace);
    }
  }

  static Future<void> heavy() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (e, stackTrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stackTrace);
    }
  }

  static Future<void> selection() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (e, stackTrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stackTrace);
    }
  }

  static Future<void> vibrate() async {
    try {
      await HapticFeedback.vibrate();
    } catch (e, stackTrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stackTrace);
    }
  }
}

class VibrationHapticFeedbackV2 {
  /// Light impact vibration feedback
  static Future<void> light({int duration = 20, int amplitude = 60}) async {
    if (kIsWeb) return;
    try {
      await Vibration.vibrate(duration: duration, amplitude: amplitude);
    } catch (e, stackTrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stackTrace);
    }
  }

  /// Medium impact vibration feedback
  static Future<void> medium({int duration = 40, int amplitude = 128}) async {
    if (kIsWeb) return;
    try {
      await Vibration.vibrate(duration: duration, amplitude: amplitude);
    } catch (e, stackTrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stackTrace);
    }
  }

  /// Heavy impact vibration feedback
  static Future<void> heavy({int duration = 60, int amplitude = 255}) async {
    if (kIsWeb) return;
    try {
      await Vibration.vibrate(duration: duration, amplitude: amplitude);
    } catch (e, stackTrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stackTrace);
    }
  }

  /// Selection / click vibration feedback
  static Future<void> selection({int duration = 10, int amplitude = 40}) async {
    if (kIsWeb) return;
    try {
      await Vibration.vibrate(duration: duration, amplitude: amplitude);
    } catch (e, stackTrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stackTrace);
    }
  }

  /// Standard vibration with custom duration, pattern, amplitude, or preset
  static Future<void> vibrate({
    int duration = 500,
    List<int> pattern = const [],
    int repeat = -1,
    List<int> intensities = const [],
    int amplitude = -1,
    double sharpness = 0.5,
    VibrationPreset? preset,
  }) async {
    if (kIsWeb) return;
    try {
      await cancel();
      await Vibration.vibrate(
        duration: duration,
        pattern: pattern,
        repeat: repeat,
        intensities: intensities,
        amplitude: amplitude,
        sharpness: sharpness,
        preset: preset,
      );
    } catch (e, stackTrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stackTrace);
    }
  }

  /// Cancel any ongoing vibration
  static Future<void> cancel() async {
    if (kIsWeb) return;
    try {
      await Vibration.cancel();
    } catch (e, stackTrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stackTrace);
    }
  }

  /// Check if the device has a vibrator
  static Future<bool> hasVibrator() async {
    if (kIsWeb) return false;
    try {
      return await Vibration.hasVibrator();
    } catch (e, stackTrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Check if the vibrator supports amplitude control
  static Future<bool> hasAmplitudeControl() async {
    if (kIsWeb) return false;
    try {
      return await Vibration.hasAmplitudeControl();
    } catch (e, stackTrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Check if custom vibrations are supported
  static Future<bool> hasCustomVibrationsSupport() async {
    if (kIsWeb) return false;
    try {
      return await Vibration.hasCustomVibrationsSupport();
    } catch (e, stackTrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stackTrace);
      return false;
    }
  }
}
