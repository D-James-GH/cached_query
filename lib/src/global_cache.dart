import 'dart:async';
import 'dart:convert';

import 'package:cached_query/src/query_manager.dart';
import 'package:flutter/cupertino.dart';

import '../cached_query.dart';
import 'infinite_query_manager.dart';
import 'models/default_query_options.dart';

class GlobalCache {
  GlobalCache._();
  final defaultQueryOptions = const DefaultQueryOptions();
  static final GlobalCache instance = GlobalCache._();

  @visibleForTesting
  factory GlobalCache.asNewInstance() {
    return GlobalCache._();
  }

  //map to store requests
  Map<String, QueryManager<dynamic>> _queryCache = {};

  // map to store infinite query's
  Map<String, InfiniteQueryManager<dynamic>> _infiniteQueryCache = {};

  // map to store any global listeners
  final Map<String, StreamSubscription<dynamic>> _subscriptions = {};

  /// [getQuery] either gets an existing query with the right [key]. Or it creates
  /// a new query.
  QueryManager<T> getQuery<T>({
    required dynamic key,
    required Future<T> Function() queryFn,
    Duration? staleTime,
    Duration? cacheTime,
    bool ignoreCacheTime = false,
    bool ignoreStaleTime = false,
    void Function(Query<T>)? listener,
  }) {
    final queryHash = jsonEncode(key);
    var query = _queryCache[queryHash];

    if (query == null) {
      query = QueryManager<T>(
        queryHash: queryHash,
        key: key,
        staleTime: staleTime ?? defaultQueryOptions.staleTime,
        cacheTime: cacheTime ?? defaultQueryOptions.cacheTime,
        queryFn: queryFn,
      );
      _queryCache[queryHash] = query;
    }
    if (listener != null) {
      _subscriptions[queryHash] =
          (query as QueryManager<T>).createStream().listen(listener);
    }
    return query as QueryManager<T>;
  }

  InfiniteQueryManager<T> getInfiniteQuery<T>({
    required dynamic key,
    required int initialPage,
    required Future<List<T>> Function(int) queryFn,
    Duration? staleTime,
    Duration? cacheTime,
    List<int>? prefetchPages,
    void Function(InfiniteQuery<T>)? listener,
  }) {
    final queryHash = jsonEncode(key);

    InfiniteQueryManager<dynamic>? infiniteQuery =
        _infiniteQueryCache[queryHash];

    if (infiniteQuery == null) {
      infiniteQuery = InfiniteQueryManager<T>(
        queryFn: queryFn,
        staleTime: staleTime ?? defaultQueryOptions.staleTime,
        cacheTime: cacheTime ?? defaultQueryOptions.cacheTime,
        key: queryHash,
        initialPage: initialPage,
      );
      _infiniteQueryCache[queryHash] = infiniteQuery;
    }

    if (listener != null) {
      _subscriptions[queryHash] = (infiniteQuery as InfiniteQueryManager<T>)
          .state
          .stream
          .listen(listener);
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
