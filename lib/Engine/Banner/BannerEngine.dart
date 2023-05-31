// 🐦 Flutter imports:
import 'package:adpluginx/Utils/DeviceInformation/PackageInfoX.dart';
import 'package:adpluginx/adpluginx.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dog/dog.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/AdBase.dart';
import 'package:adpluginx/AdBase/AppLovin/Banner/AppLovinBanner.dart';
import 'package:adpluginx/AdBase/Facebook/Banner/FacebookBanner.dart';
import 'package:adpluginx/AdBase/Google/Banner/View/GoogleBannerView.dart';
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';
import 'package:adpluginx/AdBase/IronSource/IronSourceBannerX.dart';
import 'package:adpluginx/AdBase/Unity/Banner/View/UnityBannerView.dart';
import '../Model/ScreenWiseModel.dart';

class BannerEngine extends HookWidget {
  final BuildContext parentContext;
  final Function()? onJobComplete;

  const BannerEngine({
    Key? key,
    required this.parentContext,
    required this.onJobComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bannerWidget = useState<Widget>(const SizedBox(
      height: 0,
      width: 0,
    ));

    int MAX_RETRY = 3;

    final screenWiseModel = useState<ScreenWiseModel?>(null);

    final routeIndex = useState<Map>({});

    _showAd({String? route}) {
      AdBase adBase = context.read<AdBase>();
      if ((adBase.data![PackageInfoX().version ?? "0.0.1"]['isAdsOn'] ??
              false) ==
          false) {
        bannerWidget.value = const SizedBox(
          height: 0,
          width: 0,
        );
        return;
      }
      if ((screenWiseModel.value!.localAdFlag ?? false) == false) {
        bannerWidget.value = const SizedBox(
          height: 0,
          width: 0,
        );
        return;
      }
      switch (screenWiseModel.value!.banner) {
        case 0:
          dog.i("Case Google Banner");
          bannerWidget.value = const GoogleBannerView();
          break;
        case 1:
          dog.i("Case Facebook Banner");
          bannerWidget.value = FacebookBanner(
            adId: context.read<AdBase>().data!['adIds']['facebook']['banner'],
            adCallerInterface: AdCallerInterface(
              onClose: () {},
              onError: () {},
              onStarted: () {},
              onLoaded: () {},
              onFailedToLoad: () {},
            ),
          );
          break;
        case 2:
          dog.i("Case Unity Banner");
          if (context.read<AdBase>().data!['adIds']['unity']['isMediation'] ??
              false) {
            bannerWidget.value = UnityBannerView(
              adId: context.read<AdBase>().data!['adIds']['unity']['banner'],
              adCallerInterface: AdCallerInterface(
                onClose: () {},
                onError: () {},
                onStarted: () {},
                onLoaded: () {},
                onFailedToLoad: () {},
              ),
            );
          } else {
            bannerWidget.value = SafeArea(
              top: false,
              child: UnityBannerAd(
                size: BannerSize.standard,
                placementId: context.read<AdBase>().data!['adIds']['unity']
                    ['banner'],
                onLoad: (placementId) => dog.i('Banner loaded: $placementId'),
                onClick: (placementId) => dog.i('Banner clicked: $placementId'),
                onFailed: (placementId, error, message) =>
                    dog.i('Banner Ad $placementId failed: $error $message'),
              ),
            );
          }
          break;
        case 3:
          dog.i("Case IronSource Banner");
          bannerWidget.value = IronSourceBannerX(
            adCallerInterface: AdCallerInterface(
              onClose: () {},
              onError: () {},
              onStarted: () {},
              onLoaded: () {},
              onFailedToLoad: () {},
            ),
          );
          break;
        case 4:
          dog.i("Case AppLovin Banner");
          bannerWidget.value =
              const SafeArea(top: false, child: AppLovinBanner());
          break;
        default:
          bannerWidget.value = const SizedBox(
            height: 0,
            width: 0,
          );
          break;
      }
    }

    fetchBanner() {
      ModalRoute? route = ModalRoute.of(parentContext);
      AdBase adBase = context.read<AdBase>();
      Map? local = adBase.data![PackageInfoX().version ?? "0.0.1"]['screens']
          [route?.settings.name];
      dog.i("Route ======>${route?.settings.name}");
      if (local != null) {
        // Have Route Locals
        dog.i("Have Rote Data ==> ${routeIndex.value[route?.settings.name]}");
        screenWiseModel.value = ScreenWiseModel(
            banner: local['banner'] ?? 0,
            native: local['native'] ?? 0,
            localAdFlag: local['localAdFlag'] ?? false,
            localClick: local['localClick'] ?? [0, 0, 0],
            localFail: local['localFail'] ?? {"0": 1, "1": 2, "2": 3, "3": 0});
      } else {
        dog.i("Global Data");

        // Take it Global
        screenWiseModel.value = ScreenWiseModel(
          banner: adBase.data![PackageInfoX().version ?? "0.0.1"]
                  ['globalBanner'] ??
              0,
          native: adBase.data![PackageInfoX().version ?? "0.0.1"]
                  ['globalNative'] ??
              0,
          localAdFlag: adBase.data![PackageInfoX().version ?? "0.0.1"]
                  ['isAdsOn'] ??
              false,
          localClick: (adBase.data![PackageInfoX().version ?? "0.0.1"]
                  ['globalClick']) ??
              [0, 0, 0],
          localFail: adBase.data![PackageInfoX().version ?? "0.0.1"]
                  ['globalFail'] ??
              {"0": 1, "1": 2, "2": 3, "3": 0},
        );
      }
      _showAd(route: route?.settings.name);
    }

    bool isSub = context.watch<IapProvider>().isSubscribed;
    useEffect(() {
      if (!isSub) {
        Future.microtask(() => fetchBanner());
      }
      return () {};
    }, [isSub]);
    return isSub ? const SizedBox() : bannerWidget.value;
  }
}
