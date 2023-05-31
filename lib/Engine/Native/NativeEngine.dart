// 🐦 Flutter imports:
import 'package:adpluginx/Utils/NavigationService.dart';
import 'package:adpluginx/adpluginx.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dog/dog.dart';
import 'package:pmvvm/pmvvm.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/AdBase.dart';
import 'package:adpluginx/AdBase/AppLovin/Mrec/AppLovinMREC.dart';
import 'package:adpluginx/AdBase/Facebook/Banner/FacebookBanner.dart';
import 'package:adpluginx/AdBase/Google/Native/View/GoogleNativeView.dart';
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';
import 'package:adpluginx/Utils/DeviceInformation/PackageInfoX.dart';
import '../Model/ScreenWiseModel.dart';

class NativeEngine extends HookWidget {
  final BuildContext parentContext;
  final Function()? onJobComplete;

  const NativeEngine({
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

    bool isSub = context.watch<IapProvider>().isSubscribed;
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
      if ((screenWiseModel.value!.isNativeEnable) == false) {
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
      switch (screenWiseModel.value!.native) {
        case 0:
          dog.i("Case Google Native");
          bannerWidget.value = const GoogleNativeView();
          break;
        case 1:
          dog.i("Case Facebook Native");
          bannerWidget.value = FacebookBanner(
            adId: context.read<AdBase>().data!['adIds']['facebook']['native'],
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
          dog.i("Case Applovin Native");
          bannerWidget.value = const AppLovinMREC();
          break;
        default:
          bannerWidget.value = const SizedBox(
            height: 0,
            width: 0,
          );
          break;
      }
    }

    fetchNative() {
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
            gridCount: local['localGridCount'] ?? 3,
            isNativeEnable: local['isNativeEnable'] ?? true,
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
          isNativeEnable: adBase.data![PackageInfoX().version ?? "0.0.1"]
                  ['isAdsOn'] ??
              false,
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

    useEffect(() {
      if (!isSub) {
        Future.microtask(() => fetchNative());
      }
      return () {};
    }, [isSub]);
    return isSub ? const SizedBox() : bannerWidget.value;
  }
}
