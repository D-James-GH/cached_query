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
typedef WhereCallback<T> = bool Function(T);

/// Used to serialize the query data when fetched from local storage.
typedef Serializer<T> = T Function(dynamic json);

/// Update function used to update the data in a query.
///
/// Must return the new data.
typedef UpdateFunc<T> = T Function(T? oldData);

/// Determines the parameters of the next page in an infinite query.
///
/// Return null if the last page has already been fetch and therefore trigger
/// [InfiniteQueryState.hasReachedMax] to equal `true`.
typedef GetNextArg<A, T> = A? Function(int currentPageIndex, T? lastPage);

///[CachedQuery] is a singleton that keeps track of all the cached queries
abstract class ICachedQuery {
  /// Set the global default config which all queries will use.
  void config({
    Duration? cacheDuration,
    Duration? refetchDuration,
    StorageInterface? storage,
  });

  /// Get a [Query] at a given key.
  Query<T>? getQuery<T>(Object key);

  /// Update the [QueryState] at a given key.
  void updateQuery<T>({
    required Object key,
    required T Function(T? oldData) updateFn,
  });

  /// Find and return a list of [Query]'s matching a given condition.
  List<Query<dynamic>>? whereQuery(WhereCallback<Query<dynamic>> whereCallback);

  /// Get an [InfiniteQuery] at a given key.
  InfiniteQuery<T, A>? getInfiniteQuery<T, A>(Object key);

  /// Update the [InfiniteQueryState] at a given key.
  void updateInfiniteQuery<T, A>({
    required Object key,
    required List<T> Function(List<T>? oldData) updateFn,
  });

  /// Find and return a list of [InfiniteQuery]'s matching a given condition.
  List<InfiniteQuery<dynamic, dynamic>>? whereInfiniteQuery(
    WhereCallback<InfiniteQuery<dynamic, dynamic>> findCallback,
  );

  /// Invalidate cache currently stored.
  ///
  /// Pass a key to invalidate a query at the given key. Will invalidate both
  /// infinite queries and queries.
  void invalidateCache([Object? key]);

  /// Delete cache currently stored.
  ///
  /// Pass a key to delete a query at the given key. Will invalidate both
  /// infinite queries and queries.
  void deleteCache([Object? key]);

  /// Refetch multiple queries.
  void refetchQueries(List<Object> keys);
}

///[CachedQuery] is a singleton that keeps track of all the cached queries
class CachedQuery implements ICachedQuery {
  CachedQuery._();

  /// Allow the creation of new instances for testing purposes
  @visibleForTesting
  factory CachedQuery.asNewInstance() {
    return CachedQuery._();
  }

  /// Get the singleton instance of [CachedQuery].
  static final instance = CachedQuery._();

  bool _defaultsSet = false;
  StorageInterface? _storage;
  Duration _refetchDuration = Duration.zero;
  Duration _cacheDuration = const Duration(minutes: 5);
  Map<String, Query<dynamic>> _queryCache = {};
  Map<String, InfiniteQuery<dynamic, dynamic>> _infiniteQueryCache = {};

  /// Set the global default config which all queries will use.
  @override
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
  @override
  Query<T>? getQuery<T>(Object key) {
    final k = encodeKey(key);
    if (_queryCache.containsKey(k)) {
      return _queryCache[k] as Query<T>?;
    }
    return null;
  }

  /// Update the [QueryState] at a given key.
  @override
  void updateQuery<T>({
    required Object key,
    required T Function(T? oldData) updateFn,
  }) {
    final query = getQuery<T>(key);
    if (query != null) {
      query.update(updateFn);
    }
  }

  /// Find and return a list of [Query]'s matching a given condition.
  @override
  List<Query<dynamic>>? whereQuery(WhereCallback<Query<dynamic>> findCallback) {
    final List<Query<dynamic>> result = [];
    for (final query in _queryCache.values) {
      if (findCallback(query)) {
        result.add(query);
      }
    }
    return result.isNotEmpty ? result : null;
  }

  /// Get an [InfiniteQuery] at a given key.
  @override
  InfiniteQuery<T, A>? getInfiniteQuery<T, A>(Object key) {
    final k = encodeKey(key);
    if (_infiniteQueryCache.containsKey(k)) {
      return _infiniteQueryCache[k] as InfiniteQuery<T, A>?;
    }
    return null;
  }

  /// Update the [InfiniteQueryState] at a given key.
  @override
  void updateInfiniteQuery<T, A>({
    required Object key,
    required List<T> Function(List<T>? oldData) updateFn,
  }) {
    final infiniteQuery = getInfiniteQuery<T, A>(key);
    if (infiniteQuery != null) {
      infiniteQuery.update(updateFn);
    }
  }

  /// Find and return a list of [InfiniteQuery]'s matching a given condition.
  @override
  List<InfiniteQuery<dynamic, dynamic>>? whereInfiniteQuery(
    WhereCallback<InfiniteQuery<dynamic, dynamic>> findCallback,
  ) {
    final List<InfiniteQuery<dynamic, dynamic>> result = [];
    for (final infiniteQuery in _infiniteQueryCache.values) {
      if (findCallback(infiniteQuery)) {
        result.add(infiniteQuery);
      }
    }

    return result.isNotEmpty ? result : null;
  }

  /// Invalidate cache currently stored.
  ///
  /// Pass a key to invalidate a query at the given key. Will invalidate both
  /// infinite queries and queries.
  @override
  void invalidateCache([Object? key]) {
    if (key != null) {
      final k = encodeKey(key);
      if (_queryCache.containsKey(k)) {
        _queryCache[k]?.invalidateQuery();
      } else if (_infiniteQueryCache.containsKey(k)) {
        _infiniteQueryCache[k]?.invalidateQuery();
      }
    } else {
      // other wise invalidate the whole cache
      for (final query in _queryCache.values) {
        query.invalidateQuery();
      }
      for (final infiniteQuery in _infiniteQueryCache.values) {
        infiniteQuery.invalidateQuery();
      }
    }
  }

  /// Delete cache currently stored.
  ///
  /// Pass a key to delete a query at the given key. Will invalidate both
  /// infinite queries and queries.
  @override
  void deleteCache([Object? objectKey]) {
    if (objectKey != null) {
      final key = encodeKey(objectKey);
      if (_queryCache.containsKey(key)) {
        _queryCache.remove(key);
      } else if (_infiniteQueryCache.containsKey(key)) {
        _infiniteQueryCache.remove(key);
      }
    } else {
      // other wise invalidate the whole cache
      _queryCache = {};
      _infiniteQueryCache = {};
    }
  }

  /// Refetch multiple queries.
  @override
  void refetchQueries(List<Object> keys) {
    for (final key in keys) {
      _refetchQuery(key);
    }
  }

  void _addQuery<T>(Query<T> query) {
    _queryCache[query.key] = query;
  }

  void _addInfiniteQuery<T, A>(InfiniteQuery<T, A> query) {
    _infiniteQueryCache[query.key] = query;
  }

  void _refetchQuery(Object objectKey) {
    final key = encodeKey(objectKey);
    if (_queryCache.containsKey(key)) {
      _queryCache[key]!.refetch();
    } else if (_infiniteQueryCache.containsKey(key)) {
      _infiniteQueryCache[key]!.refetch();
    }
  }
}
