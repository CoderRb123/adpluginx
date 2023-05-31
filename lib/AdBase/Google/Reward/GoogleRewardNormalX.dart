// 📦 Package imports:
import 'package:adpluginx/Logger/AdLogger.dart';
import 'package:adpluginx/Utils/UrlConst.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/AdBase.dart';
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';

class GoogleRewardNormalX {
  static final GoogleRewardNormalX _singleton = GoogleRewardNormalX._internal();

  factory GoogleRewardNormalX() {
    return _singleton;
  }

  GoogleRewardNormalX._internal();

  RewardedInterstitialAd? _rewardNormalAd;

  void callAds({
    required String adId,
    String action = "default",
    required AdCallerInterface adCallerInterface,
  }) {
    RewardedInterstitialAd.load(
      adUnitId: adId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          AdLogger.logAd(action: action,provider: googleRewardAdKey, status: adLoadedKey);
          _rewardNormalAd = ad;
          _rewardNormalAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedInterstitialAd ad) {},
            onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
              AdLogger.logAd(
                  action: action,
                  provider: googleRewardAdKey, status: adDismissedKey);
              if (adCallerInterface.onRewardSkip != null) {
                adCallerInterface.onRewardSkip!();
              }
            },
            onAdFailedToShowFullScreenContent:
                (RewardedInterstitialAd ad, AdError error) {
              AdLogger.logAd(action: action,provider: googleRewardAdKey, status: adFailedKey);
              adCallerInterface.onError();
              ad.dispose();
            },
          );
          adCallerInterface.onLoaded();
          _rewardNormalAd!.show(
              onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
            adCallerInterface.onClose();
            ad.dispose();
          });
        },
        onAdFailedToLoad: (error) {
          _rewardNormalAd = null;
          AdLogger.logAd(
              action: action,
              provider: googleRewardAdKey, status: adFailedToLoadKey);
          adCallerInterface.onError();
        },
      ),
    );
  }
}
