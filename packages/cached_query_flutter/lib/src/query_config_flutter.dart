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
    super.serializer,
    super.deserializer,
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
          other is QueryConfigFlutter &&
          runtimeType == other.runtimeType &&
          refetchOnResume == other.refetchOnResume &&
          refetchOnConnection == other.refetchOnConnection;

  @override
  int get hashCode => super.hashCode ^ refetchOnResume.hashCode ^ refetchOnConnection.hashCode;
}

/// {@template cachedQueryConfigFlutter}
/// Global Cached Query config including flutter options
/// {@endtemplate}
class CachedQueryConfigFlutter extends CachedQueryConfig {
  /// Whether this query should be re-fetched when the app comes into the foreground
  final bool? refetchOnResume;

  /// Whether this query should be re-fetched when the device gains connection
  final bool? refetchOnConnection;

  /// {@macro queryConfigFlutter}
  CachedQueryConfigFlutter({
    this.refetchOnResume,
    this.refetchOnConnection,
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
          other is CachedQueryConfigFlutter &&
          runtimeType == other.runtimeType &&
          refetchOnResume == other.refetchOnResume &&
          refetchOnConnection == other.refetchOnConnection;

  @override
  int get hashCode => super.hashCode ^ refetchOnResume.hashCode ^ refetchOnConnection.hashCode;
}
