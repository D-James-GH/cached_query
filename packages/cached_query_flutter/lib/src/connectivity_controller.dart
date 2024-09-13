import 'dart:async';

import 'package:cached_query_flutter/src/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Connectivity manager.
class ConnectivityController {
  /// Instance of the retry controller.
  static final ConnectivityController instance = ConnectivityController._();

  /// Stream controller fo the connectivity state
  StreamController<bool> connectionChangeController =
      StreamController<bool>.broadcast();

  /// Whether the device is connected.
  bool hasConnection;

  /// Whether the instance has been initialized.
  bool hasInitialized = false;

  final _listeners = <void Function()>[];
  final Connectivity _connectivity;
  final ConnectivityService _connectivityService;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectivityController._({
    Connectivity? connectivity,
    ConnectivityService? service,
    bool? initialConnection,
  })  : _connectivity = connectivity ?? Connectivity(),
        hasConnection = initialConnection ?? true,
        _connectivityService = service ?? ConnectivityService() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) {
      checkConnection();
    });
    checkConnection();
  }

  /// Allow the creation of new instances for testing purposes
  @visibleForTesting
  factory ConnectivityController.asNewInstance({
    Connectivity? connectivity,
    ConnectivityService? service,
    bool? initialConnection,
  }) {
    return ConnectivityController._(
      initialConnection: initialConnection,
      connectivity: connectivity,
      service: service,
    );
  }

  Future<bool>? _connectionFuture;

  /// Stream the current connectivity state
  Stream<bool> get stream => connectionChangeController.stream;

  /// Listeners are called when connection is gained from an inactive state.
  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  /// Remove a listener.
  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  // stream current connection state

  /// The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    try {
      _connectionFuture ??= _testConnection();
      return await _connectionFuture!;
    } catch (_) {
      return false;
    } finally {
      _connectionFuture = null;
    }
  }

  Future<bool> _testConnection() async {
    final bool previousConnection = hasConnection;

    try {
      final result = await _connectivityService.lookup();
      hasConnection = result;
    } catch (_) {
      hasConnection = false;
    }

    // The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
      // The connection has come online, refetch all current queries
      if (hasConnection) {
        for (final listener in _listeners) {
          listener();
        }
      }
    }

    return hasConnection;
  }

  /// Close the streams
  void dispose() {
    connectionChangeController.close();
    _connectivitySubscription?.cancel();
  }
}
