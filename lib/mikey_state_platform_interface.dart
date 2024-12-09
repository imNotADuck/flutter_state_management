import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mikey_state_method_channel.dart';

abstract class MikeyStatePlatform extends PlatformInterface {
  /// Constructs a MikeyStatePlatform.
  MikeyStatePlatform() : super(token: _token);

  static final Object _token = Object();

  static MikeyStatePlatform _instance = MethodChannelMikeyState();

  /// The default instance of [MikeyStatePlatform] to use.
  ///
  /// Defaults to [MethodChannelMikeyState].
  static MikeyStatePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MikeyStatePlatform] when
  /// they register themselves.
  static set instance(MikeyStatePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
