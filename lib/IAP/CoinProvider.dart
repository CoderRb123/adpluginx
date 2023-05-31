import 'package:adpluginx/Authentication/AppAuth.dart';
import 'package:adpluginx/Model/UserModel.dart';
import 'package:flutter/material.dart';

class CoinProvider extends ChangeNotifier {
  int _coins = 0;

  int get coins => _coins;

  set coins(int value) {
    _coins = value;
    notifyListeners();
  }

  refreshCoin() async {
    UserModel? userModel = await AppAuthProvider.getUser();
    if (userModel != null) {
      coins = int.parse(userModel.coins ?? "0");
    }
  }
}
