// 📦 Package imports:
import 'package:adpluginx/Logger/AdLogger.dart';
import 'package:adpluginx/Utils/UrlConst.dart';
import 'package:unity_mediation/unity_mediation.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';

class UnityRewardX {
  static final UnityRewardX _singleton = UnityRewardX._internal();

  factory UnityRewardX() {
    return _singleton;
  }

  UnityRewardX._internal();

  callAds({
    required String adId,
    required AdCallerInterface adCallerInterface,
  }) {
    UnityMediation.loadRewardedAd(
      adUnitId: adId,
      onComplete: (adUnitId) {
        adCallerInterface.onLoaded();
        UnityMediation.showRewardedAd(
            adUnitId: adId,
            onClick: (adUnitId) {
              AdLogger.logAd(
                  provider: unityRewardMediationKey, status: adClickedKey);
            },
            onRewarded: (adUnitId, reward) {},
            onClosed: (_) {
              adCallerInterface.onClose();
              AdLogger.logAd(
                  provider: unityRewardMediationKey, status: adDismissedKey);
            },
            onFailed: (_, p, q) {
              AdLogger.logAd(
                  provider: unityRewardMediationKey, status: adFailedKey);
              adCallerInterface.onError();
            });
      },
      onFailed: (adUnitId, error, message) {
        AdLogger.logAd(
            provider: unityRewardMediationKey, status: adFailedToLoadKey);
        adCallerInterface.onError();
      },
    );
  }
}
