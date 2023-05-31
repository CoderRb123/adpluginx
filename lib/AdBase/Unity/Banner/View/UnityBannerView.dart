// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dog/dog.dart';
import 'package:unity_mediation/unity_mediation.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/AdBase.dart';
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';

class UnityBannerView extends StatelessWidget {
  final String adId;
  final AdCallerInterface adCallerInterface;

  const UnityBannerView({
    Key? key,
    required this.adId,
    required this.adCallerInterface,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false ,
      child: BannerAd(
        adUnitId: adId,
        size: BannerSize.standard,
        onLoad: (adUnitId) {},
        onClick: (adUnitId) {},
        onFailed: (adUnitId, error, message) {
          dog.e(error.name);
          dog.e(message);
          adCallerInterface.onFailedToLoad();
        },
      ),
    );
  }
}
