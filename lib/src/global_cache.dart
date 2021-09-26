import 'dart:convert';

import 'package:cached_query/src/query.dart';

import 'models/query_state.dart';

class GlobalCache {
  GlobalCache._();
  static final GlobalCache instance = GlobalCache._();

  ///map to store requests
  Map<String, Query<dynamic>> _cache = {};

  Query<T> getQuery<T>(
      {required dynamic key,
      required Future<T> Function() queryFn,
      Duration? staleTime,
      Duration? cacheTime}) {
    final queryHash = jsonEncode(key);
    var query = _cache[queryHash];

    if (query == null) {
      query = Query<T>(
        key: key,
        staleTime: staleTime,
        queryFn: queryFn,
      );
      _cache[queryHash] = query;
    }
    return query as Query<T>;
  }

  /// Invalidate cache, if no key is passed it will invalidate the whole cache
  void invalidateCache({String? queryHash}) {
    if (queryHash != null) {
      if (_cache.containsKey(queryHash)) {
        _cache.remove(queryHash);
      }
    } else {
      // other wise invalidate the whole cache
      _cache = {};
    }
  }
}
