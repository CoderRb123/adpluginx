import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pmvvm/pmvvm.dart';

class InAppTile extends HookWidget {
  final ProductDetails productDetails;
  final PurchaseDetails? previousPurchase;

  const InAppTile({
    Key? key,
    required this.productDetails,
    required this.previousPurchase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
      child: BlurryContainer(
        width: 1.sw,
        blur: 1,
        elevation: 1,
        color: Colors.white.withOpacity(0.09),
        padding: const EdgeInsets.all(8),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/coin.png",
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              productDetails.title.toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              width: 100.sw,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green[800],
                ),
                onPressed: null,
                child: Text(
                  previousPurchase != null ? "Upgrade" : productDetails.price,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
