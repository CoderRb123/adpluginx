import 'package:adpluginx/AdBase/AdBase.dart';
import 'package:adpluginx/Engine/AdEngine.dart';
import 'package:adpluginx/Subsciption/InAppStore.dart';
import 'package:adpluginx/adpluginx.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DelayAlertHelper {
  static showDialog({
    required BuildContext context,
    int days = 2,
  }) async {
    bool isPremium = context.read<IapProvider>().isSubscribed;
    bool isAdOn = context.read<AdBase>().data![PackageInfoX().version ?? "2.0"]
        ['isAdsOn'];
    if (isPremium) {
      return;
    }
    if (!isAdOn) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    int showAfter = context.read<AdBase>().data!['showIAP'] ?? 20;
    // Get last access
    int lastAccess = prefs.getInt('adCount') ?? 0;

    print("Dialog Data =======>");
    print(showAfter);
    print(lastAccess);
    if (lastAccess == 0) {
      return;
    }
    if (lastAccess % showAfter == 0) {
      showCupertinoDialog(
        context: context,
        builder: (context) => AdEngine().inAppWidget,
      );
      return;
    }

    return;
  }
}
