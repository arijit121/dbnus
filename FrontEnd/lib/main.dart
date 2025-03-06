import 'package:flutter/foundation.dart';

import 'main_app.dart' deferred as main_app;
import 'main_web.dart' deferred as main_web;

Future<void> main() async {
    if (kIsWeb) {
        await main_web.loadLibrary();
        await main_web.main();
    } else {
        await main_app.loadLibrary();
        await main_app.main();
    }
}
