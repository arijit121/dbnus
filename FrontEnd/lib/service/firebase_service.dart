import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart'
    deferred as firebase_messaging;

import '../extension/logger_extension.dart';
import 'redirect_engine.dart' deferred as redirect_engine;

class FirebaseService {
  Future<void> generateToken() async {
    try {
      await Future.wait([
        firebase_messaging.loadLibrary(),
      ]);
      String? fcmToken =
          await firebase_messaging.FirebaseMessaging.instance.getToken();
      AppLog.i(tag: "FcmToken0", "$fcmToken");

      firebase_messaging.FirebaseMessaging.instance.onTokenRefresh
          .listen((fcmToken) {
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
      await Future.wait(
          [firebase_messaging.loadLibrary(), redirect_engine.loadLibrary()]);

      final initialMessage = await firebase_messaging.FirebaseMessaging.instance
          .getInitialMessage();

      /// Fcm Testing

      if (initialMessage != null) {
        if (initialMessage.data.containsKey("ActionURL")) {
          redirect_engine.RedirectEngine().redirectRoutes(
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

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  }) async {
    try {
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      await analytics.logEvent(
          name: name, parameters: parameters, callOptions: callOptions);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<void> setAnalyticsCollectionEnabled() async {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.setAnalyticsCollectionEnabled(true);
    FirebaseAnalyticsObserver(analytics: analytics);
    await analytics.setConsent(analyticsStorageConsentGranted: true);
  }
}
