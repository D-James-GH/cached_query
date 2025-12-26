import 'package:cached_query/src/query/controller_options.dart';

import '../cached_query.dart';

/// {@template QueryConfig.ShouldRefetch}
/// ShouldFetch is called before a query is fetched, both after the data is fetched from storage
/// and when a query is stale. This would usually not be necessary to use but can give
/// a high level of control over when a query should be fetched.
///
/// If no [ShouldFetch] is passed; all normal caching rules apply.
/// {@endtemplate}
typedef ShouldFetch<Data> = bool Function(
  Object key,
  Data? data,
  DateTime createdAt,
);

final _defaultConfig = GlobalQueryConfig();

/// {@template GlobalQueryConfig}
/// The global config for all queries.
/// {@endtemplate}
class GlobalQueryConfig {
  /// {@template QueryConfig.staleDuration}
  /// Use the [staleDuration] to specify how long before the query is considered stale.
  ///
  /// If a query is stale it will be re-fetched next time it is listened to, or fetch() is called.
  ///
  /// Defaults to 4 seconds
  /// {@endtemplate}
  final Duration staleDuration;

  /// {@template QueryConfig.storeQuery}
  /// Use [storeQuery] to set whether a query should be stored or not.
  /// Defaults to false;
  ///
  /// Only effective when [CachedQuery] storage is set.
  /// {@endtemplate}
  final bool storeQuery;

  /// {@template QueryConfig.storageDuration}
  /// Use [storageDuration] to specify how long a query is stored in the database.
  /// Defaults to Null (forever).
  /// {@endtemplate}
  final Duration? storageDuration;

  /// {@template QueryConfig.cacheDuration}
  /// Use [cacheDuration] to specify how long a query that has zero listeners
  /// stays in memory.
  ///
  /// Defaults to 5 minutes.
  /// {@endtemplate}
  final Duration cacheDuration;

  /// {@template QueryConfig.shouldRethrow}
  /// [shouldRethrow] Tells cached query whether it should rethrow any error
  /// caught in the query.
  ///
  /// [shouldRethrow] is useful if you use try catches in your app for
  /// error handling/logout. By default a query will catch all errors and exceptions
  /// and update the state.
  /// {@endtemplate}
  final bool shouldRethrow;

  /// {@template QueryConfig.ignoreCacheDuration}
  /// If set to true the query(ies) will never be removed from cache.
  /// {@endtemplate}
  final bool ignoreCacheDuration;

  ///{@macro QueryConfig.ShouldFetch}
  final ShouldFetch<dynamic>? shouldFetch;

  /// {@template QueryConfig.refetchOnResume}
  /// Whether this query should be re-fetched when the app comes into the foreground
  ///
  /// Defaults to true.
  ///
  /// Only effective when a app state stream is added to the CachedQuery instance config.
  /// {@endtemplate}
  final bool refetchOnResume;

  /// {@template QueryConfig.refetchOnResumeMinBackgroundDuration}
  /// How long the app needs to stay in the background before refetching the
  /// query if [refetchOnResume] is true.
  ///
  /// Defaults to 5 seconds.
  ///
  /// Note:
  /// Some Android devices with miss-configured settings appear to trigger
  /// foreground and background events in quick succession while being
  /// constantly in the foreground.
  /// Having a value greater than 500ms will prevent those devices from
  /// refetching the query on these kinds of sketchy events.
  /// {@endtemplate}
  final Duration refetchOnResumeMinBackgroundDuration;

  /// Whether this query should be re-fetched when the device gains connection
  ///
  /// Defaults to true.
  final bool refetchOnConnection;

