// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:ironsource_mediation/ironsource_mediation.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';

class IronSourceBannerX extends StatefulWidget {
  final AdCallerInterface adCallerInterface;

  const IronSourceBannerX({
    Key? key,
    required this.adCallerInterface,
  }) : super(key: key);

  @override
  State<IronSourceBannerX> createState() => _IronSourceBannerXState();
}

class _IronSourceBannerXState extends State<IronSourceBannerX>
    with IronSourceBannerListener {
  @override
  void initState() {
    IronSource.loadBanner(
        size: IronSourceBannerSize.BANNER,
        position: IronSourceBannerPosition.Bottom);
    IronSource.displayBanner();
    super.initState();
  }

  @override
  void dispose() {
    IronSource.destroyBanner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }

  @override
  void onBannerAdClicked() {
    // TODO: implement onBannerAdClicked
  }

  @override
  void onBannerAdLeftApplication() {
    // TODO: implement onBannerAdLeftApplication
  }

  @override
  void onBannerAdLoadFailed(IronSourceError error) {
    // TODO: implement onBannerAdLoadFailed
    widget.adCallerInterface.onFailedToLoad();
  }

  @override
  void onBannerAdLoaded() {
    // TODO: implement onBannerAdLoaded
  }

  @override
  void onBannerAdScreenDismissed() {
    // TODO: implement onBannerAdScreenDismissed
  }

  @override
  void onBannerAdScreenPresented() {
    // TODO: implement onBannerAdScreenPresented
  }
}
