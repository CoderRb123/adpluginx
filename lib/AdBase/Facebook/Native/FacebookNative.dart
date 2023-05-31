// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:facebook_audience_network/facebook_audience_network.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';

class FacebookNative extends StatelessWidget {
  final String adId;
  final AdCallerInterface adCallerInterface;

  const FacebookNative(
      {Key? key, required this.adId, required this.adCallerInterface})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FacebookNativeAd(
      placementId: adId,
      adType: NativeAdType.NATIVE_AD,
      width: double.infinity,
      height: 300,
      backgroundColor: Colors.blue,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      keepAlive: true,
      keepExpandedWhileLoading: false,
      expandAnimationDuraion: 300,
      listener: (result, value) {
        switch (result) {
          case NativeAdResult.ERROR:
            adCallerInterface.onFailedToLoad();
            break;
          case NativeAdResult.LOADED:
            // TODO: Handle this case.
            break;
          case NativeAdResult.CLICKED:
            // TODO: Handle this case.
            break;
          case NativeAdResult.LOGGING_IMPRESSION:
            // TODO: Handle this case.
            break;
          case NativeAdResult.MEDIA_DOWNLOADED:
            // TODO: Handle this case.
            break;
        }
      },
    );
  }
}
