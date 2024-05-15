import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../extension/logger_extension.dart';

import 'redirect_engine.dart';

class FirebaseService {
  Future<void> generateToken() async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      AppLog.i(tag: "FcmToken0", "$fcmToken");
      FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
        AppLog.i(tag: "FcmToken1", fcmToken);
      }).onError((err) {
        AppLog.e(err);
      });
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<void> getInitialMessage() async {
    try {
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      /// Fcm Testing

      if (initialMessage != null) {
        if (initialMessage.data.containsKey("ActionURL")) {
          RedirectEngine().redirectRoutes(
            redirectUrl: Uri.parse(initialMessage.data["ActionURL"]),
            delayedSeconds: 4,
          );
        }

        // PopUpItems().toastMessage(initialMessage.data["ActionURL"], blue);
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  void logEvent({
    required String name,
    Map<String, Object?>? parameters,
    AnalyticsCallOptions? callOptions,
  }) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.logEvent(
        name: name, parameters: parameters, callOptions: callOptions);
  }
}
