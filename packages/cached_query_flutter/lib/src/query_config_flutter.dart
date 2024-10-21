import 'package:cached_query/cached_query.dart';

/// {@template queryConfigFlutter}
/// Query config including flutter options
/// {@endtemplate}
class QueryConfigFlutter extends QueryConfig {
  /// Whether this query should be re-fetched when the app comes into the foreground
  ///
  /// Defaults to true.
  final bool refetchOnResume;

  /// How long the app needs to stay in the background before refetching the
  /// query if [refetchOnResume] is true.
  ///
  /// Defaults to 5 seconds.
  ///
  /// Note:
  /// Some Android devices with missconfigured settings appear to trigger
  /// forground and background events in quick succession while beeing
  /// constantly in the foreground.
  /// Having a value greater than 500ms will prevent those devices from
  /// refetching the query on these kinds of sketchy events.
  final Duration refetchOnResumeMinBackgroundDuration;

  /// Whether this query should be re-fetched when the device gains connection
  ///
  /// Defaults to true.
  final bool refetchOnConnection;

  /// {@macro queryConfigFlutter}
  QueryConfigFlutter({
    this.refetchOnResume = true,
    this.refetchOnResumeMinBackgroundDuration = const Duration(seconds: 5),
    this.refetchOnConnection = true,
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

  /// Returns a flutter query config with the default values.
  static final QueryConfigFlutter defaults = QueryConfigFlutter(
    // Note: leaving out non optional parameters, as they get their defaults
    // inside the constructor.
    storageSerializer: QueryConfig.defaults().storageSerializer,
    storageDeserializer: QueryConfig.defaults().storageDeserializer,
    storageDuration: QueryConfig.defaults().storageDuration,
    ignoreCacheDuration: QueryConfig.defaults().ignoreCacheDuration,
    storeQuery: QueryConfig.defaults().storeQuery,
    refetchDuration: QueryConfig.defaults().refetchDuration,
    cacheDuration: QueryConfig.defaults().cacheDuration,
    shouldRethrow: QueryConfig.defaults().shouldRethrow,
  );
}
