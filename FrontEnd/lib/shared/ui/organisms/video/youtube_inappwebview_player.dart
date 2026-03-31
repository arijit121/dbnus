export 'youtube_inappwebview_player_app.dart' // By default
    if (dart.library.js_interop) 'youtube_inappwebview_player_web.dart'
    if (dart.library.io) 'youtube_inappwebview_player_app.dart';

/// The compiler will then say something like this:
/// Let’s export 'youtube_inappwebview_player_app.dart' By default,
/// but if the "dart.library.js" is available, export 'youtube_inappwebview_player_web.dart'.
/// But hey, if "dart.library.io" is available, export 'youtube_inappwebview_player_app.dart'!
