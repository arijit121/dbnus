import 'package:dbnus/main_web.dart'
    if (dart.library.io) 'main_app.dart'
    if (dart.library.js_interop) 'main_web.dart' deferred as main_runner;

Future<void> main() async {
  await main_runner.loadLibrary();
  await main_runner.main();
}
