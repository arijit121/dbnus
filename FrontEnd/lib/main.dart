// THIS FILE WILL PREVENT COMPILE TIME ERRORS,
// WHICH OCCURS BECAUSE OF PLATFORM DEPENDENT IMPORTS...

export 'main_web.dart' if (dart.library.io) 'main_app.dart';

/// The compiler will then say something like this:
/// Let’s export 'main_app.dart' By default,
/// but if the "dart.library.js" is available, export 'main_web.dart'.
/// But hey, if "dart.library.io" is available, export 'main_app.dart'!
