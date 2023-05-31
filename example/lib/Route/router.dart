import 'package:adpluginx_example/Screens/home.dart';
import 'package:adpluginx_example/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

class Router {
  static MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Home.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const Home(),
        );

      case SplashScreen.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const SplashScreen(),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Material(
            child: Center(
              child: Text("404 page not founded"),
            ),
          ),
        );
    }
  }
}
