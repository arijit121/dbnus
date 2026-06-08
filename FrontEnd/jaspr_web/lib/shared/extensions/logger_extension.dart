import 'dart:developer';

class AppLog {
  static const bool _enableLogger = false;
  static const String _DEFAULT_TAG_PREFIX = "AppLog";

  static const int _VERBOSE = 2;
  static const int _DEBUG = 3;
  static const int _INFO = 4;
  static const int _WARN = 5;
  static const int _ERROR = 6;
  static const int _Failed = 7;

  static int _currentLogLevel = _VERBOSE;

  static setLogLevel(int priority) {
    int newPriority = priority;
    if (newPriority <= _VERBOSE) {
      newPriority = _VERBOSE;
    } else if (newPriority >= _Failed) {
      newPriority = _Failed;
    }
    _currentLogLevel = newPriority;
  }

  static _log(int priority, String tag, String message,
      {Object? error, StackTrace? stackTrace, DateTime? time}) {
    if (_currentLogLevel <= priority) {
      if (!_enableLogger) {
        _logLargeMessage(_ascieEscape(priority,
            text: "${_getPriorityText(priority)}$tag::==>  $message"));
        if (error != null) {
          _logLargeMessage(_ascieEscape(priority, text: error.toString()));
        }
        if (stackTrace != null) {
          _logLargeMessage(_ascieEscape(priority, text: stackTrace.toString()));
        }
        if (time != null) {
          _logLargeMessage(_ascieEscape(priority, text: time.toString()));
        }
      } else {
        log(
          "::==>  $message",
          name: " ${_getPriorityText(priority)}$tag",
          level: priority * 100,
          error: error,
          stackTrace: stackTrace,
          time: time ?? DateTime.now(),
        );
      }
    }
  }

  static void _logLargeMessage(String message, {int chunkSize = 220}) {
    for (var i = 0; i < message.length; i += chunkSize) {
      final chunk = message.substring(
          i, i + chunkSize > message.length ? message.length : i + chunkSize);
      print(chunk);
    }
  }

  static String _getPriorityText(int priority) {
    switch (priority) {
      case _INFO:
        return "💡 INFO    | ";
      case _DEBUG:
        return "🛠️  DEBUG   | ";
      case _ERROR:
        return "⛔ ERROR   | ";
      case _WARN:
        return "🚧 WARN    | ";
      case _Failed:
        return "🚫 Failed  | ";
      case _VERBOSE:
      default:
        return "✒️  VERBOSE | ";
    }
  }

  static String _ascieEscape(int priority, {String? text}) {
    switch (priority) {
      case _INFO:
        return "\x1B[32m$text\x1B[0m";
      case _DEBUG:
        return "\x1B[34m$text\x1B[0m";
      case _ERROR:
        return "\x1B[31m$text\x1B[0m";
      case _WARN:
        return "\x1B[33m$text\x1B[0m";
      case _Failed:
        return "\x1B[35m$text\x1B[0m";
      case _VERBOSE:
      default:
        return "\x1B[37m$text\x1B[0m";
    }
  }

  static v(var message, {String tag = _DEFAULT_TAG_PREFIX, DateTime? time}) {
    _log(_VERBOSE, tag, message.toString(), time: time);
  }

  static i(var message, {String tag = _DEFAULT_TAG_PREFIX, DateTime? time}) {
    _log(_INFO, tag, message.toString(), time: time);
  }

  static d(var message, {String tag = _DEFAULT_TAG_PREFIX, DateTime? time}) {
    _log(_DEBUG, tag, message.toString(), time: time);
  }

  static w(var message, {String tag = _DEFAULT_TAG_PREFIX, DateTime? time}) {
    _log(_WARN, tag, message.toString(), time: time);
  }

  static e(var message,
      {String tag = _DEFAULT_TAG_PREFIX,
      Object? error,
      StackTrace? stackTrace,
      DateTime? time}) {
    _log(_ERROR, tag, message.toString(),
        error: error, stackTrace: stackTrace, time: time);
  }

  static t(var message, {String tag = _DEFAULT_TAG_PREFIX}) {
    _log(_Failed, tag, message.toString());
  }
}
