import '../cached_query.dart';

/// {@template queryConfig}
/// Global config for all queries and infinite queries.
/// {@endtemplate}
class QueryConfig {
  /// Specify how long before the query is re-fetched in the background.
  ///
  /// Defaults to 4 seconds
  final Duration? refetchDuration;

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

  /// {@macro queryConfig}
  const QueryConfig({
    this.serializer,
    this.refetchDuration,
    this.cacheDuration,
    this.shouldRethrow,
  });

  /// Merges a different QueryConfig with this.
  QueryConfig merge(QueryConfig other) {
    return copyWith(
      cacheDuration: other.cacheDuration,
      serializer: other.serializer,
      refetchDuration: other.refetchDuration,
      shouldRethrow: other.shouldRethrow,
    );
  }

  /// Creates a copy of the config with the given fields replaced by new ones.
  QueryConfig copyWith({
    Duration? refetchDuration,
    Duration? cacheDuration,
    bool? shouldRethrow,
    Serializer? serializer,
  }) {
    return QueryConfig(
      refetchDuration: refetchDuration ?? this.refetchDuration,
      cacheDuration: cacheDuration ?? this.cacheDuration,
      shouldRethrow: shouldRethrow ?? this.shouldRethrow,
      serializer: serializer ?? this.serializer,
    );
  }
}
