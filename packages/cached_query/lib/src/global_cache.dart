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
  Map<String, InfiniteQuery<dynamic, dynamic>> infiniteQueryCache = {};

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
  Query<T>? getQuery<T>(String key) {
    if (queryCache.containsKey(key)) {
      return queryCache[key] as Query<T>?;
    }
  }

  void addQuery<T>(Query<T> query) {
    queryCache[query.key] = query;
  }

  /// Gets an existing infinite query if it exists
  InfiniteQuery<T, A>? getInfiniteQuery<T, A>(String key) {
    if (infiniteQueryCache.containsKey(key)) {
      return infiniteQueryCache[key] as InfiniteQuery<T, A>?;
    }
  }

  void addInfiniteQuery<T, A>(InfiniteQuery<T, A> query) {
    infiniteQueryCache[query.key] = query;
  }

  /// Invalidate cache, if no key is passed it will invalidate the whole cache
  void invalidateCache({
    String? key,
  }) {
    if (key != null) {
      if (queryCache.containsKey(key)) {
        queryCache[key]?.invalidateQuery();
      }
      if (infiniteQueryCache.containsKey(key)) {
        infiniteQueryCache[key]?.invalidateQuery();
      }
    } else {
      // other wise invalidate the whole cache
      queryCache = {};
    }
  }

  void deleteCache({String? key}) {
    if (key != null) {
      if (queryCache.containsKey(key)) {
        queryCache.remove(key);
      }
    } else {
      // other wise invalidate the whole cache
      queryCache = {};
    }
  }
}
