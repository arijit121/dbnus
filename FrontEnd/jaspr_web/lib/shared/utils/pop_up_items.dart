import 'package:universal_web/web.dart' as web;

enum DialogType { success, error, warning, info }

class PopUpItems {
  /// Displays an alert dialog as a toast on the web.
  static void toastMessage(String message, dynamic color, {int? durationSeconds, dynamic scaffoldState, dynamic padding}) {
    web.window.alert(message);
  }

  /// Displays an alert dialog for standard alerts.
  static Future<void> customMsgDialog({
    String? title,
    String? content,
    DialogType? type,
    dynamic contentCrossAxisAlignment,
  }) async {
    final prefix = type != null ? '[${type.name.toUpperCase()}] ' : '';
    web.window.alert('$prefix${title ?? ""}\n\n${content ?? ""}');
  }
}
