import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cached_query_flutter/src/connectivity_controller.dart';
import 'package:flutter/material.dart';

/// The reason the cache is being refetched.
enum RefetchReason {
  /// The cache is being re-fetched because it has gained connection
  connectivity,

  /// The cache is being re-fetched because the device has been brought to the foreground
  resume
}

/// Flutter specific extension on [CachedQuery]
extension CachedQueryExt on CachedQuery {
  /// Initialise [CachedQuery] with flutter specific configs.
  ///
  /// [refetchOnResume] is whether the onscreen query should refetch when the
  /// app comes back into view.
  ///
  /// Use [refetchOnConnection] to re-fetch any query that has a listener when
  /// the connection changes from no connection to connection.
  ///
  /// [neverCheckConnection] never sets up the connection listener and stream. This
  /// cannot be overridden at the query level. If you want queries to not re-fetch
  /// on connection by default but want to override it later use [config].
  ///
  /// Set the global default config which all queries will use.
  void configFlutter({
    bool neverCheckConnection = false,
    StorageInterface? storage,
    QueryConfigFlutter? config,
    List<QueryObserver>? observers,
  }) {
    this.config(
      config: config,
      storage: storage,
      observers: observers,
    );

    _refetchOnResume();

    if (!neverCheckConnection) {
      ConnectivityController.instance.addListener(() {
        refetchCurrentQueries(RefetchReason.connectivity);
      });
    }
  }

  /// Refetch all queries and infinite queries with listeners.
  ///
  /// A query is considered on screen or active if it has listeners. If a reason
  /// is given then the individual query config will be checked and used to determine
  /// if a query should be re-fetched.
  void refetchCurrentQueries([RefetchReason? reason]) {
    // Check if any queries have listeners and refetch.
    final queries = whereQuery((query) => query.hasListener);

    if (queries == null) return;
    for (final query in queries) {
      bool shouldRefetch = false;
      final config = query.config;
      if (reason == null) {
        shouldRefetch = true;
      } else if (reason == RefetchReason.resume) {
        if (config is QueryConfigFlutter) {
          shouldRefetch = config.refetchOnResume ?? _getDefaultOnResume();
        } else {
          shouldRefetch = _getDefaultOnResume();
        }
      } else if (reason == RefetchReason.connectivity) {
        if (config is QueryConfigFlutter) {
          shouldRefetch =
              config.refetchOnConnection ?? _getDefaultOnConnection();
        } else {
          shouldRefetch = _getDefaultOnConnection();
        }
      }

      if (shouldRefetch) {
        query.refetch();
      }
    }
  }

  bool _getDefaultOnResume() {
    final config = defaultConfig;
    if (config is QueryConfigFlutter) {
      return config.refetchOnResume ?? true;
    }
    return true;
  }

  bool _getDefaultOnConnection() {
    final config = defaultConfig;
    if (config is QueryConfigFlutter) {
      return config.refetchOnConnection ?? true;
    }
    return true;
  }

  /// If the app comes back into the foreground refetch any queries that have listeners.
  void _refetchOnResume() {
    WidgetsBinding.instance.addObserver(_LifecycleObserver(this));
  }
}

class _LifecycleObserver extends WidgetsBindingObserver {
  final CachedQuery cache;

  _LifecycleObserver(this.cache);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      cache.refetchCurrentQueries(RefetchReason.resume);
    }
  }
}
