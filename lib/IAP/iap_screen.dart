import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:adpluginx/Authentication/AppAuth.dart';
import 'package:adpluginx/IAP/CoinSystemHelper.dart';
import 'package:adpluginx/IAP/Helpers/InAppHelper.dart';
import 'package:adpluginx/Model/InAppPurchaseModel.dart';
import 'package:dog/dog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'consumable_store.dart';

const bool _kAutoConsume = true;

class InAppPurchaseScreen extends StatefulWidget {
  final Widget appBarWidget;
  final Function(
          ProductDetails productDetails, PurchaseDetails? previousPurchase)
      onChildRender;
  final Function() onPurchaseCompleted;
  final Function() onAuth;
  final String sortSplitter;
  final String valueSplitter;
  final List<String> productIds;

  const InAppPurchaseScreen({
    super.key,
    required this.appBarWidget,
    required this.onChildRender,
    required this.productIds,
    required this.onPurchaseCompleted,
    required this.onAuth,
    this.sortSplitter = "coin",
    this.valueSplitter = "_coins_",
  });

  @override
  _InAppPurchaseScreenState createState() => _InAppPurchaseScreenState();
}

class _InAppPurchaseScreenState extends State<InAppPurchaseScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  List<InAppPurchaseModel> serverPurchases = [];
  ProductDetails? currentProductDetails;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      _subscription.resume();
    });
    Future.microtask(() async {
      initStoreInfo();
      serverPurchases = await InAppHelper.getUserPurchases();
    });
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(widget.productIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    List<String> consumables = await ConsumableStore.load();

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stack = [];
    if (_queryProductError == null) {
      stack.add(
        _buildProductList(),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError!),
      ));
    }
    if (_purchasePending) {
      stack.add(
        Stack(
          children: const [
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF131316),
      body: Stack(
        children: [
          Positioned(
            top: 30.h,
            left: 0,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4AA181).withOpacity(0.45),
                    spreadRadius: 20.0,
                    offset: const Offset(0, 0),
                    blurRadius: 50.0,
                  )
                ],
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: widget.appBarWidget,
              ),
              Expanded(
                child: Stack(
                  children: stack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    if (_loading) {
      return const Center(
        child: Text(
          'Fetching products...',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
    if (!_isAvailable) {
      return const Center(
        child: Text(
          'No Product Available',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
    List<GridTile> productList = <GridTile>[];
    if (_notFoundIds.isNotEmpty) {
      print(_notFoundIds);
      productList.add(
        const GridTile(
          child: Center(
            child: Text(
              "Product Not Founded",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    Map<String, PurchaseDetails> purchases =
        Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    _products.sort(
      (a, b) {
        return int.parse(a.title.toLowerCase().split(widget.sortSplitter)[0])
            .compareTo(
                int.parse(b.title.toLowerCase().split(widget.sortSplitter)[0]));
      },
    );
    productList.addAll(_products.map(
      (ProductDetails productDetails) {
        PurchaseDetails? previousPurchase = purchases[productDetails.id];
        return GridTile(
          child: InkWell(
            onTap: () async {
              if (previousPurchase != null) {
                confirmPriceChange(context);
                return;
              }
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              String? isLogin = preferences.getString("appleUser");
              if (isLogin == null) {
                widget.onAuth();
                return;
              }
              late PurchaseParam purchaseParam;
              if (Platform.isAndroid) {
                final oldSubscription =
                    _getOldSubscription(productDetails, purchases);

                purchaseParam = GooglePlayPurchaseParam(
                    productDetails: productDetails,
                    applicationUserName: null,
                    changeSubscriptionParam: (oldSubscription != null)
                        ? ChangeSubscriptionParam(
                            oldPurchaseDetails: oldSubscription,
                            prorationMode:
                                ProrationMode.immediateWithTimeProration,
                          )
                        : null);
              } else {
                purchaseParam = PurchaseParam(
                  productDetails: productDetails,
                  applicationUserName: null,
                );
              }

              if (widget.productIds.contains(productDetails.id)) {
                _inAppPurchase.buyConsumable(
                    purchaseParam: purchaseParam,
                    autoConsume: _kAutoConsume || Platform.isIOS);
              } else {
                _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
              }
            },
            child: widget.onChildRender(productDetails, previousPurchase),
          ),
        );
      },
    ));
    return GridView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
      ),
      children: productList,
    );
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails, Map loginDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (widget.productIds.contains(purchaseDetails.productID)) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
        _inAppPurchase.completePurchase(purchaseDetails);
      });
      Map userDetails = loginDetails;
      int itemValue = int.parse(
          purchaseDetails.productID.split(widget.valueSplitter)[0] ?? "0");
      InAppHelper.recordPurchase(
        email: userDetails['email'] ?? "",
        appleIdCode: userDetails['appleIdCode'] ?? "",
        itemValue: itemValue.toString(),
        purchaseDetails: purchaseDetails,
        onComplete: () {
          int coins = context.readCoin();
          AppAuthProvider.setCoins(coins: coins + itemValue);
          context.refreshCoin();
          widget.onPurchaseCompleted();
        },
      );
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _inAppPurchase.completePurchase(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    dog.i("Total Purcahses Made =====>  ${purchaseDetailsList.length}");
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      dog.i("Purchase INfo  ${purchaseDetails.productID}");
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            String? isLogin = preferences.getString("appleUser");
            if (isLogin != null) {
              // if (serverPurchases.every((element) =>
              //     element.purchaseId == purchaseDetails.purchaseID)) {
              //   dog.i("${purchaseDetails.purchaseID} Present in List =====>");
              //   return;
              // }
              deliverProduct(purchaseDetails, json.decode(isLogin));
              return;
            } else {
              widget.onAuth();
            }
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isIOS) {
      var iapStoreKitPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    // This is just to demonstrate a subscription upgrade or downgrade.
    // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
    // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
    // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
    // Please remember to replace the logic of finding the old subscription Id as per your app.
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in iTunesConnect.
    GooglePlayPurchaseDetails? oldSubscription;
    // if (productDetails.id == basePlan180 &&
    //     purchases[_kGoldSubscriptionId] != null) {
    //   oldSubscription =
    //       purchases[_kGoldSubscriptionId] as GooglePlayPurchaseDetails;
    // } else if (productDetails.id == _kGoldSubscriptionId &&
    //     purchases[basePlan180] != null) {
    //   oldSubscription = purchases[basePlan180] as GooglePlayPurchaseDetails;
    // }
    return oldSubscription;
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
