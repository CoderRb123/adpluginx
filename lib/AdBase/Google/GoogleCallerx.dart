// 📦 Package imports:
import 'package:dog/dog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:adpluginx/Utils/TestIdConstansts.dart';
import 'package:adpluginx/Utils/UtilsSingleTone.dart';
import 'package:adpluginx/adpluginx.dart';

export './GoogleFullscreenX.dart';

enum GoogleAdType { fullScreen, rewardVideo, rewardNormal, appOpen }

class GoogleCallerX {
  static final GoogleCallerX _singleton = GoogleCallerX._internal();

  factory GoogleCallerX() {
    return _singleton;
  }

  GoogleCallerX._internal();

  void initGoogleAds() async {
    await MobileAds.instance.initialize();
    dog.i("Google Sdk Init Successfully");
  }

  /// Method To Load Different Ad Type in One
  /// This Include [GoogleAdType]
  void loadGoogleAd(
      {required GoogleAdType adType,
        String action = "default",
      required AdCallerInterface callerInterface}) {
    AdBase adBase =
        NavigationService.navigatorKey.currentContext!.read<AdBase>();
    Map json = adBase.data!;
    switch (adType) {
      case GoogleAdType.fullScreen:
        GoogleFullscreenX().callAds(
          action: action,
          adId: UtilsSingleTone().forceTest
              ? TestIdsConst().googleTestFullScreenID
              : json['adIds']['google']['fullScreen'],
          adCallerInterface: callerInterface,
        );
        break;
      case GoogleAdType.rewardVideo:
        GoogleRewardVideoX().callAds(
          action: action,
          adId: UtilsSingleTone().forceTest
              ? TestIdsConst().googleTestRewardID
              : json['adIds']['google']['rewardVideo'],
          adCallerInterface: callerInterface,
        );
        break;
      case GoogleAdType.rewardNormal:
        GoogleRewardNormalX().callAds(
          action: action,
          adId: UtilsSingleTone().forceTest
              ? TestIdsConst().googleTestRewardID
              : json['adIds']['google']['reward'],
          adCallerInterface: callerInterface,
        );
        break;
      case GoogleAdType.appOpen:
        GoogleAppOpenX().callAds(
          adId: UtilsSingleTone().forceTest
              ? TestIdsConst().googleAppOpen
              : json['adIds']['google']['appOpen'],
          adCallerInterface: callerInterface,
        );
        break;
    }
  }
}
