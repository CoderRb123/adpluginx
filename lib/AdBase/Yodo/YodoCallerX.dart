// import 'package:adpluginx/AdBase/AdBase.dart';
// import 'package:adpluginx/Utils/NavigationService.dart';
// import 'package:dog/dog.dart';
// import 'package:provider/provider.dart';
// import 'package:yodo1mas/testmasfluttersdktwo.dart';
//
// class YodoCallerX {
//   static final YodoCallerX _singleton = YodoCallerX._internal();
//
//   factory YodoCallerX() {
//     return _singleton;
//   }
//
//   YodoCallerX._internal();
//
//   static initYodo() {
//     AdBase adBase =
//         NavigationService.navigatorKey.currentContext!.read<AdBase>();
//     Yodo1MAS.instance.init(
//       adBase.data!['adIds']['yodo']['appId'],
//       true,
//       (successful) {
//         dog.i(successful);
//       },
//     );
//   }
// }
