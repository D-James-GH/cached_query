import 'dart:convert';

import 'package:cached_query/src/models/query_state.dart';

import 'global_cache.dart';

class Query<T> {
  final dynamic key;
  final Future<T> Function() queryFn;
  final GlobalCache _globalCache = GlobalCache.instance;
  List<Object> subscribers = [];
  QueryState<T> _queryState = QueryState<T>(timeCreated: DateTime.now());

  final Duration _staleTime;
  Future<void>? currentFuture;

  Query({
    required this.queryFn,
    required this.key,
    Duration? staleTime,
  }) : _staleTime = staleTime ?? const Duration(seconds: 30);

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

  Future<T> getResult() async {
    // if data is not stale
    if (_queryState.data != null &&
        (_staleTime == Duration.zero ||
            _queryState.timeCreated.add(_staleTime).isAfter(DateTime.now()))) {
      return _queryState.data!;
    }
    await fetch();
    // todo handle error
    return _queryState.data!;
  }

  Stream<QueryState<T>> streamResult() async* {
    // if data is not stale just return it
    if (_queryState.timeCreated.add(_staleTime).isAfter(DateTime.now()) &&
        _queryState.data != null) {
      yield _queryState;
    } else {
      yield _queryState.copyWith(
          status: QueryStatus.fetching, isFetching: true);
      await fetch();
      yield _queryState;
    }
  }

  Future<void> fetch() {
    if (currentFuture != null) return currentFuture!;
    currentFuture = _fetchQuery();
    return currentFuture!;
  }

  Future<void> _fetchQuery() async {
    try {
      if (!_queryState.isFetching) {
        _queryState = _queryState.copyWith(
            status: QueryStatus.fetching, isFetching: true);
      }

      final res = await queryFn();

      _queryState = _queryState.copyWith(
          data: res, timeCreated: DateTime.now(), status: QueryStatus.success);
    } catch (e) {
      _queryState = _queryState.copyWith(status: QueryStatus.error);
      rethrow;
    } finally {
      currentFuture = null;
      _queryState = _queryState.copyWith(isFetching: false);
    }
  }
}

class Subscriber {}
