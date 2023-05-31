import 'package:adpluginx/Subsciption/Banners/NoSubBanner.dart';
import 'package:adpluginx/adpluginx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'Banners/LastDayOffer.dart';

class InAppAd extends HookWidget {
  final String inAppRoute;
  final Image saleAsset;

  const InAppAd({
    Key? key,
    required this.inAppRoute,
    required this.saleAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iapProvider = context.watch<IapProvider>();
    final adBase = context.watch<AdBase>();

    return adBase.data![PackageInfoX().version]['showSubscriptions']
        ? iapProvider.isSubscribed
            ? LastDayOffer(
                saleAsset: saleAsset,
              )
            : NoSubBanner(
                inAppRoute: inAppRoute,
              )
        : SizedBox();
  }
}
