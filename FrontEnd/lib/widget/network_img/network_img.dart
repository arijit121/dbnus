export 'network_img_app.dart' // By default
    if (dart.library.js) 'network_img_web.dart'
    if (dart.library.io) 'network_img_app.dart';

/// The compiler will then say something like this:
/// Let’s export 'custom_network_img_app.dart' By default,
/// but if the "dart.library.js" is available, export 'custom_network_img_web.dart'.
/// But hey, if "dart.library.io" is available, export 'custom_network_img_app.dart'!