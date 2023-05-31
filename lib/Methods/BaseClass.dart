// 📦 Package imports:
import 'package:adpluginx/AdBase/Yodo/YodoCallerX.dart';
import 'package:dog/dog.dart';
import 'package:flutter_lifecycle_detector/flutter_lifecycle_detector.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/AppLovin/AppLovinCallerx.dart';
import 'package:adpluginx/adpluginx.dart';

class BaseClass {
  static final BaseClass _singleton = BaseClass._internal();

  factory BaseClass() {
    return _singleton;
  }

  BaseClass._internal();

  bool initYodo = true;

  setYodoInit(bool state) {
    initYodo = state;
  }

  initAdNetworks({required Function onInitComplete}) async {
    AdBase adBase =
        NavigationService.navigatorKey.currentContext!.read<AdBase>();
    PackageInfoX().init();

    adBase.data.checkKeys();
    // Init All AdNetworks
    GoogleCallerX().initGoogleAds();
    FacebookCallerX().intFacebook();
    AppLovinCallerx().initAppLovin();
    UnityCallerX().initUnity();
    await IronSource.init(
      appKey: adBase.data!['adIds']['ironSource']['appId'],
      adUnits: [
        IronSourceAdUnit.Interstitial,
        IronSourceAdUnit.Banner,
        IronSourceAdUnit.RewardedVideo,
      ],
    );
    Future.delayed(Duration(milliseconds: 400), () {
      onInitComplete();
    });

    // showAdsOnForeGround(adBase.data!);
    // Onesignal

    // App Transparency

    // Next Action
  }

  showAdsOnForeGround(Map data) {
    FlutterLifecycleDetector().onBackgroundChange.listen((isBackground) {
      if (isBackground) {
        if (data[PackageInfoX().version]['isAdsOn'] ?? false) {
          if (data[PackageInfoX().version]['showAppOpenOnResume'] ?? false) {
            GoogleAppOpenX().callAds(
              adCallerInterface: AdCallerInterface(
                onClose: () {},
                onError: () {},
                onStarted: () {},
                onLoaded: () {},
                onFailedToLoad: () {},
              ),
              adId: data["adIds"]['google']['appOpen'],
            );
            return;
          }
          return;
        }
        return;
      }
      dog.i('Status background $isBackground');
    });
  }
}
