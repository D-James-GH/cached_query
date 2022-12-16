import '../cached_query.dart';

/// {@template queryConfig}
///
/// Global config for all queries and infinite queries.
///
/// {@endtemplate}
class QueryConfig {
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

  /// The serializer is called when the query is fetched from storage. Use it to
  /// change the stored value to the query value.
  final Serializer? serializer;

  /// If set to true the query(ies) will never be removed from cache.
  final bool ignoreCacheDuration;

  const QueryConfig._({
    required this.serializer,
    required this.ignoreCacheDuration,
    required this.storeQuery,
    required this.refetchDuration,
    required this.cacheDuration,
    required this.shouldRethrow,
  });

  /// Returns a query config with the default values.
  factory QueryConfig.defaults() => const QueryConfig._(
        serializer: null,
        ignoreCacheDuration: false,
        storeQuery: true,
        refetchDuration: Duration(seconds: 4),
        cacheDuration: Duration(minutes: 5),
        shouldRethrow: false,
      );

  /// {@macro queryConfig}
  QueryConfig({
    Serializer? serializer,
    bool? ignoreCacheDuration,
    bool? storeQuery,
    Duration? refetchDuration,
    Duration? cacheDuration,
    bool? shouldRethrow,
  })  : serializer =
            serializer ?? CachedQuery.instance.defaultConfig.serializer,
        ignoreCacheDuration = ignoreCacheDuration ??
            CachedQuery.instance.defaultConfig.ignoreCacheDuration,
        storeQuery =
            storeQuery ?? CachedQuery.instance.defaultConfig.storeQuery,
        refetchDuration = refetchDuration ??
            CachedQuery.instance.defaultConfig.refetchDuration,
        cacheDuration =
            cacheDuration ?? CachedQuery.instance.defaultConfig.cacheDuration,
        shouldRethrow =
            shouldRethrow ?? CachedQuery.instance.defaultConfig.shouldRethrow;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryConfig &&
          runtimeType == other.runtimeType &&
          refetchDuration == other.refetchDuration &&
          storeQuery == other.storeQuery &&
          cacheDuration == other.cacheDuration &&
          shouldRethrow == other.shouldRethrow &&
          serializer == other.serializer &&
          ignoreCacheDuration == other.ignoreCacheDuration;

  @override
  int get hashCode =>
      refetchDuration.hashCode ^
      storeQuery.hashCode ^
      cacheDuration.hashCode ^
      shouldRethrow.hashCode ^
      serializer.hashCode ^
      ignoreCacheDuration.hashCode;
}
