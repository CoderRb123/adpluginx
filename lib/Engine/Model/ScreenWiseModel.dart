class ScreenWiseModel {
  int? banner;
  int? native;
  bool? localAdFlag;
  List? localClick;
  Map? localFail;
  int? gridCount;
  bool? isNativeEnable;
  bool? overRideReward;
  int? maxFailed;
  bool? overRideTimer;
  int? overRideTimerValue;

  ScreenWiseModel({
    this.banner,
    this.native,
    this.localAdFlag,
    this.gridCount,
    this.isNativeEnable,
    this.overRideReward,
    this.localClick,
    this.localFail,
    this.maxFailed,
    this.overRideTimer,
    this.overRideTimerValue,
  });

  // Local ==> Global ===> Default
  ScreenWiseModel.fromMapLocalAndGlobal(Map localData, Map global) {
    this.banner = localData['banner'] ?? (global['banner'] ?? 0);

    this.native = localData['native'] ?? (global['native'] ?? 0);

    this.localAdFlag =
        localData['localAdFlag'] ?? (global['globalAdFlag'] ?? true);

    this.gridCount =
        localData['localGridCount'] ?? (global['globalGridCount'] ?? 2);

    this.isNativeEnable =
        localData['isNativeEnable'] ?? (global['isNativeEnable'] ?? true);

    this.overRideReward =
        localData['overRideReward'] ?? (global['overRideReward'] ?? true);

    this.localClick =
        localData['localClick'] ?? (global['globalClick'] ?? [0, 1, 2, 3]);

    this.localFail = localData['localFail'] ??
        (global['globalAdFail'] ?? {"0": 1, "1": 2, "2": 3, "3": 0});

    this.overRideTimer =
        localData['overRideTimer'] ?? (global['overRideTimer'] ?? false);
    // Default 20 Seconds
    this.overRideTimerValue =
        localData['overRideTimerValue'] ?? (global['overRideTimerValue'] ?? 20);
    this.maxFailed =
        localData['maxFailed'] ?? (global['maxFailed'] ?? 3);
  }

  ScreenWiseModel.fromGlobalOnly(Map global) {
    this.banner = (global['banner'] ?? 0);

    this.native = (global['native'] ?? 0);

    this.localAdFlag = (global['globalAdFlag'] ?? true);

    this.gridCount = (global['globalGridCount'] ?? 2);

    this.isNativeEnable = (global['isNativeEnable'] ?? true);

    this.overRideReward = (global['overRideReward'] ?? true);

    this.localClick = (global['globalClick'] ?? [0, 1, 2, 3]);

    this.localFail =
    (global['globalAdFail'] ?? {"0": 1, "1": 2, "2": 3, "3": 0});

    this.overRideTimer = (global['overRideTimer'] ?? false);
    // Default 20 Seconds
    this.overRideTimerValue = (global['overRideTimerValue'] ?? 20);
    this.maxFailed = (global['maxFailed'] ?? 4);
  }


  toJson() {
    return {
      "banner": this.banner,
      "native": this.native,
      "localAdFlag": this.localAdFlag,
      "gridCount": this.gridCount,
      "isNativeEnable": this.isNativeEnable,
      "overRideReward": this.overRideReward,
      "localClick": this.localClick,
      "localFail": this.localFail,
      "maxFailed": this.maxFailed,
      "overRideTimer": this.overRideTimer,
      "overRideTimerValue": this.overRideTimerValue,
    };
  }
}
