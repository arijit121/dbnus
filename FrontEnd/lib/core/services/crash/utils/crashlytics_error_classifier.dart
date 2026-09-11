/// Classifies exceptions into Fatal vs Non-Fatal for Crashlytics reporting
/// and crash navigation.
///
/// ```
///               Crashlytics
///                    │
///     ┌──────────────┴──────────────┐
///     │                             │
///   FATAL                       NON-FATAL
///     │                             │
/// Native crashes              Flutter errors (e.g. RenderFlex overflow)
/// Out of memory               Async / Future errors
/// Stack overflow              API / Network errors
///                             Parsing / Type errors
///                             Plugin / State errors
///                             Recoverable UI errors
/// ```
class CrashlyticsErrorClassifier {
  CrashlyticsErrorClassifier._();

  /// Returns `true` only if [exception] represents an **unrecoverable**
  /// process-level crash (such as memory or call stack exhaustion).
  ///
  /// Returns `false` for all operational, framework, UI, and async errors
  /// (render overflows, network failures, null checks, format/type errors, etc.)
  /// allowing the app to recover gracefully without disrupting the user.
  static bool isFatal(Object exception) {
    /// Process memory exhausted — unrecoverable
    if (exception is OutOfMemoryError) return true;

    /// Call stack exhausted — unrecoverable
    if (exception is StackOverflowError) return true;

    // Everything else is treated as recoverable / non-fatal
    return false;
  }
}
