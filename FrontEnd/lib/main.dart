import 'package:flutter/widgets.dart';
import 'package:system_theme/system_theme.dart';
import 'main_web.dart'
    if (dart.library.io) 'main_app.dart'
    if (dart.library.js_interop) 'main_web.dart' deferred as main_runner;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemTheme.fallbackColor = const Color(0xFF00A3FA);
  await SystemTheme.accentColor.load();
  await main_runner.loadLibrary();
  await main_runner.main();
}
