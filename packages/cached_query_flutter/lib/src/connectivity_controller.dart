import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:cached_query_flutter/src/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Connectivity manager.
class ConnectivityController {
  /// Allow the creation of new instances for testing purposes
  @visibleForTesting
  factory ConnectivityController.asNewInstance({
    Connectivity? connectivity,
    ConnectionStatus? initialConnection,
    Future<bool> Function()? lookupFunction,
  }) {
    return ConnectivityController._(
      initialConnection: initialConnection,
      connectivity: connectivity,
      lookupFunction: lookupFunction,
    );
  }

  ConnectivityController._({
    Connectivity? connectivity,
    ConnectionStatus? initialConnection,
    Future<bool> Function()? lookupFunction,
  })  : _connectivity = connectivity ?? Connectivity(),
        _connectionStatus = initialConnection ?? ConnectionStatus.unknown,
        _lookupFunction = lookupFunction ?? lookup {
    _connectionChangeController = StreamController<ConnectionStatus>.broadcast(
      onListen: _onListen,
      sync: true,
    );
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
    checkConnection();
  }

  /// Instance of the connectivity controller
  static final ConnectivityController instance = ConnectivityController._();

  ConnectionStatus _connectionStatus = ConnectionStatus.unknown;

  /// The current connection status
  ConnectionStatus get connectionStatus => _connectionStatus;

  late final StreamController<ConnectionStatus> _connectionChangeController;

  final Connectivity _connectivity;
  final Future<bool> Function() _lookupFunction;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Future<ConnectionStatus>? _connectionFuture;

  /// Stream the current connectivity state
  Stream<ConnectionStatus> get stream => _connectionChangeController.stream;

  /// The test to actually see if there is a connection
  Future<ConnectionStatus> checkConnection() async {
    try {
      _connectionFuture ??= _testConnection();
      return await _connectionFuture!;
    } catch (_) {
      return _connectionStatus;
    } finally {
      _connectionFuture = null;
    }
  }

  Future<ConnectionStatus> _testConnection() async {
    try {
      final result = await _lookupFunction();
      if (result) {
        _setState(ConnectionStatus.connected);
      } else {
        _setState(ConnectionStatus.disconnected);
      }
    } catch (_) {
      _connectionChangeController.add(ConnectionStatus.unknown);
    }

    return _connectionStatus;
  }

  void _setState(ConnectionStatus status) {
    _connectionStatus = status;
    _connectionChangeController.add(_connectionStatus);
  }

  void _onListen() {
    _connectionChangeController.add(_connectionStatus);
  }

  void _handleConnectivityChange(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.vpn) ||
        result.contains(ConnectivityResult.other)) {
      checkConnection();
    } else if (result.contains(ConnectivityResult.none)) {
      _setState(ConnectionStatus.disconnected);
    }
  }

  /// Close the streams
  void dispose() {
    _connectionChangeController.close();
    _connectivitySubscription?.cancel();
  }
}
