import 'package:adpluginx/IAP/CoinProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoinSystemHelper {}

extension CoinHelper on BuildContext {
  int readCoin() {
    return read<CoinProvider>().coins;
  }

  refreshCoin() {
    read<CoinProvider>().refreshCoin();
  }

  int watchCoin() {
    return watch<CoinProvider>().coins;
  }
}
