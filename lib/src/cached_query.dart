import 'dart:async';
import 'dart:convert';
import 'package:cached_query/cached_query.dart';
import 'package:cached_query/src/hydration/query_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'query.dart';
part 'infinite_query.dart';
part "./global_cache.dart";
part "./query_base.dart";

typedef Serializer<T> = T Function(dynamic json);

/// Cache any asynchronous function results with [CachedQuery]
class CachedQuery {
  static initialize({
    Duration? cacheDuration,
    Duration? refetchDuration,
    QueryStorage? storage,
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
  required dynamic key,
  required Future<T> Function() queryFn,
  Serializer<T>? serializer,
  Duration? refetchDuration,
  Duration? cacheDuration,
  bool forceRefetch = false,
  bool ignoreStaleTime = false,
  bool ignoreCacheTime = false,
}) {
  final globalCache = GlobalCache.instance;
  var query = globalCache.getQuery<T>(key);

  // if query is null check the storage
  if (query == null) {
    query = Query<T>._internal(
      key: key,
      refetchDuration: refetchDuration,
      cacheDuration: cacheDuration,
      queryFn: queryFn,
      serializer: serializer,
      ignoreStaleTime: ignoreStaleTime,
      ignoreCacheTime: ignoreCacheTime,
    );
    globalCache.addQuery(query);
  }

  // start the fetching process
  query.getResult(forceRefetch: forceRefetch);

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
/// use [initialPage] to set the initial page of the query.
///
/// Add a [listener] to the query which will be notified whenever the query's
/// data changes.
InfiniteQuery<T> infiniteQuery<T>({
  required dynamic key,
  required Future<List<T>> Function(int page) queryFn,
  Serializer<List<T>>? serializer,
  bool forceRefetch = false,
  Duration? cacheDuration,
  Duration? refetchDuration,
  int initialPage = 1,
  List<int>? prefetchPages,
  bool ignoreStaleTime = false,
  bool ignoreCacheTime = false,
}) {
  final globalCache = GlobalCache.instance;
  InfiniteQuery<T>? infiniteQuery = globalCache.getInfiniteQuery(key);

  // create query if it is null
  if (infiniteQuery == null) {
    infiniteQuery = InfiniteQuery<T>(
      queryFn: queryFn,
      ignoreStaleTime: ignoreStaleTime,
      ignoreCacheTime: ignoreCacheTime,
      serializer: serializer,
      staleTime: refetchDuration ?? globalCache.refetchDuration,
      cacheTime: cacheDuration ?? globalCache.cacheDuration,
      key: key,
      initialPage: initialPage,
    );
    globalCache.addInfiniteQuery(infiniteQuery);
  }

  if (prefetchPages != null) {
    infiniteQuery._preFetchPages(prefetchPages);
  }
  // _subscriberFunctions.add(infiniteQuery._subscribe(_subscriberKey));
  infiniteQuery._getResult(forceRefetch: forceRefetch);
  return infiniteQuery as InfiniteQuery<T>;
}

/// Type arguments
Future<T> mutation<T, A>({
  /// the argument to be passed to queryFn
  required A arg,

  /// called before the mutation [_queryFn] is run.
  void Function(A arg)? onStartMutation,
  void Function(A arg, T res)? onSuccess,
  void Function(A arg, dynamic error)? onError,
  required dynamic key,
  required Future<T> Function(A arg) queryFn,
  List<dynamic>? invalidateQueries,
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
        GlobalCache.instance.invalidateCache(key: k);
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

/// [mutationStream] should be used for optimistic updates if the mutated query
/// is not being listened to.
// Stream<R?> mutationStream<A, R>({
//   /// the argument to be passed to queryFn
//   A? arg,
//   R? Function(dynamic arg, dynamic res)? onSuccess,
//   void Function(dynamic error)? onError,
//
//   /// called before the mutation [_queryFn] is run.
//   R? Function(dynamic arg)? onStartMutation,
//   required dynamic key,
//   required Future<dynamic> Function(dynamic arg) queryFn,
//   List<dynamic>? invalidateQueries,
// }) async* {
//   if (onStartMutation != null) {
//     final r = onStartMutation(arg);
//     if (r != null) yield r;
//   }
//   try {
//     final res = await queryFn(arg);
//     if (onSuccess != null) {
//       final r = onSuccess(arg, res);
//       if (r != null) {
//         yield r;
//       }
//     }
//     if (invalidateQueries != null) {
//       for (var i in invalidateQueries) {
//         _globalCache.invalidateCache(key: i);
//       }
//     }
//   } catch (e) {
//     if (onError != null) {
//       onError(arg);
//     }
//     rethrow;
//   }
// }

// Utility methods ===========================================================

/// get the result of an existing query
T? getQuery<T>(dynamic key) {
  final query = GlobalCache.instance.getQuery(key);
  return query?.state.data;
}

/// get the result of an existing query
T? getInfiniteQuery<T>(dynamic key, {int? page}) {
  final query = GlobalCache.instance.getInfiniteQuery(key);
  if (query == null) return null;
  final res = query.state;
  return res.data as T?;
}

void updateQuery<T>({
  required dynamic key,
  required T Function(T? oldData) updateFn,
}) {
  final query = GlobalCache.instance.getQuery(key) as Query<T>?;
  if (query != null) {
    query.update(updateFn);
  }
}

void updateInfiniteQuery<T>({
  required dynamic key,
  required List<T> Function(List<T>? oldData) updateFn,
}) {
  final query = GlobalCache.instance.getInfiniteQuery(key) as InfiniteQuery<T>?;
  if (query != null) {
    query.update(updateFn);
  }
}

void invalidateQuery(dynamic key) {
  GlobalCache.instance.invalidateCache(key: key);
}
