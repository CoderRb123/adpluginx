// 📦 Package imports:
import 'package:ironsource_mediation/ironsource_mediation.dart';

class IronSourceFullScreenX with IronSourceInterstitialListener {
  Function onClose;
  Function onFailed;
  Function onLoaded;

  IronSourceFullScreenX.onInit({
    required this.onClose,
    required this.onFailed,
    required this.onLoaded,
  });

  @override
  void onInterstitialAdClicked() {
    // TODO: implement onInterstitialAdClicked
  }

  @override
  void onInterstitialAdClosed() {
    onClose();
  }

  @override
  void onInterstitialAdLoadFailed(IronSourceError error) {
    // TODO: implement onInterstitialAdLoadFailed
    onFailed();
  }

  @override
  void onInterstitialAdOpened() {
    // TODO: implement onInterstitialAdOpened
  }

  @override
  void onInterstitialAdReady() {
    // TODO: implement onInterstitialAdReady
    onLoaded();
  }

  @override
  void onInterstitialAdShowFailed(IronSourceError error) {
    // TODO: implement onInterstitialAdShowFailed
  }

  @override
  void onInterstitialAdShowSucceeded() {
    // TODO: implement onInterstitialAdShowSucceeded
  }
}
