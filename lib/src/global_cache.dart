part of "cached_query.dart";

class GlobalCache {
  GlobalCache._();
  final defaultQueryOptions = const DefaultQueryOptions();
  static final GlobalCache instance = GlobalCache._();

  @visibleForTesting
  factory GlobalCache.asNewInstance() {
    return GlobalCache._();
  }

  //map to store requests
  Map<String, Query<dynamic>> _queryCache = {};

  // map to store infinite query's
  Map<String, InfiniteQuery<dynamic>> _infiniteQueryCache = {};

  // map to store any global listeners
  // final Map<String, StreamSubscription<dynamic>> _subscriptions = {};

  /// [getQuery] either gets an existing query with the right [key]. Or it creates
  /// a new query.
  Query<T> getQuery<T>({
    required dynamic key,
    required Future<T> Function() queryFn,
    Duration? staleTime,
    Duration? cacheTime,
    bool ignoreCacheTime = false,
    bool ignoreStaleTime = false,
    // void Function(QueryState<T>)? listener,
  }) {
    final queryHash = jsonEncode(key);
    var query = _queryCache[queryHash];

    if (query == null) {
      query = Query<T>._internal(
        key: key,
        staleTime: staleTime ?? defaultQueryOptions.staleTime,
        cacheTime: cacheTime ?? defaultQueryOptions.cacheTime,
        queryFn: queryFn,
        ignoreStaleTime: ignoreStaleTime,
        ignoreCacheTime: ignoreCacheTime,
      );
      _queryCache[queryHash] = query;
    }
    // if (listener != null) {
    //   _subscriptions[queryHash] =
    //       (query as Query<T>).createStream().listen(listener);
    // }
    return query as Query<T>;
  }

  InfiniteQuery<T> getInfiniteQuery<T>({
    required dynamic key,
    required int initialPage,
    required Future<List<T>> Function(int) queryFn,
    Duration? staleTime,
    Duration? cacheTime,
    List<int>? prefetchPages,
    // void Function(InfiniteQuery<T>)? listener,
  }) {
    final queryHash = jsonEncode(key);

    InfiniteQuery<dynamic>? infiniteQuery = _infiniteQueryCache[queryHash];

    if (infiniteQuery == null) {
      infiniteQuery = InfiniteQuery<T>(
        queryFn: queryFn,
        staleTime: staleTime ?? defaultQueryOptions.staleTime,
        cacheTime: cacheTime ?? defaultQueryOptions.cacheTime,
        key: queryHash,
        initialPage: initialPage,
      );
      _infiniteQueryCache[queryHash] = infiniteQuery;
    }

    // if (listener != null) {
    //   _subscriptions[queryHash] = (infiniteQuery as InfiniteQueryManager<T>)
    //       .state
    //       .stream
    //       .listen(listener);
    // }

    if (prefetchPages != null) {
      infiniteQuery._preFetchPages(prefetchPages);
    }
    return infiniteQuery as InfiniteQuery<T>;
  }

  /// Gets an existing query if it exists
  Query<T>? getExistingQuery<T>(dynamic key) {
    final queryHash = jsonEncode(key);
    if (_queryCache.containsKey(queryHash)) {
      return _queryCache[queryHash] as Query<T>?;
    }
  }

  /// Gets an existing infinite query if it exists
  InfiniteQuery<T>? getExistingInfiniteQuery<T>(dynamic key) {
    final queryHash = jsonEncode(key);
    if (_infiniteQueryCache.containsKey(queryHash)) {
      return _infiniteQueryCache[queryHash] as InfiniteQuery<T>?;
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
