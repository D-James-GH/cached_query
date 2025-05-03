import 'package:cached_query/cached_query.dart';

/// {@template queryConfigFlutter}
/// Query config including flutter options
/// {@endtemplate}
class GlobalQueryConfigFlutter extends GlobalQueryConfig {
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
  GlobalQueryConfigFlutter({
    this.refetchOnResume = true,
    this.refetchOnResumeMinBackgroundDuration = const Duration(seconds: 5),
    this.refetchOnConnection = true,
    super.storageSerializer,
    super.storageDeserializer,
    super.ignoreCacheDuration,
    super.storeQuery,
    super.refetchDuration,
    super.shouldFetch,
    super.storageDuration,
    super.cacheDuration,
    super.shouldRethrow,
  });

}
