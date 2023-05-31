// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:adpluginx/Engine/Banner/BannerEngine.dart';

class BannerWrapper extends StatelessWidget {
  final Widget child;
  final BuildContext parentContext;

  const BannerWrapper({
    Key? key,
    required this.child,
    required this.parentContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: child,
          ),
          BannerEngine(
            parentContext: parentContext,
            onJobComplete: () {},
          ),
        ],
      ),
    );
  }
}
