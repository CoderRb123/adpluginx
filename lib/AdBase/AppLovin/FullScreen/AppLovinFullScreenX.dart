// 📦 Package imports:
import 'package:adpluginx/Logger/AdLogger.dart';
import 'package:adpluginx/Utils/UrlConst.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:dog/dog.dart';
import 'package:provider/provider.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:unity_mediation/unity_mediation.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';
import 'package:adpluginx/adpluginx.dart';

class AppLovinFullScreenX {
  static final AppLovinFullScreenX _singleton = AppLovinFullScreenX._internal();

  factory AppLovinFullScreenX() {
    return _singleton;
  }

  AppLovinFullScreenX._internal();

  callAds({
    required AdCallerInterface adCallerInterface,
  }) async {
    AdBase adBase =
    NavigationService.navigatorKey.currentContext!.read<AdBase>();
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) async {
        AdLogger.logAd(provider: appLovinInterKey, status: adLoadedKey);
        bool isReady = (await AppLovinMAX.isInterstitialReady(
          adBase.data!['adIds']['applovin']['fullScreen'],
        ))!;
        if (isReady) {
          adCallerInterface.onLoaded();
          AppLovinMAX.showInterstitial(
            adBase.data!['adIds']['applovin']['fullScreen'],
          );
        }
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        AdLogger.logAd(provider: appLovinInterKey, status: adFailedToLoadKey);
        adCallerInterface.onError();
      },
      onAdDisplayedCallback: (ad) {
        dog.i("onAdDisplayedCallback");
      },
      onAdDisplayFailedCallback: (ad, error) {
        dog.i("onAdDisplayFailedCallback");
      },
      onAdClickedCallback: (ad) {
        dog.i("onAdClickedCallback");
      },
      onAdHiddenCallback: (ad) {
        AdLogger.logAd(provider: appLovinInterKey, status: adDismissedKey);
        adCallerInterface.onClose();
        dog.i("onAdHiddenCallback");
      },
    ));
    AppLovinMAX.loadInterstitial(
      adBase.data!['adIds']['applovin']['fullScreen'],
    );
  }
}
