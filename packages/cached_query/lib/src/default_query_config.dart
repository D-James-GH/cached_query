import 'package:cached_query/src/cached_query.dart';
import 'package:cached_query/src/query_config.dart';

/// {@template defaultQueryConfig}
/// Creates a default config for all queries.
/// {@endtemplate}
class DefaultQueryConfig implements QueryConfig {
  @override
  Duration cacheDuration;

  @override
  Duration refetchDuration;

  @override
  Serializer? serializer;

  @override
  bool shouldRethrow;

  /// {@macro defaultQueryConfig}
  DefaultQueryConfig({
    this.serializer,
    this.refetchDuration = const Duration(seconds: 4),
    this.cacheDuration = const Duration(minutes: 5),
    this.shouldRethrow = false,
  });

  @override
  DefaultQueryConfig merge(QueryConfig other) {
    return copyWith(
      cacheDuration: other.cacheDuration,
      serializer: other.serializer,
      refetchDuration: other.refetchDuration,
      shouldRethrow: other.shouldRethrow,
    );
  }

  /// Creates a copy of the config with the given fields replaced by new ones.
  @override
  DefaultQueryConfig copyWith({
    Duration? cacheDuration,
    Duration? refetchDuration,
    Serializer? serializer,
    bool? shouldRethrow,
  }) {
    return DefaultQueryConfig(
      cacheDuration: cacheDuration ?? this.cacheDuration,
      refetchDuration: refetchDuration ?? this.refetchDuration,
      serializer: serializer ?? this.serializer,
      shouldRethrow: shouldRethrow ?? this.shouldRethrow,
    );
  }
}
