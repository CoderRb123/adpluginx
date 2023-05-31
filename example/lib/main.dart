import 'package:adpluginx/adpluginx.dart';
import 'package:adpluginx_example/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import './Route/router.dart' as r;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return AdMaterialApp(
      initAdNetworks: false,
      onInitComplete: (ctx, mainJson) {

      },
      splashScreen: SplashScreen(),
      forceTest: false,
      jsonUrl: ["http://miracocopepsi.com/test.json"],
      routeBuilder: r.Router.onGenerateRoute,
      title: "Spin",
    );
  }
}
