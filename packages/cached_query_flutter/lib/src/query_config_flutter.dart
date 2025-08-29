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
  const GlobalQueryConfigFlutter({
    this.refetchOnResume = true,
    this.refetchOnResumeMinBackgroundDuration = const Duration(seconds: 5),
    this.refetchOnConnection = true,
    super.ignoreCacheDuration,
    super.storeQuery,
    @Deprecated("Use staleDuration instead") super.refetchDuration,
    super.staleDuration,
    super.shouldFetch,
    super.storageDuration,
    super.cacheDuration,
    super.shouldRethrow,
  });
}

///
const defaultFlutterConfig = GlobalQueryConfigFlutter();

/// {@macro queryConfigFlutter}
class QueryConfigFlutter<Data> extends QueryConfig<Data> {
  /// Whether this query should be re-fetched when the app comes into the foreground
  ///
  /// Defaults to true.
  bool get refetchOnResume =>
      _refetchOnResume ?? defaultFlutterConfig.refetchOnResume;
  final bool? _refetchOnResume;

  /// Whether this query should be re-fetched when the device gains connection
  ///
  /// Defaults to true.
  bool get refetchOnConnection =>
      _refetchOnConnection ?? defaultFlutterConfig.refetchOnConnection;
  final bool? _refetchOnConnection;

  /// {@macro queryConfigFlutter}
  const QueryConfigFlutter({
    bool? refetchOnResume,
    bool? refetchOnConnection,
    super.ignoreCacheDuration,
    super.storeQuery,
    @Deprecated("Use staleDuration instead") super.refetchDuration,
    super.staleDuration,
    super.shouldFetch,
    super.storageDuration,
    super.cacheDuration,
    super.shouldRethrow,
    super.storageDeserializer,
    super.storageSerializer,
  })  : _refetchOnResume = refetchOnResume,
        _refetchOnConnection = refetchOnConnection;

  @override
  QueryConfig<Data> mergeWithGlobal(GlobalQueryConfig global) {
    final superConfig = super.mergeWithGlobal(global);
    return QueryConfigFlutter(
      refetchOnConnection: switch (global) {
        GlobalQueryConfigFlutter() =>
          _refetchOnConnection ?? global.refetchOnConnection,
        _ => _refetchOnConnection ?? defaultFlutterConfig.refetchOnConnection,
      },
      refetchOnResume: switch (global) {
        GlobalQueryConfigFlutter() =>
          _refetchOnResume ?? global.refetchOnResume,
        _ => _refetchOnResume ?? defaultFlutterConfig.refetchOnResume,
      },

      //
      storageDeserializer: superConfig.storageDeserializer,
      storageSerializer: superConfig.storageSerializer,
      ignoreCacheDuration: superConfig.ignoreCacheDuration,
      shouldFetch: superConfig.shouldFetch,
      storeQuery: superConfig.storeQuery,
      storageDuration: superConfig.storageDuration,
      staleDuration: superConfig.staleDuration,
      cacheDuration: superConfig.cacheDuration,
      shouldRethrow: superConfig.shouldRethrow,
    );
  }
}
