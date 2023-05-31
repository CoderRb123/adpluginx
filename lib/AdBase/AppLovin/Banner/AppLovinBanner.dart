// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:applovin_max/applovin_max.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/AdBase.dart';

class AppLovinBanner extends StatelessWidget {
  const AppLovinBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdBase adBase = context.read<AdBase>();
    return MaxAdView(
      adUnitId: adBase.data!['adIds']['applovin']['banner'],
      adFormat: AdFormat.banner,
      listener: AdViewAdListener(
          onAdLoadedCallback: (ad) {},
          onAdLoadFailedCallback: (adUnitId, error) {},
          onAdClickedCallback: (ad) {},
          onAdExpandedCallback: (ad) {},
          onAdCollapsedCallback: (ad) {}),
    );
  }
}
