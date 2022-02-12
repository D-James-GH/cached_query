import 'dart:async';
import 'package:cached_query/cached_query.dart';
import 'package:cached_query/src/util/encode_key.dart';
import './global_cache.dart';

part 'query.dart';
part 'infinite_query.dart';
part "./query_base.dart";

typedef Serializer<T> = T Function(dynamic json);

/// A function to determine the parameters of the next page in an infinite query.
/// Return null if the last page has already been fetch and therefore trigger
/// [InfiniteQueryState.hasReachedMax] to equal `true`
typedef GetNextArg<A, T> = A? Function(int currentPageIndex, T? lastPage);

/// Cache any asynchronous function results with [CachedQuery]
class CachedQuery {
  static void initialize({
    Duration? cacheDuration,
    Duration? refetchDuration,
    StorageInterface? storage,
  }) {
    GlobalCache.instance.setDefaults(
      refetchDuration: refetchDuration,
      cacheDuration: cacheDuration,
      storage: storage,
    );
  }
}

/// cached request
/// Will return the response to the [queryFn]. Errors will be avaliable on the
/// [Query] object.
///
/// [key] defines where the result will be cached,
/// and can be any json serializable value.
///
/// Can override the global defaults for [refetchDuration], [cacheDuration],
/// see [CachedQuery.initialize] for more info.
///
/// Use [forceRefetch] to force the query to be run again
///
Query<T> query<T>({
  required Object key,
  required Future<T> Function() queryFn,
  Serializer<T>? serializer,
  Duration? refetchDuration,
  Duration? cacheDuration,
  bool forceRefetch = false,
  bool ignoreRefetchDuration = false,
  bool ignoreCacheDuration = false,
}) {
  final globalCache = GlobalCache.instance;
  final queryKey = encodeKey(key);
  var query = globalCache.getQuery<T>(queryKey);

  // if query is null check the storage
  if (query == null) {
    query = Query<T>._internal(
      key: queryKey,
      refetchDuration: refetchDuration,
      cacheDuration: cacheDuration,
      queryFn: queryFn,
      serializer: serializer,
      ignoreStaleTime: ignoreRefetchDuration,
      ignoreCacheTime: ignoreCacheDuration,
    );
    globalCache.addQuery(query);
  }

  // start the fetching process
  query._getResult(forceRefetch: forceRefetch);

  return query;
}

/// [infiniteQuery] is a collection of [QueryState]'s stored together. The data field
/// in [InfiniteQuery] is a result of all the individual [QueryState] data concatenated
/// together. For more information see [InfiniteQuery]
///
/// [key] defines where the result will be cached,
/// and can be any json serializable value.
//
/// Can override the global defaults for [refetchDuration], [cacheDuration],
/// see [DefaultQueryOptions] for more info.
///
/// Use [forceRefetch] to force the query to be run again
///
/// Use [prefetchPages] to fetch multiple pages on first load, as a buffer and
/// use [initialIndex] to set the initial page of the query.
///
/// Add a [listener] to the query which will be notified whenever the query's
/// data changes.
InfiniteQuery<T, A> infiniteQuery<T, A>({
  required Object key,
  required Future<T> Function(A arg) queryFn,
  required GetNextArg<A, T> getNextArg,
  Serializer<T>? serializer,
  bool forceRefetch = false,
  Duration? cacheDuration,
  Duration? refetchDuration,
  int initialIndex = 0,
  List<A>? prefetchPages,
  bool ignoreRefetchDuration = false,
  bool ignoreCacheDuration = false,
}) {
  final globalCache = GlobalCache.instance;
  final queryKey = encodeKey(key);
  InfiniteQuery<T, A>? infiniteQuery = globalCache.getInfiniteQuery(queryKey);

  // create query if it is null
  if (infiniteQuery == null) {
    infiniteQuery = InfiniteQuery<T, A>(
      queryFn: queryFn,
      ignoreRefetchDuration: ignoreRefetchDuration,
      ignoreCacheDuration: ignoreCacheDuration,
      serializer: serializer,
      getNextArg: getNextArg,
      refetchDuration: refetchDuration ?? globalCache.refetchDuration,
      cacheDuration: cacheDuration ?? globalCache.cacheDuration,
      key: queryKey,
      initialIndex: initialIndex,
    );
    globalCache.addInfiniteQuery(infiniteQuery);
  }

  if (prefetchPages != null) {
    infiniteQuery._preFetchPages(prefetchPages);
  }
  infiniteQuery._getResult(forceRefetch: forceRefetch);
  return infiniteQuery;
}

// Utility methods ===========================================================

Query<T>? getQuery<T>(Object key) {
  return GlobalCache.instance.getQuery<T>(encodeKey(key));
}

InfiniteQuery<T, A>? getInfiniteQuery<T, A>(Object key, {int? page}) {
  return GlobalCache.instance.getInfiniteQuery<T, A>(encodeKey(key));
}

void updateQuery<T>({
  required Object key,
  required T Function(T? oldData) updateFn,
}) {
  final query = GlobalCache.instance.getQuery<T>(encodeKey(key));
  if (query != null) {
    query.update(updateFn);
  }
}

void updateInfiniteQuery<T, A>({
  required Object key,
  required List<T> Function(List<T>? oldData) updateFn,
}) {
  final infiniteQuery =
      GlobalCache.instance.getInfiniteQuery<T, A>(encodeKey(key));
  if (infiniteQuery != null) {
    infiniteQuery.update(updateFn);
  }
}

void invalidateQuery(Object key) {
  GlobalCache.instance.invalidateCache(key: encodeKey(key));
}

void deleteCache({String? key}) {
  GlobalCache.instance.deleteCache(key: key);
}

void refetchQueries(List<Object> keys) {
  for (final k in keys) {
    GlobalCache.instance.refetchQuery(encodeKey(k));
  }
}

typedef FindCallback<T> = bool Function(T);
List<Query<dynamic>>? whereQuery(FindCallback<Query<dynamic>> findCallback) {
  final List<Query<dynamic>> result = [];
  for (final query in GlobalCache.instance.queryCache.values) {
    if (findCallback(query)) {
      result.add(query);
    }
  }
  return result.isNotEmpty ? result : null;
}

List<InfiniteQuery<dynamic, dynamic>>? whereInfiniteQuery(
    FindCallback<InfiniteQuery<dynamic, dynamic>> findCallback) {
  final List<InfiniteQuery<dynamic, dynamic>> result = [];
  for (final infiniteQuery in GlobalCache.instance.infiniteQueryCache.values) {
    if (findCallback(infiniteQuery)) {
      result.add(infiniteQuery);
    }
  }
  return result.isNotEmpty ? result : null;
}
