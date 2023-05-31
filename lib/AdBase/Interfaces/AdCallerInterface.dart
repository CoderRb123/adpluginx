class AdCallerInterface {
  final Function() onClose;

  final Function() onError;

  final Function() onStarted;

  final Function() onLoaded;

  final Function() onFailedToLoad;
  final Function()? onRewardSkip;

  AdCallerInterface({
    required this.onClose,
    required this.onError,
    required this.onStarted,
    required this.onLoaded,
    required this.onFailedToLoad,
    this.onRewardSkip,
  });
}
