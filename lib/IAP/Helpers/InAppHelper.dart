import 'dart:convert';
import 'dart:developer';

import 'package:adpluginx/Utils/UrlConst.dart';
import 'package:adpluginx/adpluginx.dart';
import 'package:dio/dio.dart';
import 'package:dog/dog.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../Model/InAppPurchaseModel.dart';

class InAppHelper {
  static recordPurchase(
      {required String email,
      required String appleIdCode,
      required String itemValue,
      required PurchaseDetails purchaseDetails,
      required Function() onComplete}) async {
    try {
      Response response = await Dio().post(baseUrl + addInAppPurchase, data: {
        "phoneId": PackageInfoX().phoneId,
        "email": email,
        "appleIdCode": appleIdCode,
        "purchaseId": purchaseDetails.purchaseID,
        "productId": purchaseDetails.productID,
        "appPackage": PackageInfoX().packageName,
        "appVersion": PackageInfoX().version,
        "status": purchaseDetails.status.name,
        "itemValue": itemValue,
      });
      onComplete();
    } on DioError catch (error) {
      dog.i(error.response!.data,
          title: "Error Record Purchase", tag: "InAppPurchase");
    } catch (err) {
      dog.i(err.toString(),
          title: "Error Record Purchase", tag: "InAppPurchase");
    }
  }

  static Future<List<InAppPurchaseModel>> getUserPurchases() async {
    try {
      Response response = await Dio().post("$baseUrl$getPurchases", data: {
        "phoneId": PackageInfoX().phoneId,
        "appPackage": PackageInfoX().packageName
      });
      List purchases = response.data!['purchases'] ?? [];
      return purchases.isEmpty
          ? []
          : [...purchases.map((e) => InAppPurchaseModel.fromJson(e))];
    } on DioError catch (error) {
      dog.i("$baseUrl$getPurchases");
      log(json.encode({
        "phoneId": PackageInfoX().phoneId,
        "appPackage": PackageInfoX().packageName
      }));
      dog.i(error.message.toString(),
          title: "Error Fetch User", tag: "In App Purchase");
    } catch (err) {
      dog.i(err.toString(), title: "Error Fetch User", tag: "In App Purchase");
    }
    return [];
  }
}
