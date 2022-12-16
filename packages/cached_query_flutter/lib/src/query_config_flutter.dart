import 'package:cached_query/cached_query.dart';

/// {@template queryConfigFlutter}
/// Query config including flutter options
/// {@endtemplate}
class QueryConfigFlutter extends QueryConfig {
  /// Whether this query should be re-fetched when the app comes into the foreground
  final bool? refetchOnResume;

  /// Whether this query should be re-fetched when the device gains connection
  final bool? refetchOnConnection;

  /// {@macro queryConfigFlutter}
  QueryConfigFlutter({
    this.refetchOnResume,
    this.refetchOnConnection,
    Serializer? serializer,
    bool? ignoreCacheDuration,
    bool? storeQuery,
    Duration? refetchDuration,
    Duration? cacheDuration,
    bool? shouldRethrow,
  }) : super(
          ignoreCacheDuration: ignoreCacheDuration,
          serializer: serializer,
          storeQuery: storeQuery,
          refetchDuration: refetchDuration,
          cacheDuration: cacheDuration,
          shouldRethrow: shouldRethrow,
        );
}
