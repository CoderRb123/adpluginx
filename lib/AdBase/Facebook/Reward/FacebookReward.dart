// 📦 Package imports:
import 'package:adpluginx/Logger/AdLogger.dart';
import 'package:adpluginx/Utils/UrlConst.dart';
import 'package:dog/dog.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/AdBase.dart';
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';

class FacebookReward {
  static final FacebookReward _singleton = FacebookReward._internal();

  factory FacebookReward() {
    return _singleton;
  }

  FacebookReward._internal();

  callAds({
    required String adId,
    required AdCallerInterface adCallerInterface,
  }) {
    FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: adId,
      listener: (result, value) {
        dog.i(result.name);
        dog.i(value.toString());
        switch (result) {
          case RewardedVideoAdResult.VIDEO_COMPLETE:
            // TODO: Handle this case.
            adCallerInterface.onClose();
            break;
          case RewardedVideoAdResult.VIDEO_CLOSED:
            // TODO: Handle this case.
            AdLogger.logAd(
                provider: facebookRewardAdKey, status: adDismissedKey);
            if (adCallerInterface.onRewardSkip != null) {
              adCallerInterface.onRewardSkip!();
            }
            break;
          case RewardedVideoAdResult.ERROR:
            // TODO: Handle this case.
            AdLogger.logAd(provider: facebookRewardAdKey, status: adFailedKey);

            adCallerInterface.onError();
            break;

          case RewardedVideoAdResult.LOADED:
            adCallerInterface.onLoaded();
            // TODO: Handle this case.
            AdLogger.logAd(provider: facebookRewardAdKey, status: adLoadedKey);
            FacebookAudienceNetwork.showRewardedVideoAd(delay: 0);
            break;
          case RewardedVideoAdResult.CLICKED:
            AdLogger.logAd(provider: facebookRewardAdKey, status: adClickedKey);
            // TODO: Handle this case.
            break;
          case RewardedVideoAdResult.LOGGING_IMPRESSION:
            // TODO: Handle this case.
            break;
        }
      },
    );
  }
}
