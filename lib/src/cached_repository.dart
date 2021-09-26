import 'package:cached_query/src/global_cache.dart';
import './query.dart';

import 'models/query_state.dart';

/// Memory cache for api requests. Includes a default time out of 1 hour.
class CachedRepository {
  final Subscriber _subscriberKey = Subscriber();
  final GlobalCache _globalCache = GlobalCache.instance;
  final List<void Function()> subscriberFunctions = [];

  CachedRepository();

  /// cached request
  /// Will simply return the response to the [queryFn] and throw/rethrow if an
  /// error occurs. For more complicated queries with state and background
  /// fetching use [queryStream]
  Future<T> query<T>({
    required String key,
    required Future<T> Function() queryFn,

    /// [staleDuration] is the amount of time before another fetch happens.
    /// Defaults to [Duration.zero] for queries, meaning they will never be re-fetched
    Duration? staleTime = Duration.zero,
  }) async {
    // get an existing query, or create a new one if it doesn't exist
    final query = _globalCache.getQuery<T>(
        key: key, queryFn: queryFn, staleTime: staleTime);

    // Subscribing returns a function to unsubscribe from the query.
    // store them in an array so that we can easily unsubscribe from querys
    // in the dispose method
    subscriberFunctions.add(query.subscribe(_subscriberKey));

    return await query.getResult();
  }

  /// query stream
  /// Includes background fetching
  Stream<QueryState<T>> queryStream<T>({
    required String key,
    required Future<T> Function() queryFn,

    /// [staleDuration] is the amount of time before another fetch happens.
    /// Defaults to `Duration(seconds: 30)` for queries, meaning they will never be re-fetched
    Duration? staleTime = const Duration(seconds: 30),
  }) {
    // get an existing query, or create a new one if it doesn't exist
    final query = _globalCache.getQuery<T>(
        key: key, queryFn: queryFn, staleTime: staleTime);
    // Subscribing returns a function to unsubscribe from the query.
    // store them in an array so that we can easily unsubscribe from querys
    // in the dispose method
    subscriberFunctions.add(query.subscribe(_subscriberKey));
    return query.streamResult();
  }

  /// infinite query

  /// cached mutation

  void dispose() {
    for (var unsubscribe in subscriberFunctions) {
      unsubscribe();
    }
  }
}
