// 📦 Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dog/dog.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoX {
  static final PackageInfoX _singleton = PackageInfoX._internal();

  factory PackageInfoX() {
    return _singleton;
  }

  PackageInfoX._internal();

  String? appName;
  String? packageName;
  String? version;
  String? buildNumber;
  String? store;
  String? signature;
  String? phoneId;
  Map? deviceData;

  setVersion(String state) {
    version = state;
  }

  init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version ??= packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    signature = packageInfo.buildSignature;
    store = packageInfo.installerStore;
    phoneId = iosInfo.identifierForVendor;
    deviceData = iosInfo.data;
    dog.i(appName);
    dog.i(packageName);
    dog.i(version);
    dog.i(buildNumber);
    dog.i(store);
    dog.i(signature);
    dog.i(phoneId);
    dog.i(deviceData);
  }
}
