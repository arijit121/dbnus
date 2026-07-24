import 'package:flutter/material.dart';

extension ColorExe on Color {
  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  // Function to mix a list of colors
  static Color? mixColors(List<Color> colors) {
    Color? result = colors[0]; // Start with the first color
    double mixFactor =
        1.0 / (colors.length - 1); // Equal mix factor for each step

    for (int i = 1; i < colors.length; i++) {
      // Interpolate step by step between the colors
      result = Color.lerp(result, colors[i], mixFactor * i);
    }

    return result; // Return the final mixed color
  }
}