  /// {@macro queryConfig}
  ///
  /// {@macro QueryConfig.storageSerializer}
  ///
  /// {@macro QueryConfig.storageDeserializer}
  ///
  /// {@macro QueryConfig.storageDuration}
  ///
  /// {@macro QueryConfig.ShouldRefetch}
  ///
  /// {@macro QueryConfig.ignoreCacheDuration}
  ///
  /// {@macro QueryConfig.storeQuery}
  ///
  /// {@macro QueryConfig.staleDuration}
  ///
  /// {@macro QueryConfig.cacheDuration}
  ///
  /// {@macro QueryConfig.shouldRethrow}
  const GlobalQueryConfig({
    this.shouldFetch,
    this.ignoreCacheDuration = false,
    this.storeQuery = false,
    this.storageDuration,
    @Deprecated('Use staleDuration instead, for clearer naming')
    Duration? refetchDuration,
    Duration? staleDuration,
    this.cacheDuration = const Duration(minutes: 5),
    this.shouldRethrow = false,
    this.refetchOnResume = true,
    this.refetchOnResumeMinBackgroundDuration = const Duration(seconds: 5),
    this.refetchOnConnection = true,
  }) : staleDuration =
            staleDuration ?? refetchDuration ?? const Duration(seconds: 4);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlobalQueryConfig &&
          runtimeType == other.runtimeType &&
          staleDuration == other.staleDuration &&
          storeQuery == other.storeQuery &&
          cacheDuration == other.cacheDuration &&
          shouldRethrow == other.shouldRethrow &&
          shouldFetch == other.shouldFetch &&
          ignoreCacheDuration == other.ignoreCacheDuration;

  @override
  int get hashCode =>
      staleDuration.hashCode ^
      storeQuery.hashCode ^
      cacheDuration.hashCode ^
      shouldRethrow.hashCode ^
      shouldFetch.hashCode ^
      ignoreCacheDuration.hashCode;
}

/// {@template queryConfig}
/// [QueryConfig] is used to configure a [Query].
///
/// The [QueryConfig] will be merged with the global config specified in the
/// instance of cache for that specific query.
///
/// {@endtemplate}
class QueryConfig<Data> implements ControllerOptions<Data> {
  /// {@macro QueryConfig.staleDuration}
  Duration get staleDuration => _staleDuration ?? _defaultConfig.staleDuration;
  final Duration? _staleDuration;

  final bool? _storeQuery;

  /// {@macro QueryConfig.storeQuery}
  @override
  bool get storeQuery => _storeQuery ?? _defaultConfig.storeQuery;

  /// {@macro QueryConfig.storageDuration}
  @override
  final Duration? storageDuration;

  /// {@template QueryConfig.refetchInterval}
  /// Return a [Duration] to have the query refetched at the given interval.
  ///
  /// The function will be called when the status of the query changes, allowing
  /// for dynamic polling intervals based on the query state.
  ///
  /// If null is returned or no function is passed, polling will be disabled.
  /// {@endtemplate}
  final Duration? Function(QueryState<Data>)? pollingInterval;

  /// {@template QueryConfig.pollInactive}
  /// If true, the polling will continue even when there are no active listeners
  ///
  /// Defaults to false.
  /// {@endtemplate}
  final bool pollInactive;

  /// {@macro QueryConfig.cacheDuration}
  @override
  Duration get cacheDuration => _cacheDuration ?? _defaultConfig.cacheDuration;
  final Duration? _cacheDuration;

  /// {@macro QueryConfig.shouldRethrow}
  bool get shouldRethrow => _shouldRethrow ?? _defaultConfig.shouldRethrow;
  final bool? _shouldRethrow;

  /// {@macro QueryConfig.storageSerializer}
  @override
  final Serializer<Data>? storageSerializer;

  /// {@macro QueryConfig.storageDeserializer}
  @override
  final Deserializer<Data>? storageDeserializer;

  /// {@macro QueryConfig.ignoreCacheDuration}
  @override
  bool get ignoreCacheDuration =>
      _ignoreCacheDuration ?? _defaultConfig.ignoreCacheDuration;
  final bool? _ignoreCacheDuration;

  final ShouldFetch<Data>? _shouldFetch;

  ///{@macro QueryConfig.ShouldFetch}
  ShouldFetch<Data> get shouldFetch => _shouldFetch ?? (_, __, ___) => true;

