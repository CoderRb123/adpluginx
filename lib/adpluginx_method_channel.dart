// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// 🌎 Project imports:
import 'adpluginx_platform_interface.dart';

/// An implementation of [AdpluginxPlatform] that uses method channels.
class MethodChannelAdpluginx extends AdpluginxPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('adpluginx');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
