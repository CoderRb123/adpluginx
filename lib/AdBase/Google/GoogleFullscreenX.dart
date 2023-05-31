// 📦 Package imports:
import 'package:adpluginx/Logger/AdLogger.dart';
import 'package:adpluginx/Utils/UrlConst.dart';
import 'package:dog/dog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/AdBase.dart';
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';

class GoogleFullscreenX {
  static final GoogleFullscreenX _singleton = GoogleFullscreenX._internal();

  factory GoogleFullscreenX() {
    return _singleton;
  }

  GoogleFullscreenX._internal();

  InterstitialAd? _interstitialAd;

  void callAds({
    required String adId,
    String action = "default",
    required AdCallerInterface adCallerInterface,
  }) {
    InterstitialAd.load(
      adUnitId: adId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          dog.i("On Ad Loaded====>");
          AdLogger.logAd(
              action: action, provider: googleInterAdKey, status: adLoadedKey);
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
                onAdShowedFullScreenContent: (InterstitialAd ad) {
                  dog.i("On Ad Showed====>");
                },
                onAdDismissedFullScreenContent: (InterstitialAd ad) {
                  adCallerInterface.onClose();
                  dog.i("On Ad Dismissed====>");
                  AdLogger.logAd(
                      action: action,
                      provider: googleInterAdKey, status: adDismissedKey);
                  ad.dispose();
                },
                onAdFailedToShowFullScreenContent:
                    (InterstitialAd ad, AdError error) {
                  AdLogger.logAd(action: action,
                      provider: googleInterAdKey,
                      status: adFailedKey);
                  adCallerInterface.onError();
                  dog.i("On Ad Failed====>");
                  ad.dispose();
                },
              );
          adCallerInterface.onLoaded();
          _interstitialAd!.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          dog.i("On Ad Faield to Loade====> ${error.message}");
          AdLogger.logAd(action: action,
              provider: googleInterAdKey,
              status: adFailedToLoadKey);
          adCallerInterface.onError();
        },
      ),
    );
  }
}
