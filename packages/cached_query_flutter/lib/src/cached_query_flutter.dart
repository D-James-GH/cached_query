import 'dart:async';
import 'dart:io';

import 'package:cached_query/cached_query.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'query_config_flutter.dart';

/// Flutter specific extension on [CachedQuery]
extension CachedQueryExt on CachedQuery {
  /// Override the dart specific initialize function with a flutter specific one.
  ///
  /// Set the global default config which all queries will use.
  void configFlutter({
    StorageInterface? storage,
    QueryConfigFlutter config = const QueryConfigFlutter(),
  }) {
    CachedQuery.instance.config(config: config, storage: storage);

    if (config.refetchOnResume) {
      _refetchOnResume();
    }

    _RetryOnConnect.instance.initialize();
  }
}

class _LifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refetchCurrentQueries();
    }
  }
}

class _RetryOnConnect {
  StreamController<bool> connectionChangeController =
      StreamController<bool>.broadcast();

  // Assume the user has got internet connection to start.
  bool hasConnection = true;
  static final _RetryOnConnect instance = _RetryOnConnect._();

  final Connectivity _connectivity = Connectivity();

  Stream<bool> get stream => connectionChangeController.stream;
  _RetryOnConnect._();

  void initialize() {
    _connectivity.onConnectivityChanged.listen((_) => checkConnection());
    checkConnection();
  }

  // stream current connection state

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    final bool previousConnection = hasConnection;

    try {
      final future = InternetAddress.lookup('example.com')
        ..timeout(const Duration(seconds: 5));
      final result = await future;
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
      // The connection has come online, refetch all current queries
      if (hasConnection) {
        _refetchCurrentQueries();
      }
    }

    return hasConnection;
  }

  void dispose() {
    connectionChangeController.close();
  }
}

/// Refetch all queries and infinite queries with listeners.
///
/// A query is considered on screen or active if it has listeners.
void _refetchCurrentQueries() {
  // Check if any queries have listeners and refetch.
  final queries = CachedQuery.instance.whereQuery((query) => query.hasListener);
  if (queries != null) {
    for (final query in queries) {
      query.refetch();
    }
  }
  // Check if any infinite queries have listeners and refetch.
  final infiniteQueries =
      CachedQuery.instance.whereQuery((query) => query.hasListener);
  if (infiniteQueries != null) {
    for (final i in infiniteQueries) {
      i.refetch();
    }
  }
}

/// If the app comes back into the foreground refetch any queries that have listeners.
void _refetchOnResume() {
  WidgetsBinding.instance.addObserver(_LifecycleObserver());
}
