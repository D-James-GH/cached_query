import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cached_query_flutter/src/connectivity_controller.dart';
import 'package:cached_query_flutter/src/lifecycle_stream_controller.dart';
import 'package:flutter/foundation.dart';
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
    GlobalQueryConfigFlutter config = const GlobalQueryConfigFlutter(),
    List<QueryObserver>? observers,
    Stream<AppState>? lifecycleStream,
  }) {
    if (lifecycleStream == null) {
      final lifecycleController = LifecycleStreamController(this);
      lifecycleStream = lifecycleController.stream;
      addDisposeListener(() async {
        await lifecycleController.dispose();
      });
    }
    this.config(
      config: config,
      storage: storage,
      observers: observers,
      lifecycleStream: lifecycleStream,
    );

    if (!neverCheckConnection) {
      ConnectivityController.instance.addListener(onConnection);
    }
  }

  /// Streams the connection state. If true then the device is able to access the internet.
  Stream<bool> get connectivityStream => ConnectivityController.instance.stream;

  /// Whether the device has access to the internet.
  bool get hasConnection => ConnectivityController.instance.hasConnection;

  /// Check the current connection state.
  /// Returns true if the device is connected to the internet.
  /// Updates the connection state if it has changed.
  Future<bool> checkConnection() =>
      ConnectivityController.instance.checkConnection();

  /// Refetch all queries and infinite queries with listeners.
  ///
  /// A query is considered on screen or active if it has listeners. If a reason
  /// is given then the individual query config will be checked and used to determine
  /// if a query should be re-fetched.
  @Deprecated(
    "Use invalidateCache instead, this now can refetch active queries. This method will be removed in a future release.",
  )
  Future<void> refetchCurrentQueries([RefetchReason? reason]) async {
    return invalidateCache();
  }

  ///
  @visibleForTesting
  Future<void> onConnection() async {
    final queries = whereQuery((query) {
      if (!query.hasListener) {
        return false;
      }
      final config = switch (query) {
        Query() => query.config,
        InfiniteQuery() => query.config,
      };
      return config.refetchOnConnection;
    }).toList();

    if (queries.isNotEmpty) {
      for (final q in queries) {
        q.fetch();
      }
    }
  }
}
