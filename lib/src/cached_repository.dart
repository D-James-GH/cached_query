/// Memory cache for api requests. Includes a default time out of 1 hour.
class CachedRepository {
  final Duration defaultCacheDuration;

  CachedRepository({this.defaultCacheDuration = const Duration(hours: 1)});

  ///map to store requests
  Map<String, CachedObject<dynamic>> cache = {};

  /// cached request
  Future<T> query<T>({
    required String key,
    required Future<T> Function() queryFn,
    Duration? cacheDuration,
  }) async {
    cacheDuration ??= defaultCacheDuration;

    CachedObject<dynamic>? cachedEntry = cache[key];
    // check if the data is in the cache
    if (cachedEntry != null) {
      // if the cache has data, make sure it is not stale
      if (cachedEntry.timeCreated.add(cacheDuration).isAfter(DateTime.now())) {
        return cachedEntry.data as T;
      } else {
        // if the data is stale invalidate the key and continue to fetch new data
        invalidateCache(key: key);
      }
    }
    cache[key] =
        CachedObject<T>(data: await queryFn(), timeCreated: DateTime.now());
    return cache[key]!.data as T;
  }

  /// cached mutation

  /// Invalidate cache, if no key is passed it will invalidate the whole cache
  void invalidateCache({String? key}) {
    if (key != null) {
      if (cache.containsKey(key)) {
        cache.remove(key);
      }
    } else {
      // other wise invalidate the whole cache
      cache = {};
    }
  }
}

class CachedObject<T> {
  T data;
  DateTime timeCreated;

  CachedObject({
    required this.data,
    required this.timeCreated,
  });
}
