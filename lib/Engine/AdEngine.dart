// 🐦 Flutter imports:
import 'dart:async';

import 'package:adpluginx/AdBase/AdBase.dart';
import 'package:adpluginx/Subsciption/InAppStore.dart';
import 'package:adpluginx/adpluginx.dart';
import 'package:dog/dog.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:pmvvm/pmvvm.dart';

// 🌎 Project imports:
import 'package:adpluginx/Engine/FullScreen/FullScreenEngine.dart';
import 'package:adpluginx/Widget/Loader/LoaderProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdEngine {
  static final AdEngine _singleton = AdEngine._internal();

  factory AdEngine() {
    return _singleton;
  }

  AdEngine._internal();

  Timer? timer;

  Widget inAppWidget = InAppStore();

  setInAppDialog(Widget state) {
    inAppWidget = state;
  }

  showFullScreen({
    required BuildContext context,
    String action = "default",
    required Function() onJobComplete,
    bool showLoader = true,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isSub = NavigationService.navigatorKey.currentContext!
        .read<IapProvider>()
        .isSubscribed;
    if (isSub) {
      dog.i("You are Subscribed", tag: "SubScribed");
      onJobComplete();
      return;
    }
    if (showLoader) {
      NavigationService.navigatorKey.currentContext!
          .read<LoaderProvider>()
          .isAdLoading = true;
    }
    FullScreenEngine().showAds(
      onTimeOut: () {
        if (showLoader) {
          NavigationService.navigatorKey.currentContext!
              .read<LoaderProvider>()
              .isAdLoading = false;
        }
      },
      context: context,
      onJobComplete: () {
        dog.i("Abrt Timer on Job Done =========>", tag: "Timer");
        timer?.cancel();
        if (showLoader) {
          NavigationService.navigatorKey.currentContext!
              .read<LoaderProvider>()
              .isAdLoading = false;
        }
        int count = preferences.getInt("adCount") ?? 0;
        preferences.setInt("adCount", count + 1);
        DelayAlertHelper.showDialog(context: context);
        onJobComplete();
      },
    );
    dog.i("Started Timer of 10 Seconds =========>", tag: "Timer");
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      dog.i("Condition No Response Ad 10 Second Loader Close =========>",
          tag: "Timer");
      timer.cancel();
      if (showLoader) {
        NavigationService.navigatorKey.currentContext!
            .read<LoaderProvider>()
            .isAdLoading = false;
      }
    });
  }

  showActionBasedAds({
    required BuildContext context,
    required String actionName,
    String action = "default",
    required Function() onJobComplete,
    bool showLoader = true,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isSub = NavigationService.navigatorKey.currentContext!
        .read<IapProvider>()
        .isSubscribed;
    if (isSub) {
      dog.i("You are Subscribed", tag: "SubScribed");
      onJobComplete();
      return;
    }
    if (showLoader) {
      NavigationService.navigatorKey.currentContext!
          .read<LoaderProvider>()
          .isAdLoading = true;
    }
    FullScreenEngine().showActionAds(
      context: context,
      actionName: actionName,
      onJobComplete: () {
        dog.i("Abrt Timer on Job Done =========>", tag: "Timer");
        timer?.cancel();
        if (showLoader) {
          NavigationService.navigatorKey.currentContext!
              .read<LoaderProvider>()
              .isAdLoading = false;
        }
        int count = preferences.getInt("adCount") ?? 0;
        preferences.setInt("adCount", count + 1);
        DelayAlertHelper.showDialog(context: context);
        onJobComplete();
      },
    );
    dog.i("Started Timer of 10 Seconds =========>", tag: "Timer");
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      dog.i("Condition No Response Ad 10 Second Loader Close =========>",
          tag: "Timer");

      timer.cancel();
      if (showLoader) {
        NavigationService.navigatorKey.currentContext!
            .read<LoaderProvider>()
            .isAdLoading = false;
      }
    });
  }
}
