import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'const/theme_const.dart';
import 'extension/logger_extension.dart';
import 'firebase_options.dart';
import 'router/router_manager.dart';
import 'router/url_strategy/url_strategy.dart';
import 'service/crash/utils/crashUtils.dart';
import 'service/firebase_service.dart';
import 'storage/localCart/bloc/local_cart_bloc.dart';
import 'utils/text_utils.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLog.i("On Background Message Id : ${message.messageId}");
}

Future<void> main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  CrashUtils().setValue(value: false);
  FlutterError.onError = (errorDetails) {
    if (errorDetails.library?.contains("widgets library") == true) {
      CrashUtils().navigateToCrashPage({
        "error": "${errorDetails.exception}",
        "stack": "${errorDetails.stack}",
      });
      AppLog.e("${errorDetails.exception}",
          tag: "Serious Error", stackTrace: errorDetails.stack);
    } else {
      AppLog.e("${errorDetails.exception}",
          tag: "Error", stackTrace: errorDetails.stack);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    AppLog.e("$error", stackTrace: stack, tag: "Error");
    return true;
  };

  FirebaseMessaging.instance.setAutoInitEnabled(false);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) async {
    runApp(const MyWebApp());
  });
}

class MyWebApp extends StatefulWidget {
  const MyWebApp({super.key});

  @override
  State<MyWebApp> createState() => _MyWebAppState();
}

class _MyWebAppState extends State<MyWebApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await FirebaseService().generateToken();
    });

    super.initState();
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
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown
          },
        ),
        themeMode: ThemeMode.system,
        theme: ThemeConst.theme,
        darkTheme: ThemeConst.darkTheme,
        routerConfig: RouterManager.getInstance.router,
      ),
    );
  }
}
