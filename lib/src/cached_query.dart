import 'dart:async';
import 'dart:convert';
import 'package:cached_query/src/models/infinite_query_state.dart';
import 'package:flutter/foundation.dart';

import 'models/default_query_options.dart';
import 'models/query_state.dart';
part 'query.dart';
part 'infinite_query.dart';
part "./global_cache.dart";
part "./query_base.dart";

/// Cache any asynchronous function results with [CachedQuery]
class CachedQuery {
  final Subscriber _subscriberKey = Subscriber();
  final GlobalCache _globalCache = GlobalCache.instance;
  final List<void Function()> _subscriberFunctions = [];

  /// cached request
  /// Will return the response to the [queryFn] and throw/rethrow if an
  /// error occurs. For more complicated queries with state and background
  /// fetching use [queryStream].
  ///
  /// [key] defines where the result will be cached,
  /// and can be any json serializable value.
  ///
  /// Can override the global defaults for [staleTime], [cacheTime],
  /// see [DefaultQueryOptions]. Or ignore them.
  ///
  /// Use [forceRefetch] to force the query to be run again
  ///
  /// Add a [listener] to the query which will be notified whenever the query's
  /// data changes.
  Query<T?> query<T>({
    required dynamic key,
    required Future<T> Function() queryFn,
    Duration? staleTime,
    Duration? cacheTime,
    bool forceRefetch = false,
    bool ignoreStaleTime = false,
    bool ignoreCacheTime = false,
    void Function(QueryState<T>)? listener,
  }) {
    // get an existing query, or create a new one if it doesn't exist
    final query = _globalCache.getQuery<T>(
      key: key,
      queryFn: queryFn,
      staleTime: staleTime,
      cacheTime: cacheTime,
      ignoreStaleTime: ignoreStaleTime,
      ignoreCacheTime: ignoreCacheTime,
    );

    // Subscribing returns a function to unsubscribe from the query.
    // store them in an array so that we can easily unsubscribe from querys
    // in the dispose method
    // _subscriberFunctions.add(query._subscribe(_subscriberKey));
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
  /// Can override the global defaults for [staleTime], [cacheTime],
  /// see [DefaultQueryOptions]. Or ignore them.
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
    bool forceRefetch = false,
    Duration? cacheTime,
    Duration? staleTime,
    int initialPage = 1,
    List<int>? prefetchPages,
    void Function(InfiniteQuery<T>)? listener,
  }) {
    final infiniteQuery = _globalCache.getInfiniteQuery<T>(
      key: key,
      initialPage: initialPage,
      queryFn: queryFn,
      staleTime: staleTime,
      cacheTime: cacheTime,
      prefetchPages: prefetchPages,
    );
    // _subscriberFunctions.add(infiniteQuery._subscribe(_subscriberKey));
    infiniteQuery._getResult(forceRefetch: forceRefetch);
    return infiniteQuery;
  }

  // /// Stream an infinite query to include background fetching when data is stale
  // Stream<InfiniteQuery<T>> infiniteQueryStream<T>({
  //   required dynamic key,
  //   required Future<List<T>> Function(int page) queryFn,
  //
  //   /// set [forceRefetch] to true if you want to force the query to get new data
  //   bool forceRefetch = false,
  //
  //   /// when data is stale refetch only first
  //   bool refetchFirstQueryOnly = true,
  //
  //   /// Time between the last subscriber being removed and the cache being deleted
  //   Duration? cacheTime,
  //
  //   /// [staleDuration] is the amount of time before another fetch happens.
  //   /// Defaults to `Duration(seconds: 30)` for queries, meaning they will never be re-fetched
  //   Duration? staleTime,
  //
  //   /// initial page of the query. Defaults to 1.
  //   int initialPage = 1,
  // }) {
  //   final infiniteQuery = _globalCache.getInfiniteQuery(
  //     key: key,
  //     initialPage: initialPage,
  //     queryFn: queryFn,
  //     staleTime: staleTime,
  //     cacheTime: cacheTime,
  //   );
  //   _subscriberFunctions.add(infiniteQuery.subscribe(_subscriberKey));
  //   // return infiniteQuery.streamResult();
  //   infiniteQuery._getResult();
  //   return infiniteQuery.createStream();
  // }

  /// Type arguments
  Future<T> mutation<T, A>({
    /// the argument to be passed to queryFn
    required A arg,

    /// called before the mutation [_queryFn] is run.
    void Function(A arg)? onStartMutation,
    void Function(A arg, T res)? onSuccess,
    void Function(A arg)? onError,
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
        for (var i in invalidateQueries) {
          _globalCache.invalidateCache(key: i);
        }
      }
      return res;
    } catch (e) {
      if (onError != null) {
        onError(arg);
      }
      rethrow;
    }
  }

  /// [mutationStream] should be used for optimistic updates if the mutated query
  /// is not being listened to.
  Stream<R?> mutationStream<A, R>({
    /// the argument to be passed to queryFn
    A? arg,
    R? Function(dynamic arg, dynamic res)? onSuccess,
    void Function(dynamic error)? onError,

    /// called before the mutation [_queryFn] is run.
    R? Function(dynamic arg)? onStartMutation,
    required dynamic key,
    required Future<dynamic> Function(dynamic arg) queryFn,
    List<dynamic>? invalidateQueries,
  }) async* {
    if (onStartMutation != null) {
      final r = onStartMutation(arg);
      if (r != null) yield r;
    }
    try {
      final res = await queryFn(arg);
      if (onSuccess != null) {
        final r = onSuccess(arg, res);
        if (r != null) {
          yield r;
        }
      }
      if (invalidateQueries != null) {
        for (var i in invalidateQueries) {
          _globalCache.invalidateCache(key: i);
        }
      }
    } catch (e) {
      if (onError != null) {
        onError(arg);
      }
      rethrow;
    }
  }

  // Utility methods ===========================================================

  /// get the result of an existing query
  T? getQuery<T>(dynamic key) {
    final query = _globalCache.getExistingQuery(key);
    return query?.state.data;
  }

  /// get the result of an existing query
  T? getInfiniteQuery<T>(dynamic key, {int? page}) {
    final query = _globalCache.getExistingInfiniteQuery(key);
    if (query == null) return null;
    final res = query.state;
    return res.data as T?;
  }

  void updateQuery<T>({
    required dynamic key,
    required T Function(T? oldData) updateFn,
  }) {
    final query = _globalCache.getExistingQuery(key) as Query<T>?;
    if (query != null) {
      query.update(updateFn);
    }
  }

  void updateInfiniteQuery<T>({
    required dynamic key,
    required List<T> Function(List<T>? oldData) updateFn,
  }) {
    final query =
        _globalCache.getExistingInfiniteQuery(key) as InfiniteQuery<T>?;
    if (query != null) {
      query.update(updateFn);
    }
  }

  void invalidateQuery(dynamic key) {
    _globalCache.invalidateCache(key: key);
  }

  void close() {
    for (var unsubscribe in _subscriberFunctions) {
      unsubscribe();
    }
  }
}
