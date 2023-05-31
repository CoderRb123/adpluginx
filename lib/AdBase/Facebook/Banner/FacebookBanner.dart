// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:facebook_audience_network/facebook_audience_network.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';

class FacebookBanner extends StatelessWidget {
  final String adId;
  final AdCallerInterface adCallerInterface;

  const FacebookBanner(
      {Key? key, required this.adId, required this.adCallerInterface})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0.5, 1),
      child: FacebookBannerAd(
        placementId: adId,
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          switch (result) {
            case BannerAdResult.ERROR:
              adCallerInterface.onFailedToLoad();
              break;
            case BannerAdResult.LOADED:
              break;
            case BannerAdResult.CLICKED:
              break;
            case BannerAdResult.LOGGING_IMPRESSION:
              break;
          }
        },
      ),
    );
  }
}
