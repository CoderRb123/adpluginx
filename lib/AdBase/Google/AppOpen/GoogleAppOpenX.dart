// 📦 Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/AdBase.dart';
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';

class GoogleAppOpenX {
  static final GoogleAppOpenX _singleton = GoogleAppOpenX._internal();

  factory GoogleAppOpenX() {
    return _singleton;
  }

  GoogleAppOpenX._internal();

  AppOpenAd? _appOpenAd;

  void callAds({
    required String adId,
    String action = "default",
    required AdCallerInterface adCallerInterface,
  }) {
    AppOpenAd.load(
      adUnitId: adId,
      orientation: AppOpenAd.orientationPortrait,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdFailedToShowFullScreenContent: (ad, error) {
              adCallerInterface.onError();
              ad.dispose();
              _appOpenAd = null;
            },
            onAdDismissedFullScreenContent: (ad) {
              adCallerInterface.onClose();
              ad.dispose();
              _appOpenAd = null;
            },
          );
          adCallerInterface.onLoaded();
          _appOpenAd!.show();

        },
        onAdFailedToLoad: (error) {
          _appOpenAd = null;
          adCallerInterface.onError();
        },
      ),
      request: const AdRequest(),
    );
  }
}
