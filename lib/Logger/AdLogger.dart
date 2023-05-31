import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dog/dog.dart';

import '../Utils/DeviceInformation/PackageInfoX.dart';
import '../Utils/UrlConst.dart';

class AdLogger {
  static logAd({
    String action = "default",
    String provider = "default",
    String status = "default",
  }) async {
    try {
      Response countryData = await Dio().get("http://ip-api.com/json");
      Response response = await Dio().post(baseUrl + addLog, data: {
        "phoneId": PackageInfoX().phoneId,
        "countryData": countryData.data['country'],
        "action": action,
        "networkData": json.encode(countryData.data),
        "provider": provider,
        "status": status,
        "appPackage": PackageInfoX().packageName,
        "appVersion": PackageInfoX().version,
      });
    } on DioError catch (error) {
      dog.i(error.response!.data,
          title: "Error Record Purchase", tag: "InAppPurchase");
    } catch (err) {
      dog.i(err.toString(),
          title: "Error Record Purchase", tag: "InAppPurchase");
    }
  }
}
