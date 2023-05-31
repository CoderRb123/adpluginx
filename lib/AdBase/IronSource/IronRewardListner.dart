// 📦 Package imports:
import 'package:dog/dog.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';

class IronRewardListener with IronSourceRewardedVideoListener {
  Function onClose;
  Function onFailed;
  Function onLoaded;
  Function onRewarded;

  IronRewardListener.onInit({
    required this.onClose,
    required this.onFailed,
    required this.onLoaded,
    required this.onRewarded,
  });

  @override
  void onRewardedVideoAdClicked(IronSourceRVPlacement placement) {
    // TODO: implement onRewardedVideoAdClicked
  }

  @override
  void onRewardedVideoAdClosed() {
    onClose();
  }

  @override
  void onRewardedVideoAdEnded() {
    // TODO: implement onRewardedVideoAdEnded
  }

  @override
  void onRewardedVideoAdOpened() {}

  @override
  void onRewardedVideoAdRewarded(IronSourceRVPlacement placement) {
    onRewarded();
  }

  @override
  void onRewardedVideoAdShowFailed(IronSourceError error) {
    dog.i(error.message.toString());
    onFailed();
  }

  @override
  void onRewardedVideoAdStarted() {}

  @override
  void onRewardedVideoAvailabilityChanged(bool isAvailable) {

  }
}
