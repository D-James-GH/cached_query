import 'package:cached_query/cached_query.dart';

/// {@template queryConfigFlutter}
/// Query config including flutter options
/// {@endtemplate}
class QueryConfigFlutter<T> extends QueryConfig<T> {
  /// Whether this query should be re-fetched when the app comes into the foreground
  final bool? refetchOnResume;

  /// Whether this query should be re-fetched when the device gains connection
  final bool? refetchOnConnection;

  /// {@macro queryConfigFlutter}
  QueryConfigFlutter({
    this.refetchOnResume,
    this.refetchOnConnection,
    Deserializer<T>? deserializer,
    Serializer<T?>? serializer,
    bool? ignoreCacheDuration,
    bool? storeQuery,
    Duration? refetchDuration,
    Duration? cacheDuration,
    bool? shouldRethrow,
  }) : super(
          deserializer: deserializer,
          serializer: serializer,
          ignoreCacheDuration: ignoreCacheDuration,
          storeQuery: storeQuery,
          refetchDuration: refetchDuration,
          cacheDuration: cacheDuration,
          shouldRethrow: shouldRethrow,
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is QueryConfigFlutter &&
          runtimeType == other.runtimeType &&
          refetchOnResume == other.refetchOnResume &&
          refetchOnConnection == other.refetchOnConnection;

  @override
  int get hashCode =>
      super.hashCode ^ refetchOnResume.hashCode ^ refetchOnConnection.hashCode;
}

/// {@template cachedQueryConfigFlutter}
/// Global Cached Query config including flutter options
/// {@endtemplate}
class GlobalQueryConfigFlutter extends GlobalQueryConfig {
  /// Whether this query should be re-fetched when the app comes into the foreground
  final bool? refetchOnResume;

  /// Whether this query should be re-fetched when the device gains connection
  final bool? refetchOnConnection;

  /// {@macro queryConfigFlutter}
  GlobalQueryConfigFlutter({
    this.refetchOnResume,
    this.refetchOnConnection,
    bool? ignoreCacheDuration,
    bool? storeQuery,
    Duration? refetchDuration,
    Duration? cacheDuration,
    bool? shouldRethrow,
  }) : super(
          ignoreCacheDuration: ignoreCacheDuration,
          storeQuery: storeQuery,
          refetchDuration: refetchDuration,
          cacheDuration: cacheDuration,
          shouldRethrow: shouldRethrow,
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is GlobalQueryConfigFlutter &&
          runtimeType == other.runtimeType &&
          refetchOnResume == other.refetchOnResume &&
          refetchOnConnection == other.refetchOnConnection;

  @override
  int get hashCode =>
      super.hashCode ^ refetchOnResume.hashCode ^ refetchOnConnection.hashCode;
}
