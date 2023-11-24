// ignore_for_file: deprecated_member_use_from_same_package
import '../cached_query.dart';

/// {@template QueryConfig.ShouldRefetch}
/// ShouldRefetch is called before a query is fetched, both after the data is fetched from storage
/// and when a query is stale. This would usually not be necessary to use but can give
/// a high level of control over when a query should be re-fetched. The second
/// parameter (storageOnly) is true if the query has only been fetched from storage.
///
/// If no [ShouldRefetch] is passed; all normal caching rules apply.
/// {@endtemplate}
typedef ShouldRefetch = bool Function(
  QueryBase<dynamic, dynamic>,
  // ignore: avoid_positional_boolean_parameters
  bool afterStorage,
);

/// {@template queryConfig}
/// [QueryConfig] is used to configure a [Query].
/// {@endtemplate}
class QueryConfig {
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

  /// The serializer is called when the query is fetched from storage. Use it to
  /// change the stored value to the query value.
  final Serializer? serializer;

  /// {@template QueryConfig.storageSerializer}
  /// Converts the query data to a storable format.
  /// {@endtemplate}
  final Serializer? storageSerializer;

  /// {@template QueryConfig.storageDeserializer}
  /// Called when the query is fetched from storage and should
  /// convert the stored data to the usable data.
  /// {@endtemplate}
  final Serializer? storageDeserializer;

  /// {@template QueryConfig.ignoreCacheDuration}
  /// If set to true the query(ies) will never be removed from cache.
  /// {@endtemplate}
  final bool ignoreCacheDuration;

  /// {@macro QueryConfig.ShouldRefetch}
  final ShouldRefetch? shouldRefetch;

  const QueryConfig._({
    required this.shouldRefetch,
    required this.serializer,
    required this.storageSerializer,
    required this.storageDeserializer,
    required this.ignoreCacheDuration,
    required this.storeQuery,
    required this.refetchDuration,
    required this.cacheDuration,
    required this.shouldRethrow,
  });

  /// Returns a query config with the default values.
  factory QueryConfig.defaults() => const QueryConfig._(
        serializer: null,
        storageSerializer: null,
        shouldRefetch: null,
        storageDeserializer: null,
        ignoreCacheDuration: false,
        storeQuery: true,
        refetchDuration: Duration(seconds: 4),
        cacheDuration: Duration(minutes: 5),
        shouldRethrow: false,
      );

  /// {@macro queryConfig}
  ///
  /// {@macro QueryConfig.storageSerializer}
  ///
  /// {@macro QueryConfig.storageDeserializer}
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
  QueryConfig({
    @Deprecated('Use storageDeserializer instead') Serializer? serializer,
    Serializer? storageSerializer,
    Serializer? storageDeserializer,
    ShouldRefetch? shouldRefetch,
    bool? ignoreCacheDuration,
    bool? storeQuery,
    Duration? refetchDuration,
    Duration? cacheDuration,
    bool? shouldRethrow,
    // use the defaults if not set
  })  : serializer =
            serializer ?? CachedQuery.instance.defaultConfig.serializer,
        storageSerializer = storageSerializer ??
            CachedQuery.instance.defaultConfig.storageSerializer,
        storageDeserializer = storageDeserializer ??
            CachedQuery.instance.defaultConfig.storageDeserializer,
        ignoreCacheDuration = ignoreCacheDuration ??
            CachedQuery.instance.defaultConfig.ignoreCacheDuration,
        storeQuery =
            storeQuery ?? CachedQuery.instance.defaultConfig.storeQuery,
        refetchDuration = refetchDuration ??
            CachedQuery.instance.defaultConfig.refetchDuration,
        cacheDuration =
            cacheDuration ?? CachedQuery.instance.defaultConfig.cacheDuration,
        shouldRefetch =
            shouldRefetch ?? CachedQuery.instance.defaultConfig.shouldRefetch,
        shouldRethrow =
            shouldRethrow ?? CachedQuery.instance.defaultConfig.shouldRethrow;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryConfig &&
          runtimeType == other.runtimeType &&
          refetchDuration == other.refetchDuration &&
          storeQuery == other.storeQuery &&
          cacheDuration == other.cacheDuration &&
          shouldRethrow == other.shouldRethrow &&
          serializer == other.serializer &&
          storageDeserializer == other.storageDeserializer &&
          storageSerializer == other.storageSerializer &&
          ignoreCacheDuration == other.ignoreCacheDuration;

  @override
  int get hashCode =>
      refetchDuration.hashCode ^
      storeQuery.hashCode ^
      cacheDuration.hashCode ^
      shouldRethrow.hashCode ^
      serializer.hashCode ^
      storageDeserializer.hashCode ^
      ignoreCacheDuration.hashCode;
}
