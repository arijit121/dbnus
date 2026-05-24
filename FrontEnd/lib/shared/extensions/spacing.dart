import 'package:material_ui/material_ui.dart';

extension Spacing on num {
  SizedBox get ph => SizedBox(height: toDouble());

  SizedBox get pw => SizedBox(width: toDouble());
}
