// 🌎 Project imports:
import 'package:adpluginx/Model/LoaderConfigration.dart';

class UtilsSingleTone {


  static final UtilsSingleTone _singleton = UtilsSingleTone._internal();

  factory UtilsSingleTone() {
    return _singleton;
  }



  UtilsSingleTone._internal();




  static UtilsSingleTone get singleton => _singleton;

  static set singleton(UtilsSingleTone value) {
  }

  bool _forceTest = false;

  bool get forceTest => _forceTest;

  set forceTest(bool value) {
    _forceTest = value;
  }

  LoaderConfigration _loaderConfigration = const LoaderConfigration();

  LoaderConfigration get loaderConfigration => _loaderConfigration;

  set loaderConfigration(LoaderConfigration value) {
    _loaderConfigration = value;
  }

}
