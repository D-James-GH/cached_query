import 'dart:io';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cached_query_flutter/src/connectivity_controller.dart';
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
    QueryConfigFlutter? config,
    List<QueryObserver>? observers,
  }) {
    this.config(
      config: config,
      storage: storage,
      observers: observers,
    );

    final minBackgroundDuration =
        config?.refetchOnResumeMinBackgroundDuration ??
            QueryConfigFlutter.defaults.refetchOnResumeMinBackgroundDuration;

    _setupRefetchOnResume(minBackgroundDuration);

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

      // Allow normal refetch rules if user has not configured shouldRefetch
      final bool configShouldRefetch =
          query.config.shouldRefetch?.call(query, false) ?? true;

      if (reason == null) {
        shouldRefetch = configShouldRefetch;
      } else if (reason == RefetchReason.resume) {
        if (config is QueryConfigFlutter) {
          shouldRefetch = config.refetchOnResume && configShouldRefetch;
        } else {
          shouldRefetch = QueryConfigFlutter.defaults.refetchOnResume &&
              configShouldRefetch;
        }
      } else if (reason == RefetchReason.connectivity) {
        if (config is QueryConfigFlutter) {
          shouldRefetch = config.refetchOnConnection && configShouldRefetch;
        } else {
          shouldRefetch = QueryConfigFlutter.defaults.refetchOnConnection &&
              configShouldRefetch;
        }
      }

      if (shouldRefetch) {
        query.refetch();
      }
    }
  }

  /// If the app comes back into the foreground refetch any queries that have listeners.
  void _setupRefetchOnResume(Duration minBackgroundDuration) {
    WidgetsBinding.instance
        .addObserver(_LifecycleObserver(this, minBackgroundDuration));
  }
}

class _LifecycleObserver extends WidgetsBindingObserver {
  final CachedQuery cache;
  final Duration minBackgroundDuration;

  _LifecycleObserver(this.cache, this.minBackgroundDuration);

  DateTime? _lastPaused;

  bool shouldNotify() {
    if (_lastPaused == null) {
      if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
        return false;
      }
      // Note: Other platforms might never enter full background mode so we
      // return true to be safe (only if we have no last paused time).
      return true;
    }

    final diff = DateTime.now().difference(_lastPaused!);
    return diff > minBackgroundDuration;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final shouldNotify = this.shouldNotify();
      _lastPaused = null;

      if (shouldNotify) {
        cache.refetchCurrentQueries(RefetchReason.resume);
      }
      return;
    }

    if (state == AppLifecycleState.paused) {
      _lastPaused = DateTime.now();
    }
  }
}
