part of "_query.dart";

/// {@template Cacheable}
/// The interface for any cachable query.
/// {@endtemplate}
sealed class Cacheable<State> {
  /// The query key that has been converted to a string.
  String get key;

  /// The original unencoded query key.
  Object get unencodedKey;

  /// The current state of the query.
  State get state;

  /// The state stream of the query.
  Stream<State> get stream;

  /// Whether the query is stale and therefore requires a refetch when next listened to.
  bool get stale;

  /// Whether the query has a listener.
  bool get hasListener;

  /// Fetch the query as a future.
  Future<State> fetch();

  /// Refetch the query as a future.
  Future<State> refetch();

  /// Delete the query from the cache.
  void deleteQuery({bool deleteStorage});

  /// Invalidate the query.
  Future<void> invalidate({
    bool refetchActive,
    bool refetchInactive,
  });

  /// Dispose the query. Cleans up streams and timers.
  /// Generally it is not necessary to call this manually.
  ///
  /// Note: this will delete it from cache.
  Future<void> dispose();

  /// Query config
  QueryConfig<Object?> get config;

}
