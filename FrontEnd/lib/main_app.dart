import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:dbnus/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dbnus/shared/constants/theme_const.dart';
import 'package:dbnus/core/network/connection/bloc/connection_bloc.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/navigation/router_manager.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/core/services/Localization/bloc/localization_bloc.dart';
import 'package:dbnus/core/services/Localization/app_localizations/app_localizations.dart';
import 'package:dbnus/core/services/Localization/utils/localization_utils.dart';
import 'package:dbnus/core/services/app_updater.dart';
import 'package:dbnus/core/services/crash/utils/crash_utils.dart';
import 'package:dbnus/core/services/download_handler.dart';
import 'package:dbnus/core/services/firebase_service.dart';
import 'package:dbnus/core/services/notification_handler.dart';
import 'package:dbnus/core/services/redirect_engine.dart';
import 'package:dbnus/core/storage/localCart/bloc/local_cart_bloc.dart';
import 'package:dbnus/shared/utils/pop_up_items.dart';
import 'package:dbnus/shared/utils/text_utils.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseService.showNotification(message);
  AppLog.i("On Background Message Id : ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.instance.setAutoInitEnabled(false);
  FirebaseMessaging.onMessage.listen((message) {
    AppLog.i("On Message Id : ${message.messageId}");
    FirebaseService.showNotification(message);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    if (event.data.containsKey("ActionURL")) {
      RedirectEngine.redirectRoutes(
        redirectUrl: Uri.parse(event.data["ActionURL"]),
        delayedSeconds: 4,
      );
    }
  });

  CrashUtils.setValue(value: false);
  FlutterError.onError = (errorDetails) {
    if (errorDetails.library?.contains("widgets library") == true) {
      AppLog.e("${errorDetails.exception}",
          tag: "Serious Error", stackTrace: errorDetails.stack);
      if (!kDebugMode) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      }
      CrashUtils.navigateToCrashPage({
        "error": "${errorDetails.exception}",
        "stack": "${errorDetails.stack}",
      });
    } else {
      AppLog.e("${errorDetails.exception}",
          tag: "Error", stackTrace: errorDetails.stack);
      if (!kDebugMode) {
        FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      }
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    AppLog.e("$error", stackTrace: stack, tag: "Error");
    return true;
  };

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  await FirebaseService.getInitialMessage();
  await FirebaseService.setAnalyticsCollectionEnabled();
  await NotificationHandler.requestPermissions();
  await NotificationHandler.initiateNotification();
  await DownloadHandler().config();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
      SystemChrome.setSystemUIOverlayStyle(ThemeConst.systemOverlayStyle);
      BackButtonInterceptor.add(myInterceptor);
      await FirebaseService.generateToken();
      await AppUpdater.startUpdate();
      AppLinks().uriLinkStream.listen((uri) {
        RedirectEngine.redirectRoutes(redirectUrl: uri);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool _isExitAppDialogOpen = false;

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (CustomRoute.currentRoute() == RouteName.initialView) {
      if (!_isExitAppDialogOpen) {
        _isExitAppDialogOpen = true;
        PopUpItems.cupertinoPopup(
            cancelBtnPresses: () {
              _isExitAppDialogOpen = false;
            },
            okBtnPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            title: "Confirm Exit",
            content: "Do you want to close the app?",
            okBtnText: "Yes");
      }
      return true;
    } else if (RouterManager.getInstance.router.canPop() == true) {
      return false;
    } else {
      CustomRoute.clearAndNavigateName(RouteName.initialView);
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              LocalCartBloc()..add(InItLocalCartEvent()),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              LocalizationBloc()..add(InitLocalization()),
        ),
        BlocProvider(
          lazy: false,
          create: (BuildContext context) =>
              ConnectionBloc()..add(InitConnection()),
        ),
      ],
      child: BlocBuilder<LocalizationBloc, LocalizationState>(
        builder: (context, localizationState) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            locale: localizationState.locale.value,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: LocalizationUtils.supportedLocales,
            title: TextUtils.appTitle,
            themeMode: ThemeMode.system,
            theme: ThemeConst.theme,
            darkTheme: ThemeConst.darkTheme,
            routerConfig: RouterManager.getInstance.router,
          );
        },
      ),
    );
  }
}
