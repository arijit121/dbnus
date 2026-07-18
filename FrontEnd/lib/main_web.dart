import 'package:dbnus/core/services/JsService/provider/js_provider.dart'
    deferred as js_provider;
import 'package:firebase_core/firebase_core.dart' deferred as firebase_core;
import 'package:flutter/foundation.dart' deferred as foundation;
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dbnus/shared/constants/theme_const.dart';
import 'package:dbnus/core/network/connection/bloc/connection_bloc.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/firebase_options.dart' deferred as firebase_options;
import 'package:dbnus/navigation/router_manager.dart';
import 'package:dbnus/core/localization/bloc/localization_bloc.dart';
import 'package:dbnus/core/localization/app_localizations/app_localizations.dart';
import 'package:dbnus/core/localization/utils/localization_utils.dart';
import 'package:dbnus/core/services/crash/utils/crash_utils.dart'
    deferred as crash_utils;
import 'package:dbnus/core/services/firebase_service.dart'
    deferred as firebase_service;
import 'package:dbnus/core/storage/localCart/bloc/local_cart_bloc.dart';
import 'package:dbnus/shared/utils/text_utils.dart';

import 'navigation/url_strategy/url_strategy.dart' deferred as url_strategy;
import 'package:flutter/rendering.dart';


Future<void> main() async {
  url_strategy.loadLibrary().then((_) {
    url_strategy.usePathUrlStrategy();
  });
  WidgetsFlutterBinding.ensureInitialized();
  SemanticsBinding.instance.ensureSemantics();

  await Future.wait(
      [firebase_core.loadLibrary(), firebase_options.loadLibrary()]);
  await firebase_core.Firebase.initializeApp(
      options: firebase_options.DefaultFirebaseOptions.currentPlatform);
/*  firebase_performance.loadLibrary().then((_) async {
    await firebase_performance.FirebasePerformance.instance
        .setPerformanceCollectionEnabled(true);
  });*/
  runApp(const MyWebApp());
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
      await Future.wait([
        firebase_service.FirebaseService.setAnalyticsCollectionEnabled(),
        firebase_service.FirebaseService.generateToken()
      ]);
      await js_provider.loadLibrary();
      foundation.loadLibrary().then((_) async {
        await Future.wait([
          js_provider.JsProvider.loadJs(
              jsPath:
                  "${foundation.kDebugMode ? "assets/" : ""}packages/flutter_inappwebview_web/assets/web/web_support.js"),
          if (foundation.kReleaseMode) js_provider.JsProvider.installPWA()
        ]);
      });
      await Future.wait([
        js_provider.JsProvider.loadJs(jsPath: "assets/js/storage-utils.js"),
        js_provider.JsProvider.loadJs(
            jsPath:
                "https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"),
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (BuildContext context) =>
              LocalCartBloc()..add(InItLocalCartEvent()),
        ),
        BlocProvider(
          lazy: false,
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
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown
              },
            ),
            themeMode: ThemeMode.light,
            theme: ThemeConst.theme,
            darkTheme: ThemeConst.darkTheme,
            routerConfig: RouterManager.getInstance.router,
          );
        },
      ),
    );
  }
}
