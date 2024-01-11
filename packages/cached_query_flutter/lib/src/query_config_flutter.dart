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
    @Deprecated('Use QueryConfig.storageDeserializer instead')
    Serializer? serializer,
    Serializer? storageSerializer,
    Serializer? storageDeserializer,
    bool? ignoreCacheDuration,
    bool? storeQuery,
    Duration? refetchDuration,
    ShouldRefetch? shouldRefetch,
    Duration? storageDuration,
    Duration? cacheDuration,
    bool? shouldRethrow,
  }) : super(
          ignoreCacheDuration: ignoreCacheDuration,
          // ignore: deprecated_member_use
          serializer: serializer,
          storageDuration: storageDuration,
          shouldRefetch: shouldRefetch,
          storageSerializer: storageSerializer,
          storageDeserializer: storageDeserializer,
          storeQuery: storeQuery,
          refetchDuration: refetchDuration,
          cacheDuration: cacheDuration,
          shouldRethrow: shouldRethrow,
        );
}
