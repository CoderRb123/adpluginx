import 'package:adpluginx/adpluginx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const String quoterSubscriptionId = '180_days_sub';
const String halfQuoterSubscriptionId = '90_days_sub';
const String monthlySubscriptionId = '30_days_sub';
const String weeklySubscriptionId = '7_days_subs';



class InAppStore extends StatefulWidget {
  static const String route = "/InAppStore";

  const InAppStore({Key? key}) : super(key: key);

  @override
  State<InAppStore> createState() => _InAppStoreState();
}

class _InAppStoreState extends State<InAppStore> {
  // bool isSub = false;
  // Map subPlan = {};
  //
  // checkSub() async {
  //   isSub = await ManageSub().isSub();
  //   subPlan = await ManageSub().getSubDetails();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  @override
  void initState() {
    // Future.microtask(() {
    //   checkSub();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IapProvider iapProvider = context.watch<IapProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(
          1.sw,
          0.06.sh,
        ),
        child: Container(
          padding: EdgeInsets.only(
            top: 0.03.sh,
          ),
          height: 1.sh,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topCenter,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  CupertinoIcons.clear,
                  color: Color(0xFF35375A),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  alignment: Alignment.center,
                  child: Text(
                    iapProvider.isSubscribed ? "Subscription Details" : "Store",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color(0xFF35375A),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
              const IconButton(
                icon: Icon(
                  CupertinoIcons.left_chevron,
                  color: Colors.transparent,
                ),
                onPressed: null,
              )
            ],
          ),
        ),
      ),
      body: iapProvider.isSubscribed
          ? iapProvider.planData.isEmpty
              ? const Center(
                  child: Text("No Data or Loading Plans"),
                )
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: Text(
                        "You are Subscribed For",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF35375A),
                          fontWeight: FontWeight.w900,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150.h,
                      width: 150.w,
                      child: Image.asset("assets/sub.png"),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Card(
                        color: Colors.grey.withOpacity(0.1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text(
                                "Your Plan Id",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                iapProvider.planData['ProductId'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ListTile(
                              title: const Text(
                                "You Purchase Id",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                iapProvider.planData['PurchaseId'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ListTile(
                              title: const Text(
                                "Purchase Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat("dd MMM yyyy hh:mm a").format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(
                                        iapProvider.planData['PurchaseDate'] ??
                                            "0"),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ListTile(
                              title: const Text(
                                "Status",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                iapProvider.planData['Status'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
          : iapProvider.purchasePending
              ? SizedBox(
                  width: 100.sw,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(
                        height: 20.h,
                      ),
                      const Text(
                        "Please Wait on this Screen while purchasing",
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            child: Text(
                              "Enjoy Ad Free Experience of our App",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF35375A),
                                fontWeight: FontWeight.w900,
                                fontSize: 20.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 150.h,
                            width: 150.w,
                            child: Image.asset("assets/noAds.png"),
                          ),
                          !iapProvider.loading || iapProvider.products.isEmpty
                              ? SizedBox(
                                  height: 0.6.sh,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        CircularProgressIndicator(),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("Loading Products...")
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    ...iapProvider.getSortedPurchases(context).map(
                                      (e) {
                                        return Card(
                                          elevation: 0,
                                          child: ListTile(
                                            onTap: () {
                                              iapProvider.handlePurchase(e);
                                            },
                                            title: Text(
                                              e.title,
                                              style: const TextStyle(
                                                color: Color(0xFF35375A),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Container(
                                              margin:
                                                  const EdgeInsets.only(top: 5),
                                              child: Text(
                                                e.description,
                                                style: TextStyle(
                                                  color: const Color(0xFF35375A)
                                                      .withOpacity(0.6),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            trailing: TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Colors.orange,
                                              ),
                                              onPressed: null,
                                              child: Text(
                                                e.price,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    SafeArea(
                      child: TextButton(
                        onPressed: () {
                          iapProvider.inAppPurchase.restorePurchases();
                        },
                        child: const Text(
                          "Restore Purchases",
                          style: TextStyle(
                            color: Color(0xFF35375A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
