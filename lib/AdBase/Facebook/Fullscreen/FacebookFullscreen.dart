// 📦 Package imports:
import 'package:adpluginx/Logger/AdLogger.dart';
import 'package:adpluginx/Utils/UrlConst.dart';
import 'package:dog/dog.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/AdBase.dart';
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';

class FacebookFullscreen {
  static final FacebookFullscreen _singleton = FacebookFullscreen._internal();

  factory FacebookFullscreen() {
    return _singleton;
  }

  FacebookFullscreen._internal();

  callAds({
    required String adId,
    required AdCallerInterface adCallerInterface,
  }) {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: adId,
      listener: (result, value) {
        dog.i(value.toString(),title: "Facebook");
        switch (result) {
          case InterstitialAdResult.DISPLAYED:
            break;
          case InterstitialAdResult.DISMISSED:
            AdLogger.logAd(provider: facebookInterAdKey, status: adDismissedKey);
            adCallerInterface.onClose();
            break;
          case InterstitialAdResult.ERROR:
            // TODO: Handle this case.
            AdLogger.logAd(provider: facebookInterAdKey, status: adFailedKey);
            adCallerInterface.onError();
            break;
          case InterstitialAdResult.LOADED:
            adCallerInterface.onLoaded();
            AdLogger.logAd(provider: facebookInterAdKey, status: adLoadedKey);
            FacebookAudienceNetwork.showInterstitialAd(delay: 0);
            break;
          case InterstitialAdResult.CLICKED:
            AdLogger.logAd(provider: facebookInterAdKey, status: adClickedKey);
            break;
          case InterstitialAdResult.LOGGING_IMPRESSION:
            break;
        }
      },
    );
  }
}
