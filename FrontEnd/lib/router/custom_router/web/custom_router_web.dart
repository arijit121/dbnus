export 'custom_router_web_js.dart' // By default
    if (dart.library.js) 'custom_router_web_js.dart'
    if (dart.library.io) 'custom_router_web_app.dart';
