import 'package:flutter/material.dart';
import 'package:mikey_state/src/my_state_manager.dart';

/// InheritedWidget to provide the state to the widget tree
class MyStateProvider extends InheritedNotifier<MyStateManager> {
  const MyStateProvider({
    super.key,
    required MyStateManager stateManager,
    required super.child,
  }) : super(notifier: stateManager);

  static MyStateManager of(BuildContext context) {
    final MyStateProvider? provider =
        context.dependOnInheritedWidgetOfExactType<MyStateProvider>();
    if (provider == null) {
      throw FlutterError('MyStateProvider not found in widget tree');
    }
    return provider.notifier!;
  }
}
