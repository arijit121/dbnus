import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

/// Classifies exceptions into Fatal vs Non-Fatal for Crashlytics reporting.
///
/// ```
///               Crashlytics
///                    │
///     ┌──────────────┴──────────────┐
///     │                             │
///   FATAL                       NON-FATAL
///     │                             │
/// Native crashes              Flutter errors
/// Process crashes             Async errors
/// Unrecoverable state         API errors
/// Explicit fatal errors       Network errors
///                             Parsing errors
///                             Type errors
///                             Plugin errors
///                             Recoverable UI errors
/// ```
class CrashlyticsErrorClassifier {
  CrashlyticsErrorClassifier._();

  /// Returns `true` if [exception] represents an **unrecoverable** crash that
  /// must be reported as Fatal to Crashlytics and shown to the user as a
  /// crash page.
  ///
  /// Returns `false` for **operational/recoverable** errors (null API response,
  /// bad parsing, closed streams, plugin failures, network timeouts, etc.)
  /// which should be logged as Non-Fatal only — the user stays in the app.
  static bool isFatal(Object exception) {
    // ── NON-FATAL: Recoverable operational runtime errors ─────────────────────

    /// Null-access on API response or dynamic data (e.g. response?['key'])
    if (exception is NoSuchMethodError) return false;

    /// Bad string-to-number parsing (e.g. double.parse("null"))
    if (exception is FormatException) return false;

    /// Bloc/stream closed before event added, or other recoverable state issues
    if (exception is StateError) return false;

    /// Type mismatch in dynamic data (e.g. int assigned to String field)
    if (exception is TypeError) return false;

    /// List/map index out of bounds — recoverable data errors
    if (exception is RangeError) return false;

    /// Platform channel / plugin not implemented or unavailable
    if (exception is PlatformException) return false;
    if (exception is MissingPluginException) return false;
    if (exception is UnsupportedError) return false;

    /// List modified during iteration (e.g. UI updating while iterating API data)
    if (exception is ConcurrentModificationError) return false;

    /// Invalid argument passed to a method — data/logic bug, not a process crash
    if (exception is ArgumentError) return false;

    /// Network & connectivity failures — transient, always recoverable
    if (exception is SocketException) return false;
    if (exception is HttpException) return false;
    if (exception is TimeoutException) return false;
    if (exception is HandshakeException) return false;

    // ── FATAL: Unrecoverable process/framework-level crashes ─────────────────

    /// Process memory exhausted — cannot recover
    if (exception is OutOfMemoryError) return true;

    /// Call stack exhausted — cannot recover
    if (exception is StackOverflowError) return true;

    /// Any unrecognised error (not Exception) — treat as fatal to be safe
    if (exception is Error) return true;

    // Default: Exceptions not matched above are Non-Fatal
    // (covers app-level throw Exception(...) patterns)
    return false;
  }

  /// Returns `true` if the [library] string from [FlutterErrorDetails]
  /// belongs to a framework rendering or foundation library where errors
  /// are always unrecoverable.
  static bool isFatalLibrary(String? library) {
    if (library == null) return false;

    /// Flutter rendering pipeline failure — widget tree cannot be painted
    if (library.contains('rendering library')) return true;

    /// Flutter foundation assertion failures — core framework violated
    if (library.contains('foundation library')) return true;

    return false;
  }
}
