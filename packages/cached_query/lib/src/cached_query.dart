import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:cached_query/src/connection_controller.dart';
import 'package:cached_query/src/query/_query.dart';
import 'package:cached_query/src/resume_controller.dart';
import 'package:cached_query/src/util/encode_key.dart';
import 'package:meta/meta.dart';

/// Should return true if a condition is met.
///
/// Similar to List.where.
typedef WhereCallback = bool Function(Cacheable<dynamic> query);

/// Used to serialize the query from storage.
typedef Serializer<T> = dynamic Function(T data);

/// Used to deserialize the query from storage.
typedef Deserializer<T> = T Function(dynamic json);

/// Used to match multiple queries.
typedef KeyFilterFunc = bool Function(Object unencodedKey, String key);

/// Update function used to update the data in a query.
///
/// Must return the new data.
typedef UpdateFunc<T> = T Function(T? oldData);

///[CachedQuery] is a singleton that keeps track of all the cached queries
class CachedQuery {
  /// Get the singleton instance of [CachedQuery].
  static final instance = CachedQuery._();

  /// The current query observer.
  List<QueryObserver> observers = [];

  bool _configSet = false;

  GlobalQueryConfig _config = GlobalQueryConfig();

  final QueryCache _queryCache = QueryCache();

  StorageInterface? _storage;

  /// Get the current storage interface.
  StorageInterface? get storage => _storage;

  /// The current global config that is set.
  GlobalQueryConfig get defaultConfig => _config;

  /// Whether global configs have been set.
  bool get isConfigSet => _configSet;
  ResumeController? _resumeController;
  ConnectionController? _connectionController;

  // This class should not be instantiated manually.
  CachedQuery._();

  /// Allow the creation of new instances
  factory CachedQuery.asNewInstance() {
    return CachedQuery._();
  }

  /// Reset the singleton back to default settings.
  @visibleForTesting
  void reset() {
    _configSet = false;
    _config = GlobalQueryConfig();
    deleteCache();
  }

  /// {@template cachedQuery.config}
  /// Set the global default config which all queries will use.
  ///
  /// Use [cacheDuration] to specify how long a query that has zero listeners
  /// stays in memory. Defaults to 5 minutes.
  ///
  /// Use [refetchDuration] to specify how long before the query is re-fetched
  /// in the background. Defaults to 4 seconds
  ///
  /// Pass a [StorageInterface] to automatically store queries for fast initial
  /// fetches.
  ///
  /// [shouldRethrow] tells cached query whether it should rethrow any error
  /// caught in the query. This is useful if you use try catches in your app for
  /// error handling/logout. By default a query will catch all errors and exceptions
  /// and update the state.
  /// {@endtemplate}
  void config({
    StorageInterface? storage,
    GlobalQueryConfig? config,
    List<QueryObserver>? observers,
    Stream<AppState>? lifecycleStream,
    Stream<ConnectionStatus>? connectionStream,
  }) {
    assert(_configSet == false, "Config defaults must only be set once.");
    if (_configSet) return;

    if (config != null) {
      _config = config;
    }
    _storage = storage;
    _configSet = true;
    if (observers != null) {
      this.observers = observers;
    }
    if (lifecycleStream != null) {
      _resumeController = ResumeController(
        cache: this,
        lifecycleStream: lifecycleStream,
      );
    }
    if (connectionStream != null) {
      _connectionController =
          ConnectionController(cache: this, connectionStream: connectionStream);
    }

    assert(() {
      this.observers.add(DevtoolsObserver());
      return true;
    }());
  }

  /// Get a [Query] at a given key.
  QueryType? getQuery<QueryType extends Cacheable<dynamic>>(Object key) {
    final k = encodeKey(key);
    return _queryCache.get<QueryType>(k);
  }

  /// Update the data of an [Query] at a given key.
  ///
  /// Optionally use the [filterFn] to update multiple queries at once.
  void updateQuery({
    Object? key,
    KeyFilterFunc? filterFn,
    required UpdateFunc<dynamic> updateFn,
  }) {
    assert(
      key != null || filterFn != null,
      "key or filterFn must not be null",
    );
    List<Cacheable<Object?>> queries = [];
    if (filterFn != null) {
      queries = _filterQueryKey(filter: filterFn).toList();
    } else if (key != null) {
      final query = _queryCache.get(encodeKey(key));
      if (query != null) {
        queries.add(query);
      }
    }

    for (final query in queries) {
      switch (query) {
        case Query():
          final currentData = query.state.data;
          query.setData(updateFn(currentData));
        case InfiniteQuery():
          final currentData = query.state.data;
          query.setData(updateFn(currentData) as InfiniteQueryData);
      }
    }
  }

  /// Set the data of an [Query] at a given key.
  ///
  /// If the query does not exist, a new empty query is created.
  ///
  void setQueryData<T>({
    required Object key,
    required T data,
  }) {
    final query = getQuery<Cacheable<T>>(key);
    switch (query) {
      case InfiniteQuery(:final setData):
        assert(
          data is InfiniteQueryData,
          "Data must be of type InfiniteQueryData for InfiniteQuery. Data is of type ${data.runtimeType}. And the query key found the query of type InfiniteQuery.",
        );
        setData(data as InfiniteQueryData);
      case Query(:final setData):
        setData(data);
      case null:
        createEmptyQuery<T>(key: key, cache: this).setData(data);
    }
  }

