import 'package:cached_query/src/global_cache.dart';
import './query.dart';

import 'models/cached_object.dart';

/// Memory cache for api requests. Includes a default time out of 1 hour.
class CachedRepository {
  final Duration defaultStaleDuration;
  final Subscriber _subscriberKey = Subscriber();
  final GlobalCache _globalCache = GlobalCache.instance;
  final List<void Function()> subscriberFunctions = [];

  CachedRepository({this.defaultStaleDuration = const Duration(hours: 1)});

  /// cached request
  /// Will simply return the response to the [queryFn] and throw/rethrow if an
  /// error occurs. For more complicated queries with state and background
  /// fetching use [queryStream]
  Future<T> query<T>({
    required String key,
    required Future<T> Function() queryFn,
    Duration? staleDuration,
  }) async {
    staleDuration ??= defaultStaleDuration;
    final query = _globalCache.getQuery<T>(key: key, queryFn: queryFn);

    // Subscribing returns a function to unsubscribe from the query.
    // store them in an array so that we can easily unsubscribe from querys
    // in the dispose method
    subscriberFunctions.add(query.subscribe(_subscriberKey));

    await query.fetch();

    return query.data;
  }

  /// query stream

  /// infinite query

  /// cached mutation

  void dispose() {
    for (var unsubscribe in subscriberFunctions) {
      unsubscribe();
    }
  }
}
