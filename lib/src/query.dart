import 'dart:convert';

import 'global_cache.dart';

enum QueryStatus { fetching, success, error, inital }

class Query<T> {
  final dynamic key;
  final Future<T> Function() queryFn;
  final GlobalCache _globalCache = GlobalCache.instance;
  List<Object> subscribers = [];
  T? _data;
  QueryStatus status = QueryStatus.inital;
  bool isFetching = false;
  DateTime timeCreated;
  Future<void>? currentFuture;

  Query({
    required this.queryFn,
    required this.timeCreated,
    required this.key,
  });

  T? get data => _data;

  void Function() subscribe(subscriber) {
    if (!subscribers.contains(subscriber)) {
      subscribers.add(subscriber);
    }
    return () {
      subscribers = subscribers.where((e) => e != subscriber).toList();
    };
  }

  /// Invalidate cache, if no key is passed it will invalidate the whole cache
  void invalidateCache({dynamic key}) {
    String? queryHash;
    if (key != null) {
      queryHash = jsonEncode(key);
    }
    _globalCache.invalidateCache(queryHash: queryHash);
  }

  Future<void> fetch() {
    if (currentFuture != null) return currentFuture!;
    currentFuture = _fetchQuery();
    return currentFuture!;
  }

  Future<void> _fetchQuery() async {
    try {
      status = QueryStatus.fetching;
      isFetching = true;

      final res = await queryFn();

      _data = res;
      status = QueryStatus.success;
    } catch (e) {
      status = QueryStatus.error;
      rethrow;
    } finally {
      currentFuture = null;
      isFetching = false;
    }
  }
}

class Subscriber {}
