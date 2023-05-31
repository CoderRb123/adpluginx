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

class AppLovinReward {
  static final AppLovinReward _singleton = AppLovinReward._internal();

  factory AppLovinReward() {
    return _singleton;
  }

  AppLovinReward._internal();

  callAds({
    required AdCallerInterface adCallerInterface,
  }) async {
    AdBase adBase =
        NavigationService.navigatorKey.currentContext!.read<AdBase>();
    AppLovinMAX.setRewardedAdListener(RewardedAdListener(
      onAdLoadedCallback: (ad) async {
        AdLogger.logAd(provider: appLovinRewardKey, status: adLoadedKey);
        dog.i("onAdLoadedCallback");
        bool isReady = (await AppLovinMAX.isRewardedAdReady(
          adBase.data!['adIds']['applovin']['reward'],
        ))!;
        if (isReady) {
          adCallerInterface.onLoaded();
          AppLovinMAX.showRewardedAd(
            adBase.data!['adIds']['applovin']['reward'],
          );
          return;
        }
        adCallerInterface.onError();
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        dog.i("onAdLoadFailedCallback");
        AdLogger.logAd(provider: appLovinRewardKey, status: adFailedToLoadKey);
        adCallerInterface.onError();
      },
      onAdDisplayedCallback: (ad) {
        dog.i("onAdDisplayedCallback");
      },
      onAdDisplayFailedCallback: (ad, error) {
        AdLogger.logAd(provider: appLovinRewardKey, status: adFailedKey);
        dog.i("onAdDisplayFailedCallback");
      },
      onAdClickedCallback: (ad) {
        AdLogger.logAd(provider: appLovinRewardKey, status: adClickedKey);
        dog.i("onAdClickedCallback");
      },
      onAdHiddenCallback: (ad) {
        dog.i("onAdHiddenCallback");
        if (adCallerInterface.onRewardSkip != null) {
          adCallerInterface.onRewardSkip!();
        }
      },
      onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward) {
        adCallerInterface.onClose();
        AdLogger.logAd(provider: appLovinRewardKey, status: adDismissedKey);
        dog.i("onAdReceivedRewardCallback");
      },
    ));
    AppLovinMAX.loadRewardedAd(
      adBase.data!['adIds']['applovin']['reward'],
    );
  }
}
