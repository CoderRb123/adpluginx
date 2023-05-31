import 'dart:convert';
import 'dart:developer';

import 'package:adpluginx/Model/UserModel.dart';
import 'package:adpluginx/Utils/UrlConst.dart';
import 'package:adpluginx/adpluginx.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:dio/dio.dart';
import 'package:dog/dog.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAuthProvider {
  static Future<bool> getIntroFlag() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("intro") ?? false;
  }

  static setIntoFlag() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("intro", true);
  }

  static setUserToServer(BuildContext context) async {
    try {
      Dio().get("http://ip-api.com/json").then((countryData) async {
        Response response = await Dio().post(baseUrl + addUser, data: {
          "phoneId": PackageInfoX().phoneId,
          "appPackage": PackageInfoX().packageName,
          "country": json.decode(json.encode(countryData.data))['country'],
          "networkData": json.encode(countryData.data),
          "deviceData": json.encode(PackageInfoX().deviceData),
        });
        await setOneSignalId();
        await setAppTrans();
      });
    } on DioError catch (error) {
      dog.e(error.response!.statusMessage,
          title: "Error User Authentication", tag: "UserAuth");
    } catch (err) {
      dog.i(err.toString(),
          title: "Error User Authentication", tag: "UserAuth");
    }
  }

  static setOneSignalId() async {
    bool state =
        await OneSignal.shared.promptUserForPushNotificationPermission();
    String? oneSignalId;
    if (state) {
      OSDeviceState? one = await OneSignal.shared.getDeviceState();
      oneSignalId = one?.userId;
    }
    try {
      Response response = await Dio().post(baseUrl + addUser, data: {
        "phoneId": PackageInfoX().phoneId,
        "appPackage": PackageInfoX().packageName,
        "oneSignalId": oneSignalId,
        "appVersion": PackageInfoX().version,
      });
    } on DioError catch (error) {
      dog.i(error.message.toString(),
          title: "Error Set OneSignal", tag: "UserAuth");
    } catch (err) {
      dog.i(err.toString(), title: "Error Set OneSignal", tag: "UserAuth");
    }
  }

  static setAppleId(
      {required String appleId,
      required String email,
      required Function() onComplete}) async {
    try {
      Response response = await Dio().post(baseUrl + addUser, data: {
        "phoneId": PackageInfoX().phoneId,
        "appPackage": PackageInfoX().packageName,
        "appleIdCode": appleId,
        "appVersion": PackageInfoX().version,
        "email": email,
      });
      onComplete();
    } on DioError catch (error) {
      dog.i(error.message.toString(),
          title: "Error Set AppleId", tag: "UserAuth");
    } catch (err) {
      dog.i(err.toString(), title: "Error Set AppleId", tag: "UserAuth");
    }
  }

  static setVpnCountry() async {
    try {
      Dio().get("http://ip-api.com/json").then((countryData) async {
        Response response = await Dio().post(baseUrl + addUser, data: {
          "phoneId": PackageInfoX().phoneId,
          "appPackage": PackageInfoX().packageName,
          "vpnCountry": json.encode(countryData.data),
          "appVersion": PackageInfoX().version,
        });
      });
    } on DioError catch (error) {
      dog.i(error.message.toString(), title: "Error Set Vpn", tag: "UserAuth");
    } catch (err) {
      dog.i(err.toString(), title: "Error Set Vpn", tag: "UserAuth");
    }
  }

  static setAppTrans() async {
    try {
      TrackingStatus isAllowed =
          await AppTrackingTransparency.requestTrackingAuthorization();
      Response response = await Dio().post(baseUrl + addUser, data: {
        "phoneId": PackageInfoX().phoneId,
        "appPackage": PackageInfoX().packageName,
        "appTrans": isAllowed == TrackingStatus.authorized ? 1 : 0,
        "appVersion": PackageInfoX().version,
      });
    } on DioError catch (error) {
      dog.i(error.message.toString(),
          title: "Error Set AppTrans", tag: "UserAuth");
    } catch (err) {
      dog.i(err.toString(), title: "Error Set AppTrans", tag: "UserAuth");
    }
  }

  static setCoins({
    required int coins,
  }) async {
    try {
      Response response = await Dio().post(baseUrl + addUser, data: {
        "phoneId": PackageInfoX().phoneId,
        "appPackage": PackageInfoX().packageName,
        "coins": coins,
        "appVersion": PackageInfoX().version,
      });
    } on DioError catch (error) {
      dog.i(error.message.toString(),
          title: "Error Set Coins", tag: "UserAuth");
    } catch (err) {
      dog.i(err.toString(), title: "Error Set Coins", tag: "UserAuth");
    }
  }

  static Future<UserModel?> getUser() async {
    String url = baseUrl + getUserUrl;
    try {
      Response response = await Dio().post(url, data: {
        "phoneId": PackageInfoX().phoneId,
        "appPackage": PackageInfoX().packageName!,
      });

      return response.data!['user'] == null
          ? null
          : UserModel.fromJson(response.data!['user']);
    } on DioError catch (error) {
      dog.i(url);
      dog.i({
        "phoneId": PackageInfoX().phoneId,
        "appPackage": PackageInfoX().packageName!,
      });
      dog.i("${error.response!.data}",
          title: "Error Fetch User", tag: "UserAuth");
    } catch (err) {
      dog.i(err.toString(), title: "Error Fetch User", tag: "UserAuth");
    }
    return null;
  }

  static Future<UserModel?> getUserByAppleId(String appleID) async {
    String url = baseUrl + getUserAppleUrl;
    try {
      Response response = await Dio().post(url, data: {
        "phoneId": PackageInfoX().phoneId,
        "appleIdCode": appleID,
        "appPackage": PackageInfoX().packageName!,
      });

      return response.data!['user'] == null
          ? null
          : UserModel.fromJson(response.data!['user']);
    } on DioError catch (error) {
      dog.i(url);
      dog.i({
        "phoneId": PackageInfoX().phoneId,
        "appPackage": PackageInfoX().packageName!,
      });
      dog.i("${error.response!.data}",
          title: "Error Fetch User", tag: "UserAuth");
    } catch (err) {
      dog.i(err.toString(), title: "Error Fetch User", tag: "UserAuth");
    }
    return null;
  }

  static Future<UserModel?> getPrefUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userRaw = preferences.getString("appleUser");
    if (userRaw != null) {
      return UserModel.fromJson(json.decode(userRaw));
    }
    return null;
  }

  static setSkipLogin(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("skipLogin", true);
    await setUserToServer(context);
  }

  static Future<bool> getSkipLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("skipLogin") ?? false;
  }

  static Future<bool> logOutUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove("appleUser");
  }
}
