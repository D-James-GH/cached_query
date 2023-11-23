import 'dart:async';
import 'dart:convert';

import 'package:cached_query/cached_query.dart';
import 'package:cached_query/src/util/encode_key.dart';
import 'package:cached_query/src/util/list_extension.dart';
import 'package:cached_query/src/util/page_equality.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'infinite_query.dart';

part 'query.dart';

part "query_base.dart";

/// Should return true if a condition is met.
///
/// Similar to List.where.
typedef WhereCallback = bool Function(QueryBase<dynamic, dynamic>);

/// Used to serialize the query data when fetched from local storage.
typedef Serializer = dynamic Function(dynamic json);

/// Used to match multiple queries.
typedef KeyFilterFunc = bool Function(Object unencodedKey, String key);

/// Update function used to update the data in a query.
///
/// Must return the new data.
typedef UpdateFunc<T> = T? Function(T? oldData);

///[CachedQuery] is a singleton that keeps track of all the cached queries
class CachedQuery {
  /// Get the singleton instance of [CachedQuery].
  static final instance = CachedQuery._();

  /// The current query observer.
  List<QueryObserver> observers = [];

  bool _configSet = false;

  QueryConfig _config = QueryConfig.defaults();

  Map<String, QueryBase<dynamic, dynamic>> _queryCache = {};

  StorageInterface? _storage;

  /// Get the current storage interface.
  StorageInterface? get storage => _storage;

  /// The current global config that is set.
  QueryConfig get defaultConfig => _config;

  /// Whether global configs have been set.
  bool get isConfigSet => _configSet;

  // This class should not be instantiated manually.
  CachedQuery._();

  /// Allow the creation of new instances for testing purposes
  @visibleForTesting
  factory CachedQuery.asNewInstance() {
    return CachedQuery._();
  }

  /// Reset the singleton back to default settings.
  @visibleForTesting
  void reset() {
    _configSet = false;
    _config = QueryConfig.defaults();
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
    QueryConfig? config,
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
  }

  /// Get a [Query] at a given key.
  QueryBase<dynamic, dynamic>? getQuery(Object key) {
    final k = encodeKey(key);
    if (_queryCache.containsKey(k)) {
      return _queryCache[k];
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
    List<QueryBase<dynamic, dynamic>> queries = [];
    if (filterFn != null) {
      queries = _filterQueryKey(filter: filterFn);
    } else if (key != null) {
      final query = getQuery(key);
      if (query != null) {
        queries.add(query);
      }
    }
    for (final query in queries) {
      query.update(updateFn);
    }
  }

  /// Update the data of an [InfiniteQuery] at a given key.
  @Deprecated("Use updateQuery instead.")
  void updateInfiniteQuery<Data>({
    Object? key,
    KeyFilterFunc? filterFn,
    required UpdateFunc<List<Data>> updateFn,
  }) {
    assert(
      key != null || filterFn != null,
      "key or filterFn must not be null",
    );
    List<QueryBase<dynamic, dynamic>> queries = [];

    if (filterFn != null) {
      queries = _filterQueryKey(filter: filterFn);
    } else if (key != null) {
      final query = getQuery(key);
      if (query != null) {
        queries.add(query);
      }
    }

    for (final query in queries) {
      assert(
        query is! Query,
        "InfiniteQuery at key $key is an Query. To update a Query use updateQuery",
      );

      if (query is InfiniteQuery) {
        (query as InfiniteQuery<Data, dynamic>).update(updateFn);
      }
    }
  }

  /// Find and return a list of [Query]'s matching a given condition.
  List<QueryBase<dynamic, dynamic>>? whereQuery(WhereCallback findCallback) {
    final List<QueryBase<dynamic, dynamic>> result = [];
    for (final query in _queryCache.values) {
      if (findCallback(query)) {
        result.add(query);
      }
    }
    return result.isNotEmpty ? result : null;
  }

  /// Invalidate cache currently stored.
  ///
  /// Pass a key to invalidate a query at the given key. Will invalidate both
  /// infinite queries and queries.
  void invalidateCache({
    Object? key,
    KeyFilterFunc? filterFn,
  }) {
    if (filterFn != null) {
      final queries = _filterQueryKey(filter: filterFn);
      // other wise invalidate the whole cache
      for (final query in queries) {
        query.invalidateQuery();
      }
    } else if (key != null) {
      final k = encodeKey(key);
      if (_queryCache.containsKey(k)) {
        _queryCache[k]?.invalidateQuery();
      }
    } else {
      // other wise invalidate the whole cache
      for (final query in _queryCache.values) {
        query.invalidateQuery();
      }
    }
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
      final queries = _filterQueryKey(filter: filterFn);
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
  void refetchQueries({KeyFilterFunc? filterFn, List<Object>? keys}) {
    assert(
      filterFn != null || keys != null,
      "Either filterFn or keys must not be null",
    );
    if (filterFn != null) {
      final queries = _filterQueryKey(filter: filterFn);
      for (final query in queries) {
        query.refetch();
      }
    }
    if (keys != null) {
      for (final key in keys) {
        final k = encodeKey(key);
        if (_queryCache.containsKey(k)) {
          _queryCache[k]!.refetch();
        }
      }
    }
  }

  /// Add a query to the cache.
  ///
  /// Shouldn't normally need to add a query manually. Queries are automatically
  /// added to the cache when they are constructed.
  void addQuery(QueryBase<dynamic, dynamic> query) {
    for (final ob in observers) {
      ob.onQueryCreation(query);
    }
    _queryCache[query.key] = query;
  }

  List<QueryBase<dynamic, dynamic>> _filterQueryKey({
    required KeyFilterFunc filter,
  }) {
    return _queryCache.values
        .where((element) => filter(element.unencodedKey, element.key))
        .toList();
  }
}
