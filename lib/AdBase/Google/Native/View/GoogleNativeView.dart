// 🐦 Flutter imports:
import 'package:adpluginx/adpluginx.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 📦 Package imports:
import 'package:pmvvm/pmvvm.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/Google/Native/ViewModel/GoogleNativeViewModel.dart';

class GoogleNativeView extends HookWidget {
  final Color backgroundColor;

  const GoogleNativeView({
    Key? key,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myNative = useState<NativeAd?>(null);
    final isLoading = useState<bool>(true);
    final isFailed = useState<bool>(true);
    final adWidget = useState<AdWidget?>(null);
    initNative() {
      myNative.value = NativeAd(
        adUnitId: context.read<AdBase>().data!['adIds']['google']['native'],
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            isLoading.value = false;
            isFailed.value = false;
          },
          onAdFailedToLoad: (ad, error) {
            isLoading.value = false;
            isFailed.value = true;
          },
        ),
        factoryId: 'adFactoryExample',
      );
      myNative.value!.load();
      adWidget.value = AdWidget(ad: myNative.value!);
    }

    useEffect(() {
      initNative();
      return () {};
    }, []);
    return isFailed.value
        ? const SizedBox(
            height: 0,
            width: 0,
          )
        : isLoading.value
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : Container(
                margin: const EdgeInsets.all(10.0),
                constraints: const BoxConstraints(
                  minHeight: 270,
                  maxHeight: 320
                ),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(10.0),
                  // color: const Color(0xFF343434),
                  color: backgroundColor,
                ),
                alignment: Alignment.center,
                width: double.infinity,
                child: adWidget.value!,
              );
  }
}
