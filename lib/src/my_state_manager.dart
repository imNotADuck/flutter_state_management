import 'dart:developer';

import 'package:flutter/foundation.dart';

/// State Manager using ChangeNotifier
class MyStateManager extends ChangeNotifier {
  final Map<String, dynamic> _state = {};
  final Map<String, dynamic> _defaultState = {};

  MyStateManager(Map<String, dynamic> initialState) {
    _state.addAll(initialState);
    _defaultState.addAll(initialState);
  }

  /// Get a state variable by key.
  T get<T>(String key) {
    if (!_state.containsKey(key)) {
      throw FlutterError('Key "$key" does not exist in the state.');
    }
    return _state[key] as T;
  }

  /// Update a state variable by key. Synchronously
  void set<T>(String key, T value) {
    final stopwatch = Stopwatch()..start();
    if (_state[key] == value) return; // Prevent unncessary updates
    _state[key] = value;
    notifyListeners();
    stopwatch.stop();
    log('Synchronous update for "$key" took ${stopwatch.elapsedMilliseconds} ms');
  }

  /// Asynchronous state update
  Future<void> setAsync<T>(String key, Future<T> valueFuture) async {
    final stopwatch = Stopwatch()..start();
    final value = await valueFuture;
    if (_state[key] == value) return; // Prevent unnecessary updates
    _state[key] = value;
    notifyListeners();
    stopwatch.stop();
    log('Asynchronous update for "$key" took ${stopwatch.elapsedMilliseconds} ms');
  }

  /// Reset a specific state variable to its default value.
  void reset(String key) {
    if (!_defaultState.containsKey(key)) {
      throw FlutterError('Key "$key" does not exist in the default state');
    }
    _state[key] = _defaultState[key];
    notifyListeners();
  }

  /// Reset all state variables to their default values.
  void resetAll() {
    _state.clear();
    _state.addAll(_defaultState);
    notifyListeners();
  }

  /// Listen to a specific key for changes (for selective updates).
  ValueListenable<T> listen<T>(String key) {
    if (!_state.containsKey(key)) {
      throw FlutterError('Key "$key" does not exist in the state.');
    }
    return _StateValueNotifier<T>(this, key);
  }

  @override
  void dispose() {
    _state.clear();
    _defaultState.clear();
    super.dispose();
  }
}

class _StateValueNotifier<T> extends ValueNotifier<T> {
  final MyStateManager manager;
  final String key;

  _StateValueNotifier(this.manager, this.key) : super(manager.get<T>(key));

  @override
  void dispose() {
    super.dispose();
  }
}
