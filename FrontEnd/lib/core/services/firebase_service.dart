import 'package:dbnus/core/services/notification_handler.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart'
    deferred as firebase_messaging;
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:dbnus/core/models/custom_notification_model.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/core/services/redirect_engine.dart'
    deferred as redirect_engine;

class FirebaseService {
  static Future<void> generateToken() async {
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

  static Future<void> getInitialMessage() async {
    try {
      await Future.wait(
          [firebase_messaging.loadLibrary(), redirect_engine.loadLibrary()]);

      final initialMessage = await firebase_messaging.FirebaseMessaging.instance
          .getInitialMessage();

      /// Fcm Testing

      if (initialMessage != null) {
        if (initialMessage.data.containsKey("ActionURL")) {
          redirect_engine.RedirectEngine.redirectRoutes(
            redirectUrl: Uri.parse(initialMessage.data["ActionURL"]),
            delayedSeconds: 4,
          );
        }

        // PopUpItems.toastMessage(initialMessage.data["ActionURL"], blue);
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  static Future<void> logEvent({
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

  static Future<void> setAnalyticsCollectionEnabled() async {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.setAnalyticsCollectionEnabled(true);
    FirebaseAnalyticsObserver(analytics: analytics);
    await analytics.setConsent(analyticsStorageConsentGranted: true);
  }

  static void showNotification(RemoteMessage message) {
    var massagePayload = {
      'Title': message.data['title'],
      'Message': message.data['message'],
      'BigText': message.data['body'],
      'ImageUrl': message.data['image'],
      'ActionURL': message.data['ActionURL'],
      'Sound': message.data['Sound'],
    };

    CustomNotificationModel customNotificationModel =
        CustomNotificationModel.fromJson(massagePayload);
    NotificationHandler.showUpdateFlutterNotification(customNotificationModel,
        notificationId:
            FirebaseService._extractUniqueIdAsInt(message.messageId ?? ""));
  }

  static int? _extractUniqueIdAsInt(String input) {
    final regex = RegExp(r'0:(\d+)%');
    final match = regex.firstMatch(input);
    if (match != null) {
      final fullId = match.group(1)!;
      final shortened = fullId.length > 9
          ? fullId.substring(fullId.length - 9) // take last 9 digits
          : fullId;
      return int.tryParse(shortened);
    }
    return null;
  }
}
