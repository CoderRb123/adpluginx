// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:pmvvm/pmvvm.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/Google/Banner/ViewModel/GoogleBannerViewModel.dart';

class GoogleBannerView extends StatelessWidget {
  const GoogleBannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM<GoogleBannerViewModel>(
      view: () => const _MyView(),
      viewModel: GoogleBannerViewModel(),
    );
  }
}

class _MyView extends StatelessView<GoogleBannerViewModel> {
  const _MyView({Key? key}) : super(key: key, reactive: true);

  @override
  Widget render(context, viewModel) {
    return viewModel.isFailed.value
        ? const SizedBox(
            height: 0,
            width: 0,
          )
        : viewModel.isLoading.value
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : Container(
                alignment: Alignment.center,
                width: viewModel.myBanner.value!.size.width.toDouble(),
                height: viewModel.myBanner.value!.size.height.toDouble(),
                child: viewModel.adWidget.value,
              );
  }
}
