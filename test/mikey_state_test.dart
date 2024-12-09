import 'package:flutter_test/flutter_test.dart';
import 'package:mikey_state/mikey_state.dart';
import 'package:mikey_state/mikey_state_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMikeyStatePlatform
    with MockPlatformInterfaceMixin
    implements MikeyStatePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  group('MyStateManager - Synchronous Updates', () {
    test('should update state synchronously', () {
      final stateManager = MyStateManager({'counter': 0});

      // Add a listener to verify notifications
      bool notified = false;
      stateManager.addListener(() {
        notified = true;
      });

      // Update state synchronously
      stateManager.set<int>('counter', 1);

      // Verify the state and notification
      expect(stateManager.get<int>('counter'), 1);
      expect(notified, true);
    });
  });

  group('MyStateManager - Asynchronous Updates', () {
    test('should update state asynchronously', () async {
      final stateManager = MyStateManager({'username': 'Guest'});

      // Add a listener to verify notifications
      bool notified = false;
      stateManager.addListener(() {
        notified = true;
      });

      // Simulate an asynchronous state update
      await stateManager.setAsync<String>(
        'username',
        Future.delayed(const Duration(milliseconds: 100), () => 'NewUser'),
      );

      // Verify the state and notification
      expect(stateManager.get<String>('username'), 'NewUser');
      expect(notified, true);
    });
  });

  group('MyStateManager - Heavy State Updates', () {
    test('should handle multiple rapid updates', () {
      final stateManager = MyStateManager({'counter': 0});

      // Add a listener to verify notifications
      int notifyCount = 0;
      stateManager.addListener(() {
        notifyCount++;
      });

      // Perform 1000 updates
      for (int i = 0; i < 1000; i++) {
        stateManager.set<int>('counter', i);
      }

      // Verify the final state and notification count
      expect(stateManager.get<int>('counter'), 999);
      expect(notifyCount, 999);
    });
  });

  group('MyStateManager - Asynchronous Batch Updates', () {
    test('should handle multiple asynchronous updates', () async {
      final stateManager = MyStateManager({'taskCount': 0});

      // Add a listener to verify notifications
      int notifyCount = 0;
      stateManager.addListener(() {
        notifyCount++;
      });

      // Perform multiple asynchronous updates
      await Future.wait([
        stateManager.setAsync<int>(
          'taskCount',
          Future.delayed(const Duration(milliseconds: 50), () => 1),
        ),
        stateManager.setAsync<int>(
          'taskCount',
          Future.delayed(const Duration(milliseconds: 100), () => 2),
        ),
        stateManager.setAsync<int>(
          'taskCount',
          Future.delayed(const Duration(milliseconds: 150), () => 3),
        ),
      ]);

      // Verify the final state and notification count
      expect(stateManager.get<int>('taskCount'), 3);
      expect(notifyCount, 3);
    });
  });
}