  /// {@macro QueryConfig.refetchOnResume}
  bool get refetchOnResume =>
      _refetchOnResume ?? _defaultConfig.refetchOnResume;
  final bool? _refetchOnResume;

  /// {@macro QueryConfig.refetchOnConnection}
  bool get refetchOnConnection =>
      _refetchOnConnection ?? _defaultConfig.refetchOnConnection;
  final bool? _refetchOnConnection;

  /// {@macro queryConfig}
  ///
  /// {@macro QueryConfig.storageSerializer}
  ///
  /// {@macro QueryConfig.storageDeserializer}
  ///
  /// {@macro QueryConfig.storageDuration}
  ///
  /// {@macro QueryConfig.ShouldRefetch}
  ///
  /// {@macro QueryConfig.ignoreCacheDuration}
  ///
  /// {@macro QueryConfig.storeQuery}
  ///
  /// {@macro QueryConfig.refetchDuration}
  ///
  /// {@macro QueryConfig.cacheDuration}
  ///
  /// {@macro QueryConfig.shouldRethrow}
  const QueryConfig({
    ShouldFetch<Data>? shouldFetch,
    this.storageSerializer,
    this.storageDuration,
    this.storageDeserializer,
    this.pollingInterval,
    this.pollInactive = false,
    bool? ignoreCacheDuration,
    bool? storeQuery,
    @Deprecated('Use staleDuration instead, for clearer naming')
    Duration? refetchDuration,
    Duration? staleDuration,
    Duration? cacheDuration,
    bool? shouldRethrow,
    bool? refetchOnResume,
    bool? refetchOnConnection,
  })  : _storeQuery = storeQuery,
        _shouldFetch = shouldFetch,
        _ignoreCacheDuration = ignoreCacheDuration,
        _staleDuration = staleDuration,
        _shouldRethrow = shouldRethrow,
        _cacheDuration = cacheDuration,
        _refetchOnResume = refetchOnResume,
        _refetchOnConnection = refetchOnConnection;

  /// Merges the global config with the local config.
  QueryConfig<Data> mergeWithGlobal(GlobalQueryConfig global) {
    return QueryConfig<Data>(
      storageDeserializer: storageDeserializer,
      storageSerializer: storageSerializer,
      pollingInterval: pollingInterval,
      pollInactive: pollInactive,
      ignoreCacheDuration: _ignoreCacheDuration ?? global.ignoreCacheDuration,
      shouldFetch: _shouldFetch ?? global.shouldFetch,
      storeQuery: _storeQuery ?? global.storeQuery,
      storageDuration: storageDuration ?? global.storageDuration,
      staleDuration: _staleDuration ?? global.staleDuration,
      cacheDuration: _cacheDuration ?? global.cacheDuration,
      shouldRethrow: _shouldRethrow ?? global.shouldRethrow,
      refetchOnResume: _refetchOnResume ?? global.refetchOnResume,
      refetchOnConnection: _refetchOnConnection ?? global.refetchOnConnection,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryConfig &&
          runtimeType == other.runtimeType &&
          staleDuration == other.staleDuration &&
          storeQuery == other.storeQuery &&
          cacheDuration == other.cacheDuration &&
          shouldRethrow == other.shouldRethrow &&
          storageDeserializer == other.storageDeserializer &&
          storageSerializer == other.storageSerializer &&
          ignoreCacheDuration == other.ignoreCacheDuration &&
          refetchOnResume == other.refetchOnResume &&
          pollingInterval == other.pollingInterval &&
          pollInactive == other.pollInactive &&
          refetchOnConnection == other.refetchOnConnection;

  @override
  int get hashCode =>
      staleDuration.hashCode ^
      storeQuery.hashCode ^
      cacheDuration.hashCode ^
      shouldRethrow.hashCode ^
      storageDeserializer.hashCode ^
      ignoreCacheDuration.hashCode ^
      refetchOnResume.hashCode ^
      pollingInterval.hashCode ^
      pollInactive.hashCode ^
      refetchOnConnection.hashCode;
}
