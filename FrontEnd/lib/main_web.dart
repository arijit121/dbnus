import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'const/color_const.dart';
import 'extension/hex_color.dart';
import 'firebase_options.dart';
import 'router/router_manager.dart';
import 'router/url_strategy/url_strategy.dart';
import 'service/firebase_service.dart';
import 'storage/localCart/bloc/local_cart_bloc.dart';
import 'utils/text_utils.dart';

Future<void> main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        theme: ThemeData(
          colorSchemeSeed: HexColor.fromHex(ColorConst.baseHexColor),
          useMaterial3: true,
          brightness: Brightness.light,
          pageTransitionsTheme: NoTransitionsOnWeb(),
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: HexColor.fromHex(ColorConst.baseHexColor),
          useMaterial3: true,
          brightness: Brightness.dark,
          pageTransitionsTheme: NoTransitionsOnWeb(),
        ),
        routerConfig: RouterManager.getInstance.router,
      ),
    );
  }
}

class NoTransitionsOnWeb extends PageTransitionsTheme {
  @override
  Widget buildTransitions<T>(
    route,
    context,
    animation,
    secondaryAnimation,
    child,
  ) {
    if (kIsWeb) {
      return child;
    }
    return super.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
