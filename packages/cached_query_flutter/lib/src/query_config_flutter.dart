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
    super.storageSerializer,
    super.storageDeserializer,
    super.ignoreCacheDuration,
    super.storeQuery,
    super.refetchDuration,
    super.shouldRefetch,
    super.storageDuration,
    super.cacheDuration,
    super.shouldRethrow,
  });
}
