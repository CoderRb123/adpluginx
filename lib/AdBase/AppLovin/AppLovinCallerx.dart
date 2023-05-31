// 📦 Package imports:
import 'package:applovin_max/applovin_max.dart';
import 'package:dog/dog.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:adpluginx/adpluginx.dart';

class AppLovinCallerx {
  static final AppLovinCallerx _singleton = AppLovinCallerx._internal();

  factory AppLovinCallerx() {
    return _singleton;
  }

  AppLovinCallerx._internal();

  void initAppLovin() async {
    AdBase adBase =
        NavigationService.navigatorKey.currentContext!.read<AdBase>();
    Map? sdkConfiguration = await AppLovinMAX.initialize(
      adBase.data!['adIds']['applovin']['id'],
    );
    dog.i(sdkConfiguration.toString());
  }
}
