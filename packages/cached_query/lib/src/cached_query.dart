import 'dart:async';
import 'dart:convert';
import 'package:cached_query/cached_query.dart';
import 'package:cached_query/src/query_state.dart';
import 'package:cached_query/src/storage_interface.dart';
import 'package:meta/meta.dart';
part 'query.dart';
part 'infinite_query.dart';
part "./global_cache.dart";
part "./query_base.dart";

typedef Serializer<T> = T Function(dynamic json);

/// A function to determine the parameters of the next page in an infinite query.
/// Return null if the last page has already been fetch and therefore trigger
/// [InfiniteQueryState.hasReachedMax] to equal `true`
typedef GetNextArg<A, T> = A? Function(int currentPage, T? lastPage);

/// Cache any asynchronous function results with [CachedQuery]
class CachedQuery {
  static void initialize({
    Duration? cacheDuration,
    Duration? refetchDuration,
    StorageInterface? storage,
  }) async {
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
  final queryKey = _encodeKey(key);
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
  bool ignoreStaleTime = false,
  bool ignoreCacheTime = false,
}) {
  final globalCache = GlobalCache.instance;
  final queryKey = _encodeKey(key);
  InfiniteQuery<T, A>? infiniteQuery = globalCache.getInfiniteQuery(queryKey);

  // create query if it is null
  if (infiniteQuery == null) {
    infiniteQuery = InfiniteQuery<T, A>(
      queryFn: queryFn,
      ignoreRefetchDuration: ignoreStaleTime,
      ignoreCacheDuration: ignoreCacheTime,
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

/// Type arguments
Future<T> mutation<T, A>({
  /// the argument to be passed to queryFn
  required A arg,

  /// called before the mutation [_queryFn] is run.
  void Function(A arg)? onStartMutation,
  void Function(A arg, T res)? onSuccess,
  void Function(A arg, Object error)? onError,
  required Object key,
  required Future<T> Function(A arg) queryFn,
  List<Object>? invalidateQueries,
}) async {
  if (onStartMutation != null) {
    onStartMutation(arg);
  }
  // call query fn
  try {
    final res = await queryFn(arg);
    if (onSuccess != null) {
      onSuccess(arg, res);
    }
    if (invalidateQueries != null) {
      for (var k in invalidateQueries) {
        GlobalCache.instance.invalidateCache(key: _encodeKey(k));
      }
    }
    return res;
  } catch (e) {
    if (onError != null) {
      onError(arg, e);
    }
    rethrow;
  }
}

// Utility methods ===========================================================

/// get the result of an existing query
T? getQuery<T>(Object key) {
  final query = GlobalCache.instance.getQuery<T>(_encodeKey(key));
  return query?.state.data;
}

/// get the result of an existing query
T? getInfiniteQuery<T, A>(Object key, {int? page}) {
  final query = GlobalCache.instance.getInfiniteQuery<T, A>(_encodeKey(key));
  if (query == null) return null;
  final res = query.state;
  return res.data as T?;
}

void updateQuery<T>({
  required Object key,
  required T Function(T? oldData) updateFn,
}) {
  final query = GlobalCache.instance.getQuery<T>(_encodeKey(key));
  if (query != null) {
    query.update(updateFn);
  }
}

void updateInfiniteQuery<T, A>({
  required Object key,
  required List<T> Function(List<T>? oldData) updateFn,
}) {
  final query = GlobalCache.instance.getInfiniteQuery<T, A>(_encodeKey(key));
  if (query != null) {
    query.update(updateFn);
  }
}

void invalidateQuery(Object key) {
  GlobalCache.instance.invalidateCache(key: _encodeKey(key));
}

String _encodeKey(Object key) {
  if (key is String) return key;
  return jsonEncode(key);
}
