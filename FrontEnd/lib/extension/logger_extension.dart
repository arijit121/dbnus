import 'package:flutter/foundation.dart';

/// A Logger For Flutter Apps
/// Usage:
/// 1) AppLog.i("Info Message");
/// 2) AppLog.i("Home Page", tag: "User Logging");
///
class AppLog {
  static const String _DEFAULT_TAG_PREFIX = "AppLog";

  ///use Log.v. Print all Logs
  static const int _VERBOSE = 2;

  ///use Log.d. Print Debug Logs
  static const int _DEBUG = 3;

  ///use Log.i. Print Info Logs
  static const int _INFO = 4;

  ///use Log.w. Print warning logs
  static const int _WARN = 5;

  ///use Log.e. Print error logs
  static const int _ERROR = 6;

  ///use Log.wtf. Print Failure Logs(What a Terrible Failure= WTF)
  static const int _Failed = 7;

  ///SET APP LOG LEVEL, Default ALL
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
    if (_currentLogLevel <= priority && !kReleaseMode) {
      debugPrint(
          _ascieEscape(priority,
              text: "${_getPriorityText(priority)}$tag::==>  $message"),
          wrapWidth: 1024);
      if (error != null) {
        debugPrint(_ascieEscape(priority, text: error.toString()));
      }

      if (stackTrace != null) {
        debugPrint(_ascieEscape(priority, text: stackTrace.toString()));
      }
      if (time != null) {
        debugPrint(_ascieEscape(priority, text: time.toString()));
      }
    }
  }

  static String _getPriorityText(int priority) {
    switch (priority) {
      case _INFO:
        return "💡 INFO | ";
      case _DEBUG:
        return "🛠️ DEBUG | ";
      case _ERROR:
        return "⛔ ERROR | ";
      case _WARN:
        return "🚧 WARN | ";
      case _Failed:
        return "🚫 Failed | ";
      case _VERBOSE:
      default:
        return "✒️";
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

  ///Print general logs
  static v(var message, {String tag = _DEFAULT_TAG_PREFIX, DateTime? time}) {
    _log(_VERBOSE, tag, message.toString(), time: time);
  }

  ///Print info logs
  static i(var message, {String tag = _DEFAULT_TAG_PREFIX, DateTime? time}) {
    _log(_INFO, tag, message.toString(), time: time);
  }

  ///Print debug logs
  static d(var message, {String tag = _DEFAULT_TAG_PREFIX, DateTime? time}) {
    _log(_DEBUG, tag, message.toString(), time: time);
  }

  ///Print warning logs
  static w(var message, {String tag = _DEFAULT_TAG_PREFIX, DateTime? time}) {
    _log(_WARN, tag, message.toString(), time: time);
  }

  ///Print error logs
  static e(var message,
      {String tag = _DEFAULT_TAG_PREFIX,
      Object? error,
      StackTrace? stackTrace,
      DateTime? time}) {
    _log(_ERROR, tag, message.toString(),
        error: error, stackTrace: stackTrace, time: time);
  }

  ///Print failure logs
  static t(var message, {String tag = _DEFAULT_TAG_PREFIX}) {
    _log(_Failed, tag, message.toString());
  }
}
