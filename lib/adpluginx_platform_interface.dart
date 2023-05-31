// 📦 Package imports:
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// 🌎 Project imports:
import 'adpluginx_method_channel.dart';

abstract class AdpluginxPlatform extends PlatformInterface {
  /// Constructs a AdpluginxPlatform.
  AdpluginxPlatform() : super(token: _token);

  static final Object _token = Object();

  static AdpluginxPlatform _instance = MethodChannelAdpluginx();

  /// The default instance of [AdpluginxPlatform] to use.
  ///
  /// Defaults to [MethodChannelAdpluginx].
  static AdpluginxPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AdpluginxPlatform] when
  /// they register themselves.
  static set instance(AdpluginxPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
