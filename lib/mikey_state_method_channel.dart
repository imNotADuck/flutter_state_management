import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mikey_state_platform_interface.dart';

/// An implementation of [MikeyStatePlatform] that uses method channels.
class MethodChannelMikeyState extends MikeyStatePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mikey_state');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
