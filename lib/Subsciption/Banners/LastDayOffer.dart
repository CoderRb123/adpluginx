import 'dart:convert';

import 'package:adpluginx/adpluginx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';

class LastDayOffer extends HookWidget {
  final Image saleAsset;

  const LastDayOffer({Key? key, required this.saleAsset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final plan = useState<Map?>(null);
    final timeDiff = useState<Duration>(Duration.zero);
    final offers = useState<Map>({});
    final iap = context.watch<IapProvider>();
    final adBase = context.watch<AdBase>();

    useEffect(() {
      Future.microtask(() {
        String planString = ManageSub().subPref!.getString("activePlan") ?? "";
        if (planString.isNotEmpty) {
          plan.value = json.decode(planString);
          timeDiff.value = ManageSub().getRemainSubDuration(
            plan.value!['PurchaseDate'],
            plan.value!['ProductId'],
          );
          if (timeDiff.value.inSeconds < adBase.data!['offerShowTimer']) {
            offers.value =
                iap.getPlanDetails(context, plan.value!['ProductId']);
          }
        }
      });
      return () {};
    }, []);
    return plan.value == null || offers.value.isEmpty
        ? SizedBox()
        : Container(
            margin: const EdgeInsets.all(10.0),
            padding: EdgeInsets.symmetric(
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.amber,
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.2),
                  blurRadius: 5.0,
                  offset: const Offset(0, 0),
                  spreadRadius: 5.0,
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                iap.handlePurchase(
                  offers.value['appStore'] as ProductDetails,
                );
              },
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: 85,
                    height: 80,
                    child: Stack(
                      children: [
                        Center(child: saleAsset),
                        Center(
                          child: Text(
                            offers.value['offer']['per'],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    left: 75.w,
                    right: 0,
                    child: Row(
                      children: [
                        Text(
                          "\$ " + offers.value['offer']['discount'],
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.green,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          "\$ " + offers.value['offer']['price'],
                          style: TextStyle(
                            fontSize: 20.sp,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.red.withOpacity(0.5),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 33.h,
                    left: 75.w,
                    right: 0,
                    child: Text(
                      offers.value['offer']['name'],
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
