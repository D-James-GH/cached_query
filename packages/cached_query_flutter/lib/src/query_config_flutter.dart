import 'package:cached_query/cached_query.dart';

/// {@template queryConfigFlutter}
/// Query config including flutter options
/// {@endtemplate}
class GlobalQueryConfigFlutter extends GlobalQueryConfig {
  /// {@macro queryConfigFlutter}
  const GlobalQueryConfigFlutter({
    super.refetchOnResume,
    super.refetchOnResumeMinBackgroundDuration,
    super.refetchOnConnection,
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
  /// {@macro queryConfigFlutter}
  const QueryConfigFlutter({
    super.refetchOnResume,
    super.ignoreCacheDuration,
    super.refetchOnConnection,
    super.storeQuery,
    @Deprecated("Use staleDuration instead") super.refetchDuration,
    super.staleDuration,
    super.shouldFetch,
    super.storageDuration,
    super.cacheDuration,
    super.shouldRethrow,
    super.storageDeserializer,
    super.storageSerializer,
  });
}
