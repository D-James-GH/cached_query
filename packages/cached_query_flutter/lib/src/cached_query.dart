import 'dart:io';
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_query/cached_query.dart' as dartQuery;

/// Override the dart specific initialize function with a flutter specific one.
class CachedQuery {
  static void initialize({
    Duration? cacheDuration,
    Duration? refetchDuration,
    dartQuery.StorageInterface? storage,
    bool refetchOnResume = true,
  }) {
    dartQuery.CachedQuery.initialize(
      refetchDuration: refetchDuration,
      cacheDuration: cacheDuration,
      storage: storage,
    );
    if (refetchOnResume) {
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

  bool hasConnection = false;

  final Connectivity _connectivity = Connectivity();

  static final _RetryOnConnect instance = _RetryOnConnect._();

  _RetryOnConnect._();

  void initialize() {
    _connectivity.onConnectivityChanged.listen((_) => checkConnection());
    checkConnection();
  }

  Stream<bool> get stream => connectionChangeController.stream;

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    final bool previousConnection = hasConnection;

    try {
      final future = InternetAddress.lookup('example.com')
        ..timeout(Duration(seconds: 5));
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
  final queries = dartQuery.whereQuery((query) => query.hasListener);
  if (queries != null) {
    for (final query in queries) {
      query.refetch();
    }
  }
  // Check if any infinite queries have listeners and refetch.
  final infiniteQueries =
      dartQuery.whereInfiniteQuery((query) => query.hasListener);
  if (infiniteQueries != null) {
    for (final i in infiniteQueries) {
      i.refetch();
    }
  }
}

/// If the app comes back into the foreground refetch any queries that have listeners.
void _refetchOnResume() {
  WidgetsBinding.instance?.addObserver(_LifecycleObserver());
}
