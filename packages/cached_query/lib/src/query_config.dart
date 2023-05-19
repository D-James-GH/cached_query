import '../cached_query.dart';

/// {@template cachedQueryConfig}
///
/// Global config for all queries and infinite queries.
///
/// {@endtemplate}
class CachedQueryConfig {
  /// Specify how long before the query is re-fetched in the background.
  ///
  /// Defaults to 4 seconds
  final Duration refetchDuration;

  /// Whether a query should be stored or not. Defaults to true;
  ///
  /// Only effective when [CachedQuery] storage is set.
  final bool storeQuery;

  /// Specify how long a query that has zero listeners stays in memory.
  ///
  /// Defaults to 5 minutes.
  final Duration cacheDuration;

  /// Tells cached query whether it should rethrow any error
  /// caught in the query.
  ///
  /// This is useful if you use try catches in your app for
  /// error handling/logout. By default a query will catch all errors and exceptions
  /// and update the state.
  final bool shouldRethrow;

  /// If set to true the query(ies) will never be removed from cache.
  final bool ignoreCacheDuration;

  /// Returns a query config with the default values.
  factory CachedQueryConfig.defaults() => CachedQueryConfig(
        ignoreCacheDuration: false,
        storeQuery: true,
        refetchDuration: const Duration(seconds: 4),
        cacheDuration: const Duration(minutes: 5),
        shouldRethrow: false,
      );

  /// {@macro baseQueryConfig}
  CachedQueryConfig({
    bool? ignoreCacheDuration,
    bool? storeQuery,
    Duration? refetchDuration,
    Duration? cacheDuration,
    bool? shouldRethrow,
  })  : ignoreCacheDuration = ignoreCacheDuration ?? CachedQuery.instance.defaultConfig.ignoreCacheDuration,
        storeQuery = storeQuery ?? CachedQuery.instance.defaultConfig.storeQuery,
        refetchDuration = refetchDuration ?? CachedQuery.instance.defaultConfig.refetchDuration,
        cacheDuration = cacheDuration ?? CachedQuery.instance.defaultConfig.cacheDuration,
        shouldRethrow = shouldRethrow ?? CachedQuery.instance.defaultConfig.shouldRethrow;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedQueryConfig &&
          runtimeType == other.runtimeType &&
          refetchDuration == other.refetchDuration &&
          storeQuery == other.storeQuery &&
          cacheDuration == other.cacheDuration &&
          shouldRethrow == other.shouldRethrow &&
          ignoreCacheDuration == other.ignoreCacheDuration;

  @override
  int get hashCode =>
      refetchDuration.hashCode ^
      storeQuery.hashCode ^
      cacheDuration.hashCode ^
      shouldRethrow.hashCode ^
      ignoreCacheDuration.hashCode;

  @override
  String toString() {
    return 'CachedQueryConfig{refetchDuration: $refetchDuration, storeQuery: $storeQuery, cacheDuration: $cacheDuration, shouldRethrow: $shouldRethrow, ignoreCacheDuration: $ignoreCacheDuration}';
  }
}

/// {@template queryConfig}
///
/// Config for a specific query
///
/// {@endtemplate}
class QueryConfig<T> extends CachedQueryConfig {
  /// The deserializer is called when the query is fetched from storage. Use it to
  /// change the stored value to the query value.
  final Deserializer<T>? deserializer;

  /// The serializer is called when the query is being written to storage. Typically
  /// this should convert the query data into json.
  final Serializer<T?>? serializer;

  /// {@macro queryConfig}
  QueryConfig({
    this.deserializer,
    this.serializer,
    super.ignoreCacheDuration,
    super.storeQuery,
    super.refetchDuration,
    super.cacheDuration,
    super.shouldRethrow,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is QueryConfig &&
          runtimeType == other.runtimeType &&
          deserializer == other.deserializer &&
          serializer == other.serializer;

  @override
  int get hashCode => super.hashCode ^ deserializer.hashCode ^ serializer.hashCode;

  @override
  String toString() {
    return 'QueryConfig{deserializer: $deserializer, serializer: $serializer}';
  }
}
