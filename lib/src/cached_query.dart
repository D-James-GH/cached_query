import 'package:cached_query/src/global_cache.dart';
import './query_manager.dart';

import 'models/infinite_query.dart';
import 'models/query.dart';

/// Memory cache for api requests. Includes a default time out of 1 hour.
class CachedQuery {
  final Subscriber _subscriberKey = Subscriber();
  final GlobalCache _globalCache = GlobalCache.instance;
  final List<void Function()> subscriberFunctions = [];

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
    final oldQuery = _globalCache.getExistingQuery(key) as QueryManager<T>?;
    if (oldQuery != null) {
      final newData = updateFn(oldQuery.state.data);
      oldQuery.updateData(newData);
    }
  }

  void updateInfiniteQuery<T>({
    required dynamic key,
    required List<T> Function(List<T>? oldData) updateFn,
  }) {
    final oldQuery = _globalCache.getExistingInfiniteQuery(key);
    if (oldQuery != null) {
      final newData = updateFn(oldQuery.state.data as List<T>);
      oldQuery.updateData(newData);
    }
  }

  /// cached request
  /// Will simply return the response to the [queryFn] and throw/rethrow if an
  /// error occurs. For more complicated queries with state and background
  /// fetching use [queryStream]
  Future<Query<T?>> query<T>({
    required dynamic key,

    /// set [forceRefetch] to true if you want to force the query to get new data
    bool forceRefetch = false,
    required Future<T> Function() queryFn,

    /// [staleDuration] is the amount of time before another fetch happens.
    /// Defaults to [Duration.zero] for queries, meaning they will never be re-fetched
    Duration? staleTime = Duration.zero,
    Duration? cacheTime,
  }) async {
    // get an existing query, or create a new one if it doesn't exist
    final query = _globalCache.getQuery<T>(
      key: key,
      queryFn: queryFn,
      staleTime: staleTime,
      cacheTime: cacheTime,
    );

    // Subscribing returns a function to unsubscribe from the query.
    // store them in an array so that we can easily unsubscribe from querys
    // in the dispose method
    subscriberFunctions.add(query.subscribe(_subscriberKey));

    return await query.getResult(forceRefetch: forceRefetch);
  }

  /// query stream.
  /// Includes background fetching
  Stream<Query<T>> queryStream<T>({
    required dynamic key,
    required Future<T> Function() queryFn,

    /// Time between the last subscriber being removed and the cache being deleted
    Duration? cacheTime,

    /// [staleDuration] is the amount of time before another fetch happens.
    /// Defaults to `Duration(seconds: 30)` for queries, meaning they will never be re-fetched
    Duration? staleTime = const Duration(seconds: 30),
  }) {
    // get an existing query, or create a new one if it doesn't exist
    final query = _globalCache.getQuery<T>(
      key: key,
      queryFn: queryFn,
      staleTime: staleTime,
      cacheTime: cacheTime,
    );
    // Subscribing returns a function to unsubscribe from the query.
    // store them in an array so that we can easily unsubscribe from querys
    // in the dispose method
    subscriberFunctions.add(query.subscribe(_subscriberKey));
    return query.streamResult();
  }

  /// infinite query
  Future<InfiniteQuery<T>> infiniteQuery<T>({
    required dynamic key,
    required Future<List<T>> Function(int page) queryFn,

    /// set [forceRefetch] to true if you want to force the query to get new data
    bool forceRefetch = false,

    /// when data is stale refetch only first
    bool refetchFirstQueryOnly = true,

    /// Time between the last subscriber being removed and the cache being deleted
    Duration cacheTime = const Duration(minutes: 5),

    /// [staleDuration] is the amount of time before another fetch happens.
    /// Defaults to `Duration(seconds: 30)` for queries, meaning they will never be re-fetched
    Duration staleTime = const Duration(seconds: 30),

    /// initial page of the query. Defaults to 1.
    int initialPage = 1,

    /// Supply a list of pages to fetch when the first query is called
    List<int>? prefetchPages,
  }) async {
    final infiniteQuery = _globalCache.getInfiniteQuery<T>(
      key: key,
      initialPage: initialPage,
      queryFn: queryFn,
      staleTime: staleTime,
      cacheTime: cacheTime,
      prefetchPages: prefetchPages,
    );
    subscriberFunctions.add(infiniteQuery.subscribe(_subscriberKey));
    return infiniteQuery.getResult(forceRefetch: forceRefetch);
  }

  /// Stream an infinite query to include background fetching when data is stale
  Stream<InfiniteQuery<T>> infiniteQueryStream<T>({
    required dynamic key,
    required Future<List<T>> Function(int page) queryFn,

    /// set [forceRefetch] to true if you want to force the query to get new data
    bool forceRefetch = false,

    /// when data is stale refetch only first
    bool refetchFirstQueryOnly = true,

    /// Time between the last subscriber being removed and the cache being deleted
    Duration cacheTime = const Duration(minutes: 5),

    /// [staleDuration] is the amount of time before another fetch happens.
    /// Defaults to `Duration(seconds: 30)` for queries, meaning they will never be re-fetched
    Duration staleTime = const Duration(seconds: 30),

    /// initial page of the query. Defaults to 1.
    int initialPage = 1,
  }) {
    final infiniteQuery = _globalCache.getInfiniteQuery(
      key: key,
      initialPage: initialPage,
      queryFn: queryFn,
      staleTime: staleTime,
      cacheTime: cacheTime,
    );
    subscriberFunctions.add(infiniteQuery.subscribe(_subscriberKey));
    return infiniteQuery.streamResult();
  }

  /// Type arguments
  Future<T> mutation<T, A>({
    /// the argument to be passed to queryFn
    A? arg,

    /// called before the mutation [queryFn] is run.
    void Function(A? arg)? onStartMutation,
    void Function(A? arg, T res)? onSuccess,
    void Function(A? arg)? onError,
    required dynamic key,
    required Future<T> Function(A? arg) queryFn,
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

    /// called before the mutation [queryFn] is run.
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

  void invalidateQuery(dynamic key) {
    _globalCache.invalidateCache(key: key);
  }

  void dispose() {
    for (var unsubscribe in subscriberFunctions) {
      unsubscribe();
    }
  }
}
