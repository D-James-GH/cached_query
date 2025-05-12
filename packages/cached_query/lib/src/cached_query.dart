import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:cached_query/src/util/encode_key.dart';
import 'package:meta/meta.dart';

/// Should return true if a condition is met.
///
/// Similar to List.where.
typedef WhereCallback = bool Function(QueryBase query);

/// Used to serialize the query from storage.
typedef Serializer<T> = dynamic Function(T data);

/// Used to deserialize the query from storage.
typedef Deserializer<T> = T Function(dynamic data);

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

  Map<String, Cacheable<dynamic, dynamic>> _queryCache = {};

  StorageInterface? _storage;

  /// Get the current storage interface.
  StorageInterface? get storage => _storage;

  /// The current global config that is set.
  GlobalQueryConfig get defaultConfig => _config;

  /// Whether global configs have been set.
  bool get isConfigSet => _configSet;

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

    assert(() {
      this.observers.add(DevtoolsObserver());
      return true;
    }());
  }

  /// Get a [Query] at a given key.
  QueryBase? getQuery(Object key) {
    final k = encodeKey(key);
    if (_queryCache.containsKey(k)) {
      return _queryCache[k] as QueryBase;
    }
    return null;
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
    List<Cacheable<dynamic, dynamic>> queries = [];
    if (filterFn != null) {
      queries = _filterQueryKey(filter: filterFn).toList();
    } else if (key != null) {
      final query = getQuery(key) as Cacheable<dynamic, dynamic>?;
      if (query != null) {
        queries.add(query);
      }
    }
    for (final query in queries) {
      query.update(updateFn);
    }
  }

  /// Find and return a list of [Query]'s matching a given condition.
  List<QueryBase>? whereQuery(
    WhereCallback findCallback,
  ) {
    final List<QueryBase> result = [];
    for (final query in _queryCache.values) {
      if (findCallback(query as QueryBase)) {
        result.add(query as QueryBase);
      }
    }
    return result.isNotEmpty ? result : null;
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
    List<Cacheable<dynamic, dynamic>> queries = [];

    if (filterFn != null) {
      queries = _filterQueryKey(filter: filterFn).toList();
    } else if (key != null) {
      final k = encodeKey(key);
      if (_queryCache.containsKey(k) && _queryCache[k] != null) {
        queries = [_queryCache[k]!];
      }
    } else {
      // invalidate the whole cache
      queries = _queryCache.values.toList();
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
        _queryCache.remove(query.key);
        if (deleteStorage && storage != null) {
          storage!.delete(query.key);
        }
      }
    } else if (key != null) {
      final stringKey = encodeKey(key);
      if (_queryCache.containsKey(stringKey)) {
        _queryCache.remove(stringKey);
      }
      if (deleteStorage && storage != null) {
        storage!.delete(stringKey);
      }
    } else {
      // other wise invalidate the whole cache
      _queryCache = {};
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
    final List<Cacheable<dynamic, dynamic>> queries = [];

    if (keys == null && filterFn == null) {
      queries.addAll(
        _queryCache.values.where(
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
            final query = _queryCache[k]!;
            if ((refetchActive && query.hasListener) ||
                (refetchInactive && !query.hasListener)) {
              queries.add(query);
            }
          }
        }
      }
    }
    await Future.wait(
      queries.map((q) => ignoreStale ? q.refetch() : q.fetch()),
    );
  }

  /// Add a query to the cache.
  ///
  /// Shouldn't normally need to add a query manually. Queries are automatically
  /// added to the cache when they are constructed.
  void addQuery(QueryBase query) {
    for (final ob in observers) {
      ob.onQueryCreation(query);
    }
    _queryCache[query.key] = query as Cacheable<dynamic, dynamic>;
  }

  Iterable<Cacheable<dynamic, dynamic>> _filterQueryKey({
    required KeyFilterFunc filter,
  }) {
    return _queryCache.values
        .where((element) => filter(element.unencodedKey, element.key));
  }
}
