// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:applovin_max/applovin_max.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:adpluginx/adpluginx.dart';

class AppLovinMREC extends StatelessWidget {
  const AppLovinMREC({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdBase adBase = context.read<AdBase>();
    return MaxAdView(
      adUnitId: adBase.data!['adIds']['applovin']['mrec'],
      adFormat: AdFormat.mrec,
      listener: AdViewAdListener(
        onAdLoadedCallback: (ad) {},
        onAdLoadFailedCallback: (adUnitId, error) {},
        onAdClickedCallback: (ad) {},
        onAdExpandedCallback: (ad) {},
        onAdCollapsedCallback: (ad) {},
      ),
    );
  }
}
