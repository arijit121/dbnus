export 'src/web/url_strategy.dart' // By default
if (dart.library.js_interop) 'src/web/url_strategy.dart'
if (dart.library.io) 'src/non_web/url_strategy.dart';