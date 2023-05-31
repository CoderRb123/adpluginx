// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class LoaderProvider extends ChangeNotifier {
  bool _isAdLoading = false;

  bool get isAdLoading => _isAdLoading;

  set isAdLoading(bool value) {
    _isAdLoading = value;
    notifyListeners();
  }
}
