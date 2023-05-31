// import 'package:adpluginx/AdBase/Interfaces/AdCallerInterface.dart';
// import 'package:adpluginx/AdBase/Yodo/YodoCallerX.dart';
// import 'package:adpluginx/Logger/AdLogger.dart';
// import 'package:adpluginx/Methods/BaseClass.dart';
// import 'package:adpluginx/Utils/UrlConst.dart';
// import 'package:yodo1mas/Yodo1MAS.dart';
//
// class YodoFullScreenCallerX {
//   static final YodoFullScreenCallerX _singleton =
//   YodoFullScreenCallerX._internal();
//
//   factory YodoFullScreenCallerX() {
//     return _singleton;
//   }
//
//   YodoFullScreenCallerX._internal();
//
//   void callAds({
//     String action = "default",
//     required AdCallerInterface adCallerInterface,
//   }) async {
//     Yodo1MAS.instance.setInterstitialListener(
//           (event, message) {
//             print("$message=====>");
//         switch (event) {
//           case Yodo1MAS.AD_EVENT_OPENED:
//             print("Yodo AD_EVENT_OPENED ====>");
//             AdLogger.logAd(
//                 action: action, provider: yodoInterAdKey, status: adClickedKey);
//             break;
//           case Yodo1MAS.AD_EVENT_ERROR:
//             print("Yodo AD_EVENT_ERROR ====>");
//             adCallerInterface.onError();
//             AdLogger.logAd(
//                 action: action, provider: yodoInterAdKey, status: adFailedKey);
//             break;
//           case Yodo1MAS.AD_EVENT_CLOSED:
//             print("Yodo AD_EVENT_CLOSED ====>");
//             AdLogger.logAd(
//                 action: action,
//                 provider: yodoInterAdKey,
//                 status: adDismissedKey);
//             adCallerInterface.onClose();
//             break;
//         }
//       },
//     );
//     Future.delayed(const Duration(milliseconds: 500), () async {
//       print(await Yodo1MAS.instance.isInterstitialAdLoaded());
//       Yodo1MAS.instance.showInterstitialAd();
//     });
//   }
// }
