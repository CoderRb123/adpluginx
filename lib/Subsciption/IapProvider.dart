import 'dart:async';
import 'dart:io';
import 'package:adpluginx/Authentication/AppAuth.dart';
import 'package:adpluginx/Model/UserModel.dart';
import 'package:adpluginx/adpluginx.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:provider/provider.dart';

class IapProvider extends ChangeNotifier {
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? subscription;
  List<String> notFoundIds = <String>[];
  List<ProductDetails> products = <ProductDetails>[];
  final List<PurchaseDetails> purchases = <PurchaseDetails>[];
  final List<PurchaseDetails> pendings = <PurchaseDetails>[];
  bool isAvailable = false;
  bool purchasePending = false;
  bool loading = true;
  bool purchasing = true;
  bool isSubscribed = false;
  Map planData = {};
  Function()? _deliveryAction;

  Function()? get deliveryAction => _deliveryAction;

  set deliveryAction(Function()? value) {
    _deliveryAction = value;
    notifyListeners();
  }

  Map getPlanDetails(BuildContext context, String id) {
    List subs = context.read<AdBase>().data!['subscription_config'];
    List temp0 = subs.where((element) => element['id'] == id).toList();

    ///[No Server Declaration]
    if (temp0.isEmpty) {
      return {};
    }

    ///[No Offer Declaration]
    if (temp0[0]['offer_id'] == null) {
      return {};
    }

    List temp =
        subs.where((element) => element['id'] == temp0[0]['offer_id']).toList();
    List temp1 = products.where((element) => element.id == id).toList();

    return {
      "product": temp0.isNotEmpty ? temp0[0] : null,
      "offer": temp.isNotEmpty ? temp[0] : null,
      "appStore": temp1.isNotEmpty ? temp1[0] : null,
    };
  }

  List<ProductDetails> getSortedPurchases(BuildContext context) {
    List subs = context.read<AdBase>().data!['subscription_config'];
    subs.sort(
      (a, b) => a['index'].toString().compareTo(b['index'].toString()),
    );
    List<ProductDetails> p = [
      ...subs.map((e) {
        List t = products.where((element) => element.id == e['id']).toList();
        return t.isEmpty ? null : t[0];
      }),
    ];
    return p;
  }

  setSub(bool state) {
    isSubscribed = state;
    notifyListeners();
  }

  setPlan(Map state) {
    planData = state;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        inAppPurchase.purchaseStream;
    subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      listenToPurchaseUpdated(purchaseDetailsList);
      checkSubscription(purchaseDetailsList);
    }, onDone: () {
      subscription?.cancel();
    }, onError: (Object error) {
      print(error);
    });
    await establishConnection(context);
  }

  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  List userPurchaseSortedList = [];

  findLastSubscription() {
    List buffer = List.from(userPurchases.toList());
    buffer.sort((a, b) {
      DateTime aDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(b.transactionDate ?? "0"));
      DateTime bDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(a.transactionDate ?? "0"));
      return aDate.compareTo(bDate);
    });
    userPurchaseSortedList = buffer;
    notifyListeners();
  }

  Future<void> establishConnection(BuildContext context) async {
    final bool isConnected = await inAppPurchase.isAvailable();
    if (isConnected) {
      isAvailable = isConnected;
      products = await getProducts(context);
      inAppPurchase.restorePurchases();
      notifyListeners();
    }
  }

  Future<List<ProductDetails>> getProductDetailsFromAppStore(
      BuildContext context) async {
    List subs = context.read<AdBase>().data!['subscription_config'];
    List<String> productIds = <String>[
      ...subs.map((e) {
        return e['id'];
      })
    ];
    final ProductDetailsResponse productDetailResponse =
        await inAppPurchase.queryProductDetails(productIds.toSet());
    return productDetailResponse.productDetails;
  }

  Future<List<ProductDetails>> getProducts(BuildContext context) async {
    final serverProducts = await getProductDetailsFromAppStore(context);
    return serverProducts;
  }

  Future<void> handlePurchase(ProductDetails productDetails) async {
    UserModel? userModel = await AppAuthProvider.getPrefUser();
    late PurchaseParam purchaseParam;
    Platform.isAndroid
        ? purchaseParam = GooglePlayPurchaseParam(
            productDetails: productDetails,
            applicationUserName: userModel?.appleIdCode,
          )
        : purchaseParam = PurchaseParam(
            productDetails: productDetails,
            applicationUserName: userModel?.appleIdCode,
          );

    switch (productDetails.id) {
      default:
        inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
        break;
    }
  }

  /// [Adding data to List and Success for Product Sub]
  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    purchasePending = false;
    purchases.add(purchaseDetails);
    ManageSub().setActiveSub(purchaseDetails);
    notifyListeners();
  }

  void handleError(IAPError error) {
    // ignore: avoid_print
    print("Error caught: $error");
    purchasePending = false;
    notifyListeners();
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    purchasePending = false;
    notifyListeners();
  }

  void checkSubscription(List<PurchaseDetails> purchaseDetailsList) {
    if (purchaseDetailsList.isNotEmpty) {
      ManageSub().setSub(purchaseDetailsList);
    } else {
      ManageSub().resetSub();
    }
  }

  Set<PurchaseDetails> userPurchases = {};

  Future<void> listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      userPurchases.add(purchaseDetails);

      /// [Handle Any Error]
      if (purchaseDetails.status == PurchaseStatus.error) {
        handleError(purchaseDetails.error!);
        return;
      }

      /// [Handle Pending Loader]
      if (purchaseDetails.status == PurchaseStatus.pending) {
        purchasePending = true;
        pendings.add(purchaseDetails);
        notifyListeners();
        return;
      }

      /// [Handle Success]
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        if (purchaseDetails.pendingCompletePurchase) {
          await inAppPurchase.completePurchase(purchaseDetails);
        }
        await deliverProduct(purchaseDetails);
        return;
      }

      /// [Handle Cancel By User]
      if (purchaseDetails.status == PurchaseStatus.canceled) {
        purchasePending = false;
        await inAppPurchase.completePurchase(purchaseDetails);
        print("Cancel by User==========>");
        notifyListeners();
        return;
      }
      _handleInvalidPurchase(purchaseDetails);
    }
  }
}
