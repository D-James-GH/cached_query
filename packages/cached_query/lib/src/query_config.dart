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
  final Duration? refetchDuration;

  /// Whether a query should be stored or not. Defaults to true;
  ///
  /// Only effective when [CachedQuery] storage is set.
  final bool? storeQuery;

  /// Specify how long a query that has zero listeners stays in memory.
  ///
  /// Defaults to 5 minutes.
  final Duration? cacheDuration;

  /// Tells cached query whether it should rethrow any error
  /// caught in the query.
  ///
  /// This is useful if you use try catches in your app for
  /// error handling/logout. By default a query will catch all errors and exceptions
  /// and update the state.
  final bool? shouldRethrow;

  /// The serializer is called when the query is fetched from storage. Use it to
  /// change the stored value to the query value.
  final Serializer? serializer;

  /// If set to true the query(ies) will never be removed from cache.
  final bool? ignoreCacheDuration;

  /// {@macro queryConfig}
  const QueryConfig({
    this.serializer,
    this.ignoreCacheDuration,
    this.storeQuery,
    this.refetchDuration,
    this.cacheDuration,
    this.shouldRethrow,
  });

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
