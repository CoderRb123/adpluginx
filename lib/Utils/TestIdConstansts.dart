// Google Ads

// 🎯 Dart imports:
import 'dart:io';

class TestIdsConst {
  final String _googleTestFullScreenID = Platform.isIOS
      ? "ca-app-pub-3940256099942544/4411468910"
      : "ca-app-pub-3940256099942544/1033173712";

  String get googleTestFullScreenID => _googleTestFullScreenID;

  final String _googleTestRewardID = Platform.isIOS
      ? "ca-app-pub-3940256099942544/6978759866"
      : "ca-app-pub-3940256099942544/5224354917";
  final String _googleTestBannerId = Platform.isIOS
      ? "ca-app-pub-3940256099942544/2934735716"
      : "ca-app-pub-3940256099942544/6300978111";
  final String _googleTestNativeId = Platform.isIOS
      ? "ca-app-pub-3940256099942544/3986624511"
      : "ca-app-pub-3940256099942544/2247696110";
  final String _googleAppOpen = Platform.isIOS
      ? "ca-app-pub-3940256099942544/5662855259"
      : "ca-app-pub-3940256099942544/3419835294";

  String get googleTestRewardID => _googleTestRewardID;

  String get googleTestBannerId => _googleTestBannerId;

  String get googleAppOpen => _googleAppOpen;

  String get googleTestNativeId => _googleTestNativeId;
}


