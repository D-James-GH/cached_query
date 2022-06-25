import 'package:cached_query/cached_query.dart';
import 'package:cached_query_flutter/src/connectivity_controller.dart';
import 'package:flutter/material.dart';

/// Flutter specific extension on [CachedQuery]
extension CachedQueryExt on CachedQuery {
  /// Initialise [CachedQuery] with flutter specific configs.
  ///
  /// [refetchOnResume] is whether the onscreen query should refetch when the
  /// app comes back into view.
  ///
  /// Set the global default config which all queries will use.
  void configFlutter({
    bool refetchOnResume = true,
    StorageInterface? storage,
    QueryConfig? config,
  }) {
    this.config(config: config, storage: storage);

    if (refetchOnResume) {
      _refetchOnResume();
    }

    ConnectivityController.instance.initialize();
  }

  /// Refetch all queries and infinite queries with listeners.
  ///
  /// A query is considered on screen or active if it has listeners.
  void refetchCurrentQueries() {
    // Check if any queries have listeners and refetch.
    final queries = whereQuery((query) => query.hasListener);
    if (queries != null) {
      for (final query in queries) {
        query.refetch();
      }
    }
    // Check if any infinite queries have listeners and refetch.
    final infiniteQueries = whereQuery((query) => query.hasListener);
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
}

class _LifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      CachedQuery.instance.refetchCurrentQueries();
    }
  }
}
