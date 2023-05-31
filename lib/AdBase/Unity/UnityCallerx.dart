// 📦 Package imports:
import 'package:dog/dog.dart';
import 'package:provider/provider.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:unity_mediation/unity_mediation.dart';

// 🌎 Project imports:
import 'package:adpluginx/adpluginx.dart';

enum UnityAdType {
  fullScreen,
  rewardVideo,
  normalFullScreen,
  normalRewardVideo
}

class UnityCallerX {
  static final UnityCallerX _singleton = UnityCallerX._internal();

  factory UnityCallerX() {
    return _singleton;
  }

  UnityCallerX._internal();

  void initUnity() async {
    AdBase adBase =
        NavigationService.navigatorKey.currentContext!.read<AdBase>();
    if (adBase.data!['adIds']['unity']['isMediation'] ?? false) {
      await UnityMediation.initialize(
        gameId: adBase.data!['adIds']['unity']['gameId'],
        onComplete: () {
          dog.i("Unity Sdk With Mediation Init Successfully");
        },
        onFailed: (error, message) {
          dog.e(message, title: "Unity Ad With Mediation Init Error");
        },
      );
    } else {
      await UnityAds.init(
        gameId: adBase.data!['adIds']['unity']['gameId'],
        onComplete: () {
          dog.i("Unity Sdk Without Mediation Init Successfully");
        },
        onFailed: (error, message) {
          dog.e(message, title: "Unity Ad Without Mediation Init Error");
        },
      );
    }
  }

  /// Method To Load Different Ad Type in One
  /// This Include [UnityAdType]
  void loadUnityAd(
      {required UnityAdType adType,
      required AdCallerInterface callerInterface}) {
    AdBase adBase =
        NavigationService.navigatorKey.currentContext!.read<AdBase>();
    Map json = adBase.data!;
    switch (adType) {
      case UnityAdType.fullScreen:
        if (json['adIds']['unity']['isMediation'] ?? false) {
          UnityFullScreenX().callAds(
            adId: json['adIds']['unity']['placementId'],
            adCallerInterface: callerInterface,
          );
        } else {
          UnityFullScreenX().callNormalAds(
            adId: json['adIds']['unity']['mediationConfig']['inter'],
            adCallerInterface: callerInterface,
          );
        }
        break;
      case UnityAdType.rewardVideo:
        if (json['adIds']['unity']['isMediation'] ?? false) {
          UnityRewardX().callAds(
            adId: json['adIds']['unity']['reward'],
            adCallerInterface: callerInterface,
          );
        } else {
          UnityFullScreenX().callNormalAds(
            adId: json['adIds']['unity']['mediationConfig']['reward'],
            adCallerInterface: callerInterface,
          );
        }

        break;
      case UnityAdType.normalFullScreen:
        break;
      case UnityAdType.normalRewardVideo:
        break;
    }
  }
}
