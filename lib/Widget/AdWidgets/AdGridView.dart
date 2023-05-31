// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dog/dog.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

// 🌎 Project imports:
import 'package:adpluginx/Engine/Model/ScreenWiseModel.dart';
import 'package:adpluginx/adpluginx.dart';

class AdGridView extends HookWidget {
  final List items;
  final BuildContext parentContext;
  final int mobileCount;
  final bool showAds;

  final double height;
  final EdgeInsets? padding;
  final int? specificIndex;
  final int tabletCount;
  final Widget Function(BuildContext context, int index, dynamic value)
      onRender;

  const AdGridView({
    Key? key,
    this.padding,
    this.showAds = true,
    this.specificIndex,
    required this.items,
    this.height = 1.7,
    required this.onRender,
    required this.parentContext,
    this.mobileCount = 2,
    this.tabletCount = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdBase adBase = context.read<AdBase>();
    final screenWiseModel = useState<ScreenWiseModel?>(null);
    final _items = useState<List>([]);
    final nativeHeight = useState<double>(
        double.tryParse(adBase.data!['native-heights'].toString()) ?? 1.7);
    final routeIndex = useState<Map>({});
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;
    IapProvider iapProvider = context.watch<IapProvider>();

    void listLogic() {
      List temp = List.from(items);
      List temp2 = List.from(items);
      int itemGap = (useMobileLayout ? mobileCount : tabletCount) *
          screenWiseModel.value!.gridCount!;
      if (iapProvider.isSubscribed) {
        _items.value = temp;
        return;
      }
      if (specificIndex != null) {
        temp2.insert(specificIndex!, "AD");
        _items.value = temp2;
        return;
      }
      for (int i = 0; i < temp.length; i++) {
        final length = i;
        if (length == 0) {
          continue;
        }
        if (length % (itemGap + 1) == 0) {
          temp2.insert(length + 1, "AD");
          continue;
        }
      }
      dog.i("clmaslckmas=======>");
      dog.i(temp);
      dog.i(items);

      _items.value = temp2;
    }

    addNatvieAds() {
      bool nativeAvalable = screenWiseModel.value!.isNativeEnable!;
      bool localAdFlag = screenWiseModel.value!.localAdFlag ?? false;
      bool mainAdFlag =
          adBase.data![PackageInfoX().version ?? "0.0.1"]['isAdsOn'] ?? false;
      if (mainAdFlag == false) {
        _items.value = List.from(items);
        dog.i("MainFlagCLose");
        return;
      }
      if (localAdFlag == false) {
        _items.value = List.from(items);
        dog.i("LocalFlagClose");
        return;
      }
      if (!nativeAvalable) {
        _items.value = List.from(items);
        dog.i("NativeFlagClose");
        return;
      }
      if (screenWiseModel.value!.gridCount == 0) {
        dog.i("NativeGrodCount");
        _items.value = List.from(items);
        return;
      }
      listLogic();
    }

    fetchNative() {
      ModalRoute? route = ModalRoute.of(parentContext);
      Map? local = adBase.data![PackageInfoX().version ?? "0.0.1"]['screens']
          [route?.settings.name];
      dog.i("Route ======>${route?.settings.name}");
      if (local != null) {
        // Have Route Locals
        dog.i("Have Rote Data ==> ${routeIndex.value[route?.settings.name]}");
        screenWiseModel.value = ScreenWiseModel(
            banner: local['banner'] ?? 0,
            gridCount: local['localGridCount'] ?? 3,
            isNativeEnable: local['isNativeEnable'] ?? true,
            native: local['native'] ?? 0,
            localAdFlag: local['localAdFlag'] ?? false,
            localClick: local['localClick'] ?? [0, 0, 0],
            localFail: local['localFail'] ?? {"0": 1, "1": 2, "2": 3, "3": 0});
      } else {
        dog.i("Global Data");
        // Take it Global
        screenWiseModel.value = ScreenWiseModel(
          gridCount: adBase.data![PackageInfoX().version ?? "0.0.1"]
                  ['globalGridCount'] ??
              3,
          isNativeEnable: adBase.data![PackageInfoX().version ?? "0.0.1"]
                  ['globalisNativeEnable'] ??
              true,
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
      addNatvieAds();
    }

    useEffect(() {
      Future.microtask(() {
        print("Calling Fetch");
        fetchNative();
      });
      return () {};
    }, [iapProvider.isSubscribed]);
    return BannerWrapper(
      parentContext: parentContext,
      child: StaggeredGridView.countBuilder(
        padding: padding ?? const EdgeInsets.all(10.0),
        itemCount: _items.value.length,
        addAutomaticKeepAlives: true,
        itemBuilder: (context, index) {
          return onRender(context, index, _items.value[index]);
        },
        crossAxisCount: useMobileLayout ? mobileCount : tabletCount,
        staggeredTileBuilder: (int index) {
          if (_items.value[index] != "AD") {
            return StaggeredTile.count(1, height);
          } else {
            return StaggeredTile.count(
              useMobileLayout ? 2 : 3,
              nativeHeight.value,
            );
          }
          // return StaggeredTile.count(1, 1);
        },
      ),
    );
  }
}
