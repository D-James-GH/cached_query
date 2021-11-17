import 'dart:async';

import 'package:cached_query/src/models/query.dart';
import 'package:flutter/cupertino.dart';

import 'global_cache.dart';

/// [QueryManager] is the controller for an individual query.
/// It is unique to the [key] and is stored in [GlobalCache]
class QueryManager<T> {
  final dynamic key;
  final String queryHash;
  final Future<T> Function() queryFn;
  final GlobalCache _globalCache = GlobalCache.instance;
  final Duration staleTime;
  final Duration cacheTime;
  final bool ignoreStaleTime;
  final bool ignoreCacheTime;
  bool stale = false;
  Future<void>? currentFuture;
  Timer? _gcTimer;
  StreamController<Query<T>>? _streamController;
  List<Object> subscribers = [];
  late Query<T> _state;

  @visibleForTesting
  Timer? get gcTimer => _gcTimer;
  Query<T> get state => _state;

  QueryManager({
    required this.queryHash,
    required this.queryFn,
    required this.key,
    this.ignoreStaleTime = false,
    this.ignoreCacheTime = false,
    required this.staleTime,
    required this.cacheTime,
  }) {
    _state = Query<T>(timeCreated: DateTime.now());
  }

  /// returns the result of the [queryFn], either from cache or calling directly
  Future<Query<T?>> getResult({bool forceRefetch = false}) async {
    if (!stale &&
        !forceRefetch &&
        _state.data != null &&
        (ignoreStaleTime ||
            _state.timeCreated.add(staleTime).isAfter(DateTime.now()))) {
      _streamController?.add(_state);
      return _state;
    }
    await fetch();
    stale = false;
    return _state;
  }

  /// creates an async generator which will yield the result of [queryFn] and
  /// call it again in the background if the current data is stale.
  /// Completes after any background fetches are complete
  Stream<Query<T>> streamResult({bool forceRefetch = false}) async* {
    // if data is not stale just return it
    if (!stale &&
        _state.data != null &&
        (ignoreStaleTime ||
            _state.timeCreated.add(staleTime).isAfter(DateTime.now()))) {
      yield _state;
    } else {
      _state = _state.copyWith(status: QueryStatus.loading, isFetching: true);
      _streamController?.add(_state);
      yield _state;
      await fetch();
      stale = false;
      yield _state;
    }
  }

  /// creates a [StreamController] that will update whenever the [Query] state
  /// changes.
  Stream<Query<T>> createStream() {
    if (_streamController != null) {
      return _streamController!.stream;
    }
    _streamController = StreamController.broadcast(
        onListen: () => _streamController!.add(_state),
        onCancel: () {
          _streamController!.close();
          _streamController = null;
        });
    return _streamController!.stream;
  }

  /// [fetch] de-duplicates request, in-case multiple requests come in at once.
  Future<void> fetch() {
    if (currentFuture != null) return currentFuture!;
    currentFuture = _fetchQuery();
    return currentFuture!;
  }

  /// call the [queryFn] and return the error or result
  Future<void> _fetchQuery() async {
    try {
      if (!_state.isFetching) {
        _state = _state.copyWith(status: QueryStatus.loading, isFetching: true);
        _streamController?.add(_state);
      }

      final res = await queryFn();

      _state = _state.copyWith(
          data: res, timeCreated: DateTime.now(), status: QueryStatus.success);
      _streamController?.add(_state);
    } catch (e) {
      _state = _state.copyWith(status: QueryStatus.error);
      _streamController?.add(_state);
      rethrow;
    } finally {
      currentFuture = null;
      _state = _state.copyWith(isFetching: false);
      _streamController?.add(_state);
    }
  }

  /// updates the current cached data.
  void updateData(T newData) {
    _state = _state.copyWith(data: newData);
    _streamController?.add(_state);
  }

  /// add a [Subscriber] to this query.
  void Function() subscribe(subscriber) {
    if (!subscribers.contains(subscriber)) {
      subscribers.add(subscriber);
    }
    unScheduleGC();

    return () => unsubscribe(subscriber);
  }

  /// remove a [Subscriber] from this query. If removing the last subscriber schedule
  /// a garbage collection.
  void unsubscribe(Subscriber subscriber) {
    subscribers = subscribers.where((e) => e != subscriber).toList();
    if (subscribers.isEmpty) {
      scheduleGC();
    }
  }

  /// After the [cacheTime] is up remove the query from the [GlobalCache]
  void scheduleGC() {
    if (!ignoreCacheTime) {
      _gcTimer = Timer(cacheTime, () => deleteQuery());
    }
  }

  /// Cancel the garbage collection if another subscriber is added
  void unScheduleGC() {
    if (_gcTimer?.isActive == true) {
      _gcTimer!.cancel();
    }
  }

  /// mark as stale so will force a fetch next time the query is accessed
  void invalidateQuery() {
    stale = true;
  }

  /// delete the query and query key from cache
  void deleteQuery() {
    _globalCache.deleteCache(queryHash: queryHash);
  }
}

class Subscriber {}
