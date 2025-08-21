import 'package:dbnus/service/JsService/provider/js_provider.dart'
    deferred as js_provider;
import 'package:firebase_core/firebase_core.dart' deferred as firebase_core;
import 'package:firebase_performance/firebase_performance.dart'
    deferred as firebase_performance;
import 'package:flutter/foundation.dart' deferred as foundation;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'const/theme_const.dart';
import 'data/connection/bloc/connection_bloc.dart';
import 'extension/logger_extension.dart';
import 'firebase_options.dart' deferred as firebase_options;
import 'router/router_manager.dart';
import 'router/url_strategy/url_strategy.dart' deferred as url_strategy;
import 'service/Localization/bloc/localization_bloc.dart';
import 'service/Localization/l10n/app_localizations.dart';
import 'service/Localization/utils/localization_utils.dart';
import 'service/crash/utils/crash_utils.dart' deferred as crash_utils;
import 'service/firebase_service.dart' deferred as firebase_service;
import 'storage/localCart/bloc/local_cart_bloc.dart';
import 'utils/text_utils.dart';

Future<void> main() async {
  url_strategy.loadLibrary().then((_) {
    url_strategy.usePathUrlStrategy();
  });
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait(
      [firebase_core.loadLibrary(), firebase_options.loadLibrary()]);
  await firebase_core.Firebase.initializeApp(
      options: firebase_options.DefaultFirebaseOptions.currentPlatform);
  firebase_performance.loadLibrary().then((_) async {
    await firebase_performance.FirebasePerformance.instance
        .setPerformanceCollectionEnabled(true);
  });

  crash_utils.loadLibrary().then((_) async {
    await crash_utils.CrashUtils.setValue(value: false);
  });

  FlutterError.onError = (errorDetails) async {
    if (errorDetails.library?.contains("widgets library") == true) {
      await crash_utils.loadLibrary();
      crash_utils.CrashUtils.navigateToCrashPage({
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

  foundation.loadLibrary().then((_) {
    foundation.PlatformDispatcher.instance.onError = (error, stack) {
      AppLog.e("$error", stackTrace: stack, tag: "Error");
      return true;
    };
  });

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
      await firebase_service.loadLibrary();
      await firebase_service.FirebaseService.setAnalyticsCollectionEnabled();
      await firebase_service.FirebaseService.generateToken();
      await js_provider.loadLibrary();
      await js_provider.JsProvider.loadJs(jsPath: "assets/js/storage-utils.js");
      foundation.loadLibrary().then((_) async {
        await js_provider.JsProvider.loadJs(
            jsPath:
                "${foundation.kDebugMode ? "assets/" : ""}packages/flutter_inappwebview_web/assets/web/web_support.js");
      });
      await js_provider.JsProvider.loadJs(
          jsPath:
              "https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js");
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
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocalizationUtils.supportedLocales,
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
          );
        },
      ),
    );
  }
}
