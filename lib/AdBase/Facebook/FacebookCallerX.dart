// 📦 Package imports:
import 'package:dog/dog.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/Facebook/Fullscreen/FacebookFullscreen.dart';
import 'package:adpluginx/AdBase/Facebook/Reward/FacebookReward.dart';
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';
import 'package:adpluginx/adpluginx.dart';

enum FacebookAdType { fullScreen, rewardVideo }

class FacebookCallerX {
  static final FacebookCallerX _singleton = FacebookCallerX._internal();

  factory FacebookCallerX() {
    return _singleton;
  }

  FacebookCallerX._internal();

  void intFacebook() async {
    await FacebookAudienceNetwork.init(
        // testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
        iOSAdvertiserTrackingEnabled: true //default false
        );
    dog.i("Facebook Sdk Init Successfully");
  }

  void loadFacebook(
      {required FacebookAdType adType,
      required AdCallerInterface callerInterface}) {
    AdBase adBase =
        NavigationService.navigatorKey.currentContext!.read<AdBase>();
    switch (adType) {
      case FacebookAdType.fullScreen:
        FacebookFullscreen().callAds(
          adId: adBase.data!['adIds']['facebook']['fullScreen'],
          adCallerInterface: callerInterface,
        );
        break;
      case FacebookAdType.rewardVideo:

        FacebookReward().callAds(
          adId: adBase.data!['adIds']['facebook']['reward'],
          adCallerInterface: callerInterface,
        );
        break;
    }
  }
}
