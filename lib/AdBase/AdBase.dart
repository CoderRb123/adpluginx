// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class AdBase extends ChangeNotifier {
  Map? _data;

  Map? get data => _data;

  set data(Map? value) {
    _data = value;
    notifyListeners();
  }

  bool _forceTest = false;

  bool get forceTest => _forceTest;

  set forceTest(bool value) {
    _forceTest = value;
    notifyListeners();
  }
}
