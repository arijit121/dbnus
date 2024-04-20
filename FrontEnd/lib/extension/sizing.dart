import '../utils/screen_utils.dart';
import 'dart:math';

import 'package:flutter/widgets.dart';

import '../service/context_service.dart';

extension Sizing on num {
  double get fs =>
      MediaQuery.of(CurrentContext().context).textScaler.scale(toDouble());

  double get sh => (ScreenUtils().nh ?? 1) * (toDouble() / 100);

  double get sw => (ScreenUtils().nw ?? 1) * (toDouble() / 100);
}
