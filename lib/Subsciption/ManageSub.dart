import 'dart:convert';

import 'package:adpluginx/adpluginx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class ManageSub {
  static final ManageSub _singleton = ManageSub._internal();

  factory ManageSub() {
    return _singleton;
  }

  ManageSub._internal();

  SharedPreferences? subPref;

  initSub() async {
    subPref = await SharedPreferences.getInstance();
  }

  setRestored(PurchaseDetails details) {
    print("Restoring Product =============> ${details.productID}");
    Map plan = {
      "ProductId": details.productID,
      "PurchaseId": details.purchaseID,
      "Status": details.status.name,
      "PurchaseDate": details.transactionDate,
    };
    subPref!.setBool(
      "subscription",
      true,
    );
    subPref!.setString(
      "plan",
      json.encode(plan),
    );
    Future.microtask(() {
      IapProvider iapProvider =
          NavigationService.navigatorKey.currentContext!.read<IapProvider>();
      iapProvider.setSub(true);
      iapProvider.setPlan(plan);
    });
  }

  List<PurchaseDetails> sortPurchases(List<PurchaseDetails> purchaseData) {
    List<PurchaseDetails> buffer = List.from(purchaseData);
    buffer.sort((a, b) {
      DateTime aDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(b.transactionDate ?? "0"));
      DateTime bDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(a.transactionDate ?? "0"));
      return aDate.compareTo(bDate);
    });
    return buffer;
  }

  List<PurchaseDetails> validatePurchases(List<PurchaseDetails> purchaseData) {
    List<PurchaseDetails> validatedPurchases = [];
    for (final purchase in purchaseData) {
      bool isValid = validateSubscription(purchase);
      if (isValid) {
        validatedPurchases.add(purchase);
      }
    }
    return validatedPurchases;
  }

  bool validateSubscription(PurchaseDetails purchaseDetails) {
    DateTime currentTime = DateTime.now();
    DateTime purchaseDate = DateTime.fromMillisecondsSinceEpoch(
      int.parse(purchaseDetails.transactionDate ?? "0"),
    );
    return purchaseDate.isBefore(currentTime);
  }

  Duration getRemainSubDuration(String? time, String id) {
    DateTime currentTime = DateTime.now();
    DateTime purchaseDate = DateTime.fromMillisecondsSinceEpoch(
      int.parse(time ?? "0"),
    ).add(
      Duration(
        days: int.tryParse(id.split("_days_")[0]) ?? 0,
      ),
    );
    print(currentTime.toString());
    print(purchaseDate.toString());
    print(currentTime.difference(purchaseDate));
    print(purchaseDate.difference(currentTime));
    return purchaseDate.difference(currentTime);
  }

  List<PurchaseDetails> validPurchasesList() {
    final iapInstance =
        NavigationService.navigatorKey.currentContext!.read<IapProvider>();
    if (iapInstance.purchases.isNotEmpty) {
      return validatePurchases(iapInstance.purchases);
    }
    return [];
  }


  setActiveSub(PurchaseDetails details) async {
    subPref ??= await SharedPreferences.getInstance();
    Map plan = {
      "ProductId": details.productID,
      "PurchaseId": details.purchaseID,
      "Status": details.status.name,
      "PurchaseDate": details.transactionDate,
    };
    subPref!.setBool(
      "activeSubscription",
      true,
    );
    subPref!.setString(
      "activePlan",
      json.encode(plan),
    );
    Future.microtask(() {
      IapProvider iapProvider =
          NavigationService.navigatorKey.currentContext!.read<IapProvider>();
      iapProvider.setSub(true);
      iapProvider.setPlan(plan);
    });
  }

  Future<bool> verifyIt(PurchaseDetails purchaseDetails) async {
    subPref ??= await SharedPreferences.getInstance();
    // bool isSub = subPref!.getBool("activeSubscription") ?? false;
    String plan = subPref!.getString("activePlan") ?? "";
    if (plan.isNotEmpty) {
      Map planJson = json.decode(plan);
      return planJson['PurchaseId'] == purchaseDetails.purchaseID;
    }
    return false;
  }

  checkSub(List<PurchaseDetails> purchaseData) async {
    if (purchaseData.isEmpty) {
      resetSub();
      return;
    }

    /// [Sorted By Date]
    final sortedPurchases = sortPurchases(purchaseData);

    /// [.Now() Before Purchases]

    final activePurchases = validatePurchases(sortedPurchases);
    if (activePurchases.isEmpty) {
      resetSub();
      return;
    }
  }

  List<PurchaseDetails> getActiveSubs(List<PurchaseDetails> purchaseData) {
    if (purchaseData.isEmpty) {
      return [];
    }

    /// [Sorted By Date]
    final sortedPurchases = sortPurchases(purchaseData);

    /// [.Now() Before Purchases]

    final activePurchases = validatePurchases(sortedPurchases);
    if (activePurchases.isEmpty) {
      return [];
    }

    return activePurchases;
  }

  setSub(List<PurchaseDetails> purchaseData) {
    checkSub(purchaseData);
  }

  resetSub() async {
    subPref ??= await SharedPreferences.getInstance();
    subPref!.remove(
      "activeSubscription",
    );
    subPref!.remove(
      "activePlan",
    );
    Future.microtask(() {
      IapProvider iapProvider =
          NavigationService.navigatorKey.currentContext!.read<IapProvider>();
      iapProvider.setSub(false);
      iapProvider.setPlan({});
    });
  }

  Future<bool> isSub() async {
    subPref ??= await SharedPreferences.getInstance();
    return subPref!.getBool("subscription") ?? false;
  }

  Future<Map> getSubDetails() async {
    subPref ??= await SharedPreferences.getInstance();
    return json.decode(subPref!.getString("plan") ?? "{}");
  }
}
