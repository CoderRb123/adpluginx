// 📦 Package imports:
import 'package:adpluginx/Logger/AdLogger.dart';
import 'package:adpluginx/Utils/UrlConst.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:unity_mediation/unity_mediation.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';

class UnityFullScreenX {
  static final UnityFullScreenX _singleton = UnityFullScreenX._internal();

  factory UnityFullScreenX() {
    return _singleton;
  }

  UnityFullScreenX._internal();

  callAds({
    required String adId,
    required AdCallerInterface adCallerInterface,
  }) {
    UnityMediation.loadInterstitialAd(
      adUnitId: adId,
      onComplete: (adUnitId) {
        AdLogger.logAd(provider: unityInterMediationKey, status: adLoadedKey);
        adCallerInterface.onLoaded();
        UnityMediation.showInterstitialAd(
          adUnitId: adId,
          onClosed: (_) {
            AdLogger.logAd(
                provider: unityInterMediationKey, status: adDismissedKey);

            adCallerInterface.onClose();
          },
          onClick: (adUnitId) {
            AdLogger.logAd(
                provider: unityInterMediationKey, status: adClickedKey);
          },
          onFailed: (_, p, q) {
            AdLogger.logAd(
                provider: unityInterMediationKey, status: adFailedKey);

            adCallerInterface.onError();
          },
        );
      },
      onFailed: (adUnitId, error, message) {
        adCallerInterface.onError();
      },
    );
  }

  callNormalAds({
    required String adId,
    required AdCallerInterface adCallerInterface,
  }) {
    UnityAds.load(
      placementId: adId,
      onComplete: (placementId) {
        adCallerInterface.onLoaded();
        UnityAds.showVideoAd(
          placementId: adId,
          onStart: (placementId) => print('Video Ad $placementId started'),
          onClick: (placementId) {
            AdLogger.logAd(provider: unityInterNormalKey, status: adClickedKey);
          },
          onSkipped: (placementId) {
            adCallerInterface.onClose();
          },
          onComplete: (placementId) {
            adCallerInterface.onClose();
            AdLogger.logAd(
                provider: unityInterNormalKey, status: adDismissedKey);
          },
          onFailed: (placementId, error, message) {
            adCallerInterface.onError();
            AdLogger.logAd(provider: unityInterNormalKey, status: adFailedKey);
          },
        );
      },
      onFailed: (placementId, error, message) {
        print('Load Failed $placementId: $error $message');
        AdLogger.logAd(
            provider: unityInterNormalKey, status: adFailedToLoadKey);
      },
    );
  }
}
