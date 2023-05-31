// 🐦 Flutter imports:
import 'package:adpluginx/IAP/CoinProvider.dart';
import 'package:adpluginx/Subsciption/IapProvider.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:dog/dog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 📦 Package imports:
import 'package:pmvvm/pmvvm.dart';

// 🌎 Project imports:
import 'package:adpluginx/Model/LoaderConfigration.dart';
import 'package:adpluginx/Utils/UtilsSingleTone.dart';
import 'package:adpluginx/Widget/Loader/GlobalAdLoader.dart';
import 'package:adpluginx/Widget/Loader/LoaderProvider.dart';
import 'package:adpluginx/adpluginx.dart';

const _servers = [
  "coinspinmaster.com",
  "miracocopepsi.com",
  "trailerspot4k.com",
];

class AdMaterialApp extends HookWidget {
  final Route Function(RouteSettings settings) routeBuilder;
  final List<String> jsonUrl;
  final List<String>? servers;
  final String title;
  final Widget splashScreen;
  final bool forceTest;
  final bool initAdNetworks;
  final LoaderConfigration loaderConfigration;
  final Function(BuildContext ctx, Map mainJson)? onInitComplete;
  final ThemeData? theme;
  final ThemeData? darkTheme;

  const AdMaterialApp({
    Key? key,
    required this.routeBuilder,
    required this.jsonUrl,
    this.onInitComplete,
    this.initAdNetworks = true,
    this.theme,
    this.darkTheme,
    this.servers,
    this.title = "",
    this.forceTest = false,
    this.loaderConfigration = const LoaderConfigration(),
    required this.splashScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.microtask(() async {
        DartPingIOS.register();
        UtilsSingleTone().forceTest = forceTest;
        UtilsSingleTone().loaderConfigration = loaderConfigration;
        await AppTrackingTransparency.requestTrackingAuthorization();
      });
      dog = Dog(
        handler: Handler(
          formatter: PrettyFormatter(),
          emitter: ConsoleEmitter(supportsAnsiColor: true),
        ),
      );
      return () {};
    });
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AdBase>(
          create: (context) => AdBase(),
        ),
        ChangeNotifierProvider<LoaderProvider>(
          create: (context) => LoaderProvider(),
        ),
        ChangeNotifierProvider<CoinProvider>(
          create: (context) => CoinProvider(),
        ),
        ChangeNotifierProvider<IapProvider>(
          create: (context) => IapProvider(),
        ),
      ],
      child: GlobalAdLoader(
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              onGenerateRoute: routeBuilder,
              debugShowCheckedModeBanner: false,
              navigatorKey: NavigationService.navigatorKey,
              title: title,
              theme: theme,
              darkTheme: darkTheme,
              home: SplashView(
                initAdNetworks: initAdNetworks,
                onInitComplete: onInitComplete,
                jsonUrl: jsonUrl,
                servers: servers ?? _servers,
                child: splashScreen,
              ),
              themeMode: ThemeMode.dark,
            );
          },
        ),
      ),
    );
  }
}
