import 'dart:async';
import 'dart:convert';
import 'package:cached_query/cached_query.dart';
import 'package:cached_query/src/default_query_config.dart';
import 'package:cached_query/src/util/encode_key.dart';
import 'package:cached_query/src/util/list_extension.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'query.dart';
part 'infinite_query.dart';
part "query_base.dart";

/// Should return true if a condition is met.
///
/// Similar to List.where.
typedef WhereCallback = bool Function(QueryBase<dynamic, dynamic>);

/// Used to serialize the query data when fetched from local storage.
typedef Serializer = dynamic Function(dynamic json);

/// Update function used to update the data in a query.
///
/// Must return the new data.
typedef UpdateFunc<T> = T Function(T? oldData);

///[CachedQuery] is a singleton that keeps track of all the cached queries
class CachedQuery {
  /// Get the singleton instance of [CachedQuery].
  static final instance = CachedQuery._();

  bool _configSet = false;

  DefaultQueryConfig _config = DefaultQueryConfig();

  Map<String, QueryBase<dynamic, dynamic>> _queryCache = {};

  StorageInterface? _storage;

  /// Get the current storage interface.
  StorageInterface? get storage => _storage;

  /// The current global config that is set.
  QueryConfig get globalConfig => _config;

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
    _config = DefaultQueryConfig();
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
  void config({StorageInterface? storage, QueryConfig? config}) {
    assert(_configSet == false, "Config defaults must only be set once.");
    if (_configSet) return;
    if (config != null) {
      _config = _config.merge(config);
    }
    _storage = storage;
    _configSet = true;
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
  void updateQuery<Data>({
    required Object key,
    required UpdateFunc<Data> updateFn,
  }) {
    final query = getQuery(key);
    if (query != null) {
      assert(
        query is! InfiniteQuery,
        "Query at key $key is an InfiniteQuery. To update an InfiniteQuery use updateInfiniteQuery",
      );
      if (query is InfiniteQuery) return;
      (query as Query<Data>).update(updateFn);
    }
  }

  /// Update the data of an [InfiniteQuery] at a given key.
  void updateInfiniteQuery<Data>({
    required Object key,
    required UpdateFunc<List<Data>> updateFn,
  }) {
    final query = getQuery(key);
    if (query != null) {
      assert(
        query is! Query,
        "InfiniteQuery at key $key is an Query. To update a Query use updateQuery",
      );

      if (query is Query) return;
      (query as InfiniteQuery<Data, dynamic>).update(updateFn);
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
  void invalidateCache([Object? key]) {
    if (key != null) {
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
  void deleteCache([Object? objectKey]) {
    if (objectKey != null) {
      final key = encodeKey(objectKey);
      if (_queryCache.containsKey(key)) {
        _queryCache.remove(key);
      }
    } else {
      // other wise invalidate the whole cache
      _queryCache = {};
    }
  }

  /// Refetch multiple queries.
  void refetchQueries(List<Object> keys) {
    for (final key in keys) {
      final k = encodeKey(key);
      if (_queryCache.containsKey(k)) {
        _queryCache[k]!.refetch();
      }
    }
  }

  void _addQuery(QueryBase<dynamic, dynamic> query) {
    _queryCache[query.key] = query;
  }
}