  /// Find and return a list of [Query]'s matching a given condition.
  Iterable<Cacheable<Object?>> whereQuery(
    WhereCallback findCallback,
  ) {
    return _queryCache.where((cacheable) => findCallback(cacheable));
  }

  /// Invalidate cache currently stored.
  ///
  /// Pass a key to invalidate a query at the given key. Will invalidate both
  /// infinite queries and queries.
  ///
  /// Pass [refetchActive] (defaults to true) to refetch active queries.
  ///
  /// Pass [refetchInactive] (defaults to false) to refetch inactive queries.
  ///
  /// Pass a [filterFn] to find queries to invalidate.
  ///
  /// Cannot pass both a key and a filterFn.
  Future<void> invalidateCache({
    Object? key,
    KeyFilterFunc? filterFn,
    bool refetchActive = true,
    bool refetchInactive = false,
  }) {
    assert(
      key == null || filterFn == null,
      "Cannot pass both key and filterFn",
    );
    late Iterable<Cacheable<dynamic>> queries;

    if (filterFn != null) {
      queries = _filterQueryKey(filter: filterFn).toList();
    } else if (key != null) {
      final k = encodeKey(key);
      if (_queryCache.containsKey(k)) {
        queries = [_queryCache.get(k)!];
      }
    } else {
      // invalidate the whole cache
      queries = _queryCache.getAll();
    }

    return Future.wait(
      queries.map(
        (q) => q.invalidate(
          refetchActive: refetchActive,
          refetchInactive: refetchInactive,
        ),
      ),
    );
  }

  /// Delete cache currently stored.
  ///
  /// Pass a key to delete a query at the given key. Will invalidate both
  /// infinite queries and queries.
  void deleteCache({
    Object? key,
    bool deleteStorage = false,
    KeyFilterFunc? filterFn,
  }) {
    for (final ob in observers) {
      ob.onQueryDeletion(key);
    }
    if (filterFn != null) {
      final queries = _filterQueryKey(filter: filterFn).toList();
      for (final query in queries) {
        _queryCache.removeByKey(query.key);
        if (deleteStorage && storage != null) {
          storage!.delete(query.key);
        }
      }
    } else if (key != null) {
      final stringKey = encodeKey(key);
      if (_queryCache.containsKey(stringKey)) {
        _queryCache.removeByKey(stringKey);
      }
      if (deleteStorage && storage != null) {
        storage!.delete(stringKey);
      }
    } else {
      // other wise invalidate the whole cache
      _queryCache.removeAll();
      if (deleteStorage && storage != null) {
        storage!.deleteAll();
      }
    }
  }

  /// Refetch multiple queries.
  ///
  /// Pass a List of keys to refetch specific queries.
  /// Pass a [filterFn] to "fuzzy" match queries to refetch.
  ///
  /// If [ignoreStale] is true (default) then the query fetch new data regardless of
  /// whether the query is stale or not. If it is false then the query will only
  /// fetch if it is stale.
  Future<void> refetchQueries({
    KeyFilterFunc? filterFn,
    List<Object>? keys,
    bool refetchActive = true,
    bool refetchInactive = true,
    bool ignoreStale = true,
  }) async {
    final List<Cacheable<dynamic>> queries = [];

    if (keys == null && filterFn == null) {
      queries.addAll(
        _queryCache.where(
          (q) =>
              (refetchActive && q.hasListener) ||
              (refetchInactive && !q.hasListener),
        ),
      );
    } else {
      if (filterFn != null) {
        queries.addAll(
          _filterQueryKey(filter: filterFn).where((q) {
            return (refetchActive && q.hasListener) ||
                (refetchInactive && !q.hasListener);
          }),
        );
      }

      if (keys != null) {
        for (final key in keys) {
          final k = encodeKey(key);
          if (_queryCache.containsKey(k)) {
            final query = _queryCache.get(k)!;
            if ((refetchActive && query.hasListener) ||
                (refetchInactive && !query.hasListener)) {
              queries.add(query);
            }
          }
        }
      }
    }

    await Future.wait(
      queries.where((q) => ignoreStale || q.stale).map((q) => q.refetch()),
    );
  }

  /// Add a query to the cache.
  ///
  /// Shouldn't normally need to add a query manually. Queries are automatically
  /// added to the cache when they are constructed.
  void addQuery(Cacheable<dynamic> query) {
    if (!_queryCache.containsKey(query.key)) {
      for (final ob in observers) {
        ob.onQueryCreation(query);
      }
    }
    _queryCache.add(query);
  }

  Iterable<Cacheable<Object?>> _filterQueryKey({
    required KeyFilterFunc filter,
  }) {
    return _queryCache
        .where((element) => filter(element.unencodedKey, element.key));
  }

  final List<FutureOr<void> Function()> _disposeListeners = [];

  /// Add a listener that is called when this cache is disposed.
  void addDisposeListener(FutureOr<void> Function() listener) {
    _disposeListeners.add(listener);
  }

  /// Remove a dispose listener.
  void removeDisposeListener(FutureOr<void> Function() listener) {
    _disposeListeners.remove(listener);
  }

  /// Dispose all queries and clear the cache.
  /// Not recommended to call this manually. Unless you are removing the entire
  /// cache from memory.
  Future<void> dispose() async {
    await Future.wait(
      _disposeListeners.map((l) {
        return Future.value(l());
      }),
    );
    await Future.wait(
      _queryCache.map((q) => q.dispose()),
    );
    await _resumeController?.dispose();
    await _connectionController?.dispose();
    _queryCache.removeAll();
  }
}
