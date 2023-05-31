// 📦 Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pmvvm/pmvvm.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/AdBase.dart';

class GoogleBannerViewModel extends ViewModel {
  final myBanner = Observable<BannerAd?>.initialized(null, 'myBanner');
  final isLoading = Observable<bool>.initialized(true, 'isLoading');
  final isFailed = Observable<bool>.initialized(true, 'isFailed');
  final adWidget = Observable<AdWidget?>.initialized(null, 'adWidget');

  @override
  void init() {
    observe([myBanner, isLoading, isFailed, adWidget]);
    myBanner.setValue(
      BannerAd(
        adUnitId: context.read<AdBase>().data!['adIds']['google']['banner'],
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isLoading.setValue(false, action: "action");
            isFailed.setValue(false, action: "action");
          },
          onAdFailedToLoad: (ad, error) {
            isLoading.setValue(false, action: "action");
            isFailed.setValue(true, action: "action");
          },
        ),
      ),
      action: "action",
    );
    myBanner.value!.load();
    adWidget.setValue(AdWidget(ad: myBanner.value!), action: "action");
  }
}
