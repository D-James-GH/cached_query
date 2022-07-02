import 'dart:async';

import 'package:cached_query_flutter/cached_query_flutter.dart';
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

  final Connectivity _connectivity;
  final ConnectivityService _connectivityService;
  final void Function() _refetchCurrentQueries;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  ConnectivityController._({
    Connectivity? connectivity,
    void Function()? refetchCurrentQueries,
    ConnectivityService? service,
    bool? initialConnection,
  })  : _connectivity = connectivity ?? Connectivity(),
        hasConnection = initialConnection ?? true,
        _refetchCurrentQueries =
            refetchCurrentQueries ?? CachedQuery.instance.refetchCurrentQueries,
        _connectivityService = service ?? ConnectivityService();

  /// Allow the creation of new instances for testing purposes
  @visibleForTesting
  factory ConnectivityController.asNewInstance({
    Connectivity? connectivity,
    void Function()? refetchCurrentQueries,
    ConnectivityService? service,
    bool? initialConnection,
  }) {
    return ConnectivityController._(
      initialConnection: initialConnection,
      connectivity: connectivity,
      refetchCurrentQueries: refetchCurrentQueries,
      service: service,
    );
  }

  /// Stream the current connectivity state
  Stream<bool> get stream => connectionChangeController.stream;

  /// Initialise the connectivity stream and check connection.
  Future<void> initialize() async {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) {
      checkConnection();
    });
    await checkConnection();
  }

  // stream current connection state

  /// The test to actually see if there is a connection
  Future<bool> checkConnection() async {
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
        _refetchCurrentQueries();
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
