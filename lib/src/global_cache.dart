part of "cached_query.dart";

///[GlobalCache] is a singleton that keeps track of all the cached queries
class GlobalCache {
  GlobalCache._();

  static final GlobalCache instance = GlobalCache._();

  /// Allow the creation of new instances for testing purposes
  @visibleForTesting
  factory GlobalCache.asNewInstance() {
    return GlobalCache._();
  }

  /// A flag to only allow the default options to be set once
  bool _defaultsSet = false;

  QueryStorage? storage;
  Duration refetchDuration = const Duration(seconds: 30);
  Duration cacheDuration = const Duration(minutes: 5);

  ///map to store requests
  Map<String, Query<dynamic>> queryCache = {};

  /// map to store infinite query's
  Map<String, InfiniteQuery<dynamic>> infiniteQueryCache = {};

  void setDefaults({
    Duration? cacheDuration,
    Duration? refetchDuration,
    QueryStorage? storage,
  }) {
    assert(_defaultsSet == false);
    if (!_defaultsSet) {
      this.storage = storage;
      if (cacheDuration != null) {
        this.cacheDuration = cacheDuration;
      }
      if (refetchDuration != null) {
        this.refetchDuration = refetchDuration;
      }
    }
    _defaultsSet = true;
  }

  /// Gets an existing query if it exists
  Query<T>? getQuery<T>(dynamic key) {
    final queryHash = jsonEncode(key);
    if (queryCache.containsKey(queryHash)) {
      return queryCache[queryHash] as Query<T>?;
    }
  }

  void addQuery<T>(Query<T> query) {
    queryCache[query._queryHash] = query;
  }

  /// Gets an existing infinite query if it exists
  InfiniteQuery<T>? getInfiniteQuery<T>(dynamic key) {
    final queryHash = jsonEncode(key);
    if (infiniteQueryCache.containsKey(queryHash)) {
      return infiniteQueryCache[queryHash] as InfiniteQuery<T>?;
    }
  }

  void addInfiniteQuery<T>(InfiniteQuery<T> query) {
    infiniteQueryCache[query._queryHash] = query;
  }

  /// Invalidate cache, if no key is passed it will invalidate the whole cache
  void invalidateCache({dynamic key, String? queryHash}) {
    if (key != null) {
      queryHash = jsonEncode(key);
    }
    if (queryHash != null) {
      if (queryCache.containsKey(queryHash)) {
        queryCache[queryHash]?.invalidateQuery();
      }
      if (infiniteQueryCache.containsKey(queryHash)) {
        infiniteQueryCache[queryHash]?.invalidateQuery();
      }
    } else {
      // other wise invalidate the whole cache
      queryCache = {};
    }
  }

  void deleteCache({dynamic key, String? queryHash}) {
    if (key != null) {
      queryHash = jsonEncode(key);
    }
    if (queryHash != null) {
      if (queryCache.containsKey(queryHash)) {
        queryCache.remove(queryHash);
      }
    } else {
      // other wise invalidate the whole cache
      queryCache = {};
    }
  }
}
