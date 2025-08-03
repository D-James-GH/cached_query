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
  /// {@template QueryConfig.refetchDuration}
  /// Use the [refetchDuration] Specify how long before the query is re-fetched
  /// in the background.
  ///
  /// Defaults to 4 seconds
  /// {@endtemplate}
  final Duration refetchDuration;

  /// {@template QueryConfig.storeQuery}
  /// Use [storeQuery] to set whether a query should be stored or not.
  /// Defaults to true;
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
  const GlobalQueryConfig({
    this.shouldFetch,
    this.ignoreCacheDuration = false,
    this.storeQuery = false,
    this.storageDuration,
    this.refetchDuration = const Duration(seconds: 4),
    this.cacheDuration = const Duration(minutes: 5),
    this.shouldRethrow = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlobalQueryConfig &&
          runtimeType == other.runtimeType &&
          refetchDuration == other.refetchDuration &&
          storeQuery == other.storeQuery &&
          cacheDuration == other.cacheDuration &&
          shouldRethrow == other.shouldRethrow &&
          shouldFetch == other.shouldFetch &&
          ignoreCacheDuration == other.ignoreCacheDuration;

  @override
  int get hashCode =>
      refetchDuration.hashCode ^
      storeQuery.hashCode ^
      cacheDuration.hashCode ^
      shouldRethrow.hashCode ^
      shouldFetch.hashCode ^
      ignoreCacheDuration.hashCode;
}

/// {@template queryConfig}
/// [QueryConfig] is used to configure a [Query].
/// {@endtemplate}
class QueryConfig<Data> {
  /// {@template QueryConfig.refetchDuration}
  /// Use the [refetchDuration] Specify how long before the query is re-fetched
  /// in the background.
  ///
  /// Defaults to 4 seconds
  /// {@endtemplate}
  Duration get refetchDuration =>
      _refetchDuration ?? _defaultConfig.refetchDuration;
  final Duration? _refetchDuration;

  final bool? _storeQuery;

  /// {@template QueryConfig.storeQuery}
  /// Use [storeQuery] to set whether a query should be stored or not.
  /// Defaults to true;
  ///
  /// Only effective when [CachedQuery] storage is set.
  /// {@endtemplate}
  bool get storeQuery => _storeQuery ?? _defaultConfig.storeQuery;

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
  Duration get cacheDuration => _cacheDuration ?? _defaultConfig.cacheDuration;
  final Duration? _cacheDuration;

  /// {@template QueryConfig.shouldRethrow}
  /// [shouldRethrow] Tells cached query whether it should rethrow any error
  /// caught in the query.
  ///
  /// [shouldRethrow] is useful if you use try catches in your app for
  /// error handling/logout. By default a query will catch all errors and exceptions
  /// and update the state.
  /// {@endtemplate}
  bool get shouldRethrow => _shouldRethrow ?? _defaultConfig.shouldRethrow;
  final bool? _shouldRethrow;

  /// {@template QueryConfig.storageSerializer}
  /// Converts the query data to a storable format.
  /// {@endtemplate}
  final Serializer<Data>? storageSerializer;

  /// {@template QueryConfig.storageDeserializer}
  /// Called when the query is fetched from storage and should
  /// convert the stored data to the usable data.
  /// {@endtemplate}
  final Deserializer<Data>? storageDeserializer;

  /// {@template QueryConfig.ignoreCacheDuration}
  /// If set to true the query(ies) will never be removed from cache.
  /// {@endtemplate}
  bool get ignoreCacheDuration =>
      _ignoreCacheDuration ?? _defaultConfig.ignoreCacheDuration;
  final bool? _ignoreCacheDuration;

  final ShouldFetch<Data>? _shouldFetch;

  ///{@macro QueryConfig.ShouldFetch}
  ShouldFetch<Data> get shouldFetch => _shouldFetch ?? (_, __, ___) => true;

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
    this.storageDeserializer,
    bool? ignoreCacheDuration,
    bool? storeQuery,
    this.storageDuration,
    Duration? refetchDuration,
    Duration? cacheDuration,
    bool? shouldRethrow,
  })  : _storeQuery = storeQuery,
        _shouldFetch = shouldFetch,
        _ignoreCacheDuration = ignoreCacheDuration,
        _refetchDuration = refetchDuration,
        _shouldRethrow = shouldRethrow,
        _cacheDuration = cacheDuration;

  /// Merges the global config with the local config.
  QueryConfig<Data> mergeWithGlobal(GlobalQueryConfig global) {
    return QueryConfig<Data>(
      storageDeserializer: storageDeserializer,
      storageSerializer: storageSerializer,
      ignoreCacheDuration: _ignoreCacheDuration ?? global.ignoreCacheDuration,
      shouldFetch: _shouldFetch ?? global.shouldFetch,
      storeQuery: _storeQuery ?? global.storeQuery,
      storageDuration: storageDuration ?? global.storageDuration,
      refetchDuration: _refetchDuration ?? global.refetchDuration,
      cacheDuration: _cacheDuration ?? global.cacheDuration,
      shouldRethrow: _shouldRethrow ?? global.shouldRethrow,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryConfig &&
          runtimeType == other.runtimeType &&
          refetchDuration == other.refetchDuration &&
          storeQuery == other.storeQuery &&
          cacheDuration == other.cacheDuration &&
          shouldRethrow == other.shouldRethrow &&
          storageDeserializer == other.storageDeserializer &&
          storageSerializer == other.storageSerializer &&
          ignoreCacheDuration == other.ignoreCacheDuration;

  @override
  int get hashCode =>
      refetchDuration.hashCode ^
      storeQuery.hashCode ^
      cacheDuration.hashCode ^
      shouldRethrow.hashCode ^
      storageDeserializer.hashCode ^
      ignoreCacheDuration.hashCode;
}
