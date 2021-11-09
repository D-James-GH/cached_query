import 'dart:convert';

import 'package:cached_query/src/query_manager.dart';
import 'package:flutter/cupertino.dart';

import 'infinite_query_manager.dart';

class GlobalCache {
  GlobalCache._();
  static final GlobalCache instance = GlobalCache._();

  @visibleForTesting
  factory GlobalCache.asNewInstance() {
    return GlobalCache._();
  }

  //map to store requests
  Map<String, QueryManager<dynamic>> _queryCache = {};

  // map to store infinite query's
  Map<String, InfiniteQueryManager<dynamic>> _infiniteQueryCache = {};

  /// [getQuery] either gets an existing query with the right [key]. Or it creates
  /// a new query.
  QueryManager<T> getQuery<T>({
    required dynamic key,
    required Future<T> Function() queryFn,
    Duration? staleTime,
    Duration? cacheTime,
    bool ignoreCacheTime = false,
    bool ignoreStaleTime = false,
  }) {
    final queryHash = jsonEncode(key);
    var query = _queryCache[queryHash];

    if (query == null) {
      query = QueryManager<T>(
        queryHash: queryHash,
        key: key,
        staleTime: staleTime,
        cacheTime: cacheTime,
        queryFn: queryFn,
      );
      _queryCache[queryHash] = query;
    }
    return query as QueryManager<T>;
  }

  InfiniteQueryManager<T> getInfiniteQuery<T>({
    required dynamic key,
    required int initialPage,
    required Future<List<T>> Function(int) queryFn,
    required Duration staleTime,
    required Duration cacheTime,

    /// Supply a list of pages to fetch when the first query is called
    List<int>? prefetchPages,
  }) {
    final queryHash = jsonEncode(key);

    InfiniteQueryManager<dynamic>? infiniteQuery =
        _infiniteQueryCache[queryHash];

    if (infiniteQuery == null) {
      infiniteQuery = InfiniteQueryManager<T>(
        queryFn: queryFn,
        cacheTime: cacheTime,
        staleTime: staleTime,
        key: queryHash,
        initialPage: initialPage,
      );

      _infiniteQueryCache[queryHash] = infiniteQuery;
    }
    if (prefetchPages != null) {
      infiniteQuery.preFetchPages(prefetchPages);
    }
    return infiniteQuery as InfiniteQueryManager<T>;
  }

  /// Gets an existing query if it exists
  QueryManager<T>? getExistingQuery<T>(dynamic key) {
    final queryHash = jsonEncode(key);
    if (_queryCache.containsKey(queryHash)) {
      return _queryCache[queryHash] as QueryManager<T>?;
    }
  }

  /// Gets an existing infinite query if it exists
  InfiniteQueryManager<T>? getExistingInfiniteQuery<T>(dynamic key) {
    final queryHash = jsonEncode(key);
    if (_infiniteQueryCache.containsKey(queryHash)) {
      return _infiniteQueryCache[queryHash] as InfiniteQueryManager<T>?;
    }
  }

  /// Invalidate cache, if no key is passed it will invalidate the whole cache
  void invalidateCache({dynamic key, String? queryHash}) {
    if (key != null) {
      queryHash = jsonEncode(key);
    }
    if (queryHash != null) {
      if (_queryCache.containsKey(queryHash)) {
        _queryCache[queryHash]?.invalidateQuery();
      }
      if (_infiniteQueryCache.containsKey(queryHash)) {
        _infiniteQueryCache[queryHash]?.invalidateQuery();
      }
    } else {
      // other wise invalidate the whole cache
      _queryCache = {};
    }
  }

  void deleteCache({dynamic key, String? queryHash}) {
    if (key != null) {
      queryHash = jsonEncode(key);
    }
    if (queryHash != null) {
      if (_queryCache.containsKey(queryHash)) {
        _queryCache.remove(queryHash);
      }
    } else {
      // other wise invalidate the whole cache
      _queryCache = {};
    }
  }
}
