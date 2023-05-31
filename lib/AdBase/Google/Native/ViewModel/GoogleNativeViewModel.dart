// // 📦 Package imports:
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:pmvvm/pmvvm.dart';
//
// // 🌎 Project imports:
// import 'package:adpluginx/AdBase/AdBase.dart';
//
// class GoogleNativeViewModel extends ViewModel {
//   final myNative = Observable<NativeAd?>.initialized(null, 'myNative');
//   final isLoading = Observable<bool>.initialized(true, 'isLoading');
//   final isFailed = Observable<bool>.initialized(true, 'isFailed');
//   final adWidget = Observable<AdWidget?>.initialized(null, 'adWidget');
//
//   @override
//   void init() {
//     observe([myNative, isLoading, isFailed, adWidget]);
//     myNative.setValue(
//       NativeAd(
//         adUnitId: context.read<AdBase>().data!['adIds']['google']['native'],
//         request: const AdRequest(),
//         listener: NativeAdListener(
//           onAdLoaded: (ad) {
//             isLoading.setValue(false, action: "action");
//             isFailed.setValue(false, action: "action");
//           },
//           onAdFailedToLoad: (ad, error) {
//             isLoading.setValue(false, action: "action");
//             isFailed.setValue(true, action: "action");
//           },
//         ),
//         factoryId: 'adFactoryExample',
//       ),
//       action: "action",
//     );
//     myNative.value!.load();
//     adWidget.setValue(AdWidget(ad: myNative.value!), action: "action");
//   }
// }
