import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:genu/service/app_updater.dart';

import 'data/model/fcm_notification_model.dart';
import 'extension/logger_extension.dart';
import 'firebase_options.dart';
import 'router/router_manager.dart';
import 'service/firebase_service.dart';
import 'service/redirect_engine.dart';
import 'service/notification_handler.dart';
import 'storage/localCart/bloc/local_cart_bloc.dart';
import 'utils/text_utils.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppLog.i("On Message Id : ${message.messageId}");
  var massagePayload = {
    'Title': message.notification?.title,
    'Message': Platform.isAndroid
        ? message.notification?.android?.tag
        : message.notification?.apple?.subtitle,
    'BigText': message.notification?.body,
    'ImageUrl': Platform.isAndroid
        ? message.notification?.android?.imageUrl
        : message.notification?.apple?.imageUrl,
    'ActionURL': message.data['ActionURL']
  };
  await NotificationHandler().initiateNotification();
  FcmNotificationModel fcmNotificationModel =
      FcmNotificationModel.fromJson(massagePayload);

  if (Platform.isAndroid && fcmNotificationModel.title != null) {
    NotificationHandler().showNotificationAndroid(fcmNotificationModel);
  } else if (Platform.isIOS && fcmNotificationModel.title != null) {
    NotificationHandler().showNotificationIos(fcmNotificationModel);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.instance.setAutoInitEnabled(false);
  FirebaseMessaging.onMessage.listen((message) {
    AppLog.i("On Message Id : ${message.messageId}");
    var massagePayload = {
      'Title': message.notification?.title,
      'Message': Platform.isAndroid
          ? message.notification?.android?.tag
          : message.notification?.apple?.subtitle,
      'BigText': message.notification?.body,
      'ImageUrl': Platform.isAndroid
          ? message.notification?.android?.imageUrl
          : message.notification?.apple?.imageUrl,
      'ActionURL': message.data['ActionURL']
    };

    FcmNotificationModel fcmNotificationModel =
        FcmNotificationModel.fromJson(massagePayload);

    if (Platform.isAndroid && fcmNotificationModel.title != null) {
      NotificationHandler().showNotificationAndroid(fcmNotificationModel);
    } else if (Platform.isIOS && fcmNotificationModel.title != null) {
      NotificationHandler().showNotificationIos(fcmNotificationModel);
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    if (event.data.containsKey("ActionURL")) {
      RedirectEngine().redirectRoutes(
        redirectUrl: Uri.parse(event.data["ActionURL"]),
        delayedSeconds: 4,
      );
    }
  });
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseService().getInitialMessage();
  await NotificationHandler().requestPermissions();
  await NotificationHandler().initiateNotification();
  await FlutterDownloader.initialize(
      debug: kDebugMode,
      // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          false // option: set to false to disable working with http links (default: false)
      );
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) async {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await FirebaseService().generateToken();
      await AppUpdater().startUpdate();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              LocalCartBloc()..add(InItLocalCartEvent()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: TextUtils.appTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: RouterManager.getInstance.router,
      ),
    );
  }
}
