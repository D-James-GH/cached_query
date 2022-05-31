import 'dart:async';
import 'dart:convert';
import 'package:cached_query/cached_query.dart';
import 'package:cached_query/src/util/encode_key.dart';
import 'package:meta/meta.dart';

part 'query.dart';
part 'infinite_query.dart';
part "./query_base.dart";

/// Should return true if a condition is met.
///
/// Similar to List.where.
typedef WhereCallback = bool Function(QueryBase<dynamic, dynamic>);

/// Used to serialize the query data when fetched from local storage.
typedef Serializer<T> = T Function(dynamic json);

/// Update function used to update the data in a query.
///
/// Must return the new data.
typedef UpdateFunc<T> = T Function(T? oldData);

///[CachedQuery] is a singleton that keeps track of all the cached queries
class CachedQuery {
  /// Get the singleton instance of [CachedQuery].
  static final instance = CachedQuery._();

  bool _defaultsSet = false;
  StorageInterface? _storage;
  Duration _refetchDuration = const Duration(seconds: 4);
  Duration _cacheDuration = const Duration(minutes: 5);
  Map<String, QueryBase<dynamic, dynamic>> _queryCache = {};

  // This class should not be instantiated manually.
  CachedQuery._();

  /// Allow the creation of new instances for testing purposes
  @visibleForTesting
  factory CachedQuery.asNewInstance() {
    return CachedQuery._();
  }

  /// Set the global default config which all queries will use.
  void config({
    Duration? cacheDuration,
    Duration? refetchDuration,
    StorageInterface? storage,
  }) {
    assert(_defaultsSet == false, "Config defaults must only be set once.");
    if (!_defaultsSet) {
      _storage = storage;
      if (cacheDuration != null) {
        _cacheDuration = cacheDuration;
      }
      if (refetchDuration != null) {
        _refetchDuration = refetchDuration;
      }
    }
    _defaultsSet = true;
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
