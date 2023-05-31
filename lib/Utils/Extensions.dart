// 🐦 Flutter imports:
import 'package:adpluginx/Engine/Native/NativeEngine.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/AdBase.dart';
import 'package:adpluginx/Engine/AdEngine.dart';

extension AdState on BuildContext {
  void showFullScreenAds({required Function() onComplete}) {
    AdEngine().showFullScreen(context: this, onJobComplete: onComplete);
  }

  Widget showNativeAd() {
    return NativeEngine(parentContext: this, onJobComplete: () {});
  }

  Map? getMainJsonState({bool listen = true}) {
    return Provider.of<AdBase>(this, listen: listen).data;
  }
}

extension NavigationExtension on String {
  pushWithAds(BuildContext context, {Object? arguments}) {
    AdEngine().showFullScreen(
      context: context,
      onJobComplete: () {
        Navigator.pushNamed(
          context,
          this,
          arguments: arguments,
        );
      },
    );
  }

  pushReplaceWithAds(BuildContext context, {Object? arguments}) {
    AdEngine().showFullScreen(
      context: context,
      onJobComplete: () {
        Navigator.pushReplacementNamed(
          context,
          this,
          arguments: arguments,
        );
      },
    );
  }

  pushReplaceRemoveUntilWithAds(BuildContext context, {Object? arguments}) {
    AdEngine().showFullScreen(
      context: context,
      onJobComplete: () {
        Navigator.pushNamedAndRemoveUntil(context, this, (route) => false,
            arguments: arguments);
      },
    );
  }

  performAction({
    required BuildContext context,
    required Function() onComplete,
  }) {
    AdEngine().showActionBasedAds(
      context: context,
      actionName: this,
      onJobComplete: () {
        onComplete();
      },
    );
  }

  initOnesignal() async {
    await OneSignal.shared.setAppId(this);
    OneSignal.shared.promptUserForPushNotificationPermission();
  }
}

// Concept For Key to Required
extension CheckKeys on Map? {
  checkKeys() {}
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
