// 📦 Package imports:
import 'package:adpluginx/Logger/AdLogger.dart';
import 'package:adpluginx/Utils/UrlConst.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/AdBase.dart';
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';

class GoogleRewardVideoX {
  static final GoogleRewardVideoX _singleton = GoogleRewardVideoX._internal();

  factory GoogleRewardVideoX() {
    return _singleton;
  }

  GoogleRewardVideoX._internal();

  RewardedAd? _rewardVideoAd;

  void callAds({
    required String adId,
    String action = "default",
    required AdCallerInterface adCallerInterface,
  }) {
    RewardedAd.load(
      adUnitId: adId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardVideoAd = ad;
          AdLogger.logAd(action: action,
              provider: googleRewardVideoAdKey,
              status: adLoadedKey);
          _rewardVideoAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedAd ad) {},
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              AdLogger.logAd(
                  action: action,
                  provider: googleRewardVideoAdKey, status: adDismissedKey);
              if (adCallerInterface.onRewardSkip != null) {
                adCallerInterface.onRewardSkip!();
              }
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              AdLogger.logAd(
                  action: action,
                  provider: googleRewardVideoAdKey, status: adFailedKey);
              adCallerInterface.onError();
              ad.dispose();
            },
          );
          adCallerInterface.onLoaded();
          _rewardVideoAd!.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
              adCallerInterface.onClose();
              ad.dispose();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _rewardVideoAd = null;
          AdLogger.logAd(
              action: action,
              provider: googleRewardVideoAdKey, status: adFailedToLoadKey);
          adCallerInterface.onError();
        },
      ),
    );
  }
}
