// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class AppOpenProvider extends ChangeNotifier {
  bool _isAdShowing = false;

  bool get isAdLoading => _isAdShowing;

  set isAdLoading(bool value) {
    _isAdShowing = value;
    notifyListeners();
  }
}
