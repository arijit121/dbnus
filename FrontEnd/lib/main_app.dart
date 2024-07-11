import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'service/app_updater.dart';

import 'const/color_const.dart';
import 'extension/hex_color.dart';
import 'extension/logger_extension.dart';
import 'firebase_options.dart';
import 'router/router_manager.dart';
import 'service/download_handler.dart';
import 'service/firebase_service.dart';
import 'service/redirect_engine.dart';
import 'service/notification_handler.dart';
import 'storage/localCart/bloc/local_cart_bloc.dart';
import 'utils/text_utils.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  NotificationHandler().showFlutterNotification(message);
  AppLog.i("On Background Message Id : ${message.messageId}");
}



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.instance.setAutoInitEnabled(false);
  FirebaseMessaging.onMessage.listen((message) {
    AppLog.i("On Message Id : ${message.messageId}");
    NotificationHandler().showFlutterNotification(message);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    if (event.data.containsKey("ActionURL")) {
      RedirectEngine().redirectRoutes(
        redirectUrl: Uri.parse(event.data["ActionURL"]),
        delayedSeconds: 4,
      );
    }
  });

  await FirebaseService().getInitialMessage();
  await NotificationHandler().requestPermissions();
  await NotificationHandler().initiateNotification();
  await DownloadHandler().config();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.white));
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
        themeMode: ThemeMode.system,
        theme: ThemeData(
          colorSchemeSeed: HexColor.fromHex(ColorConst.baseHexColor),
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: HexColor.fromHex(ColorConst.baseHexColor),
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        routerConfig: RouterManager.getInstance.router,
      ),
    );
  }
}
