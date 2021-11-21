part of 'cached_query.dart';

/// [Query] is the controller for an individual query.
/// It is unique to the [key] and is stored in [GlobalCache]
class Query<T> extends QueryBase<T, QueryState<T>> {
  final Future<T> Function() _queryFn;

  Query._internal({
    required dynamic key,
    required Future<T> Function() queryFn,
    bool ignoreStaleTime = false,
    bool ignoreCacheTime = false,
    required Duration staleTime,
    required Duration cacheTime,
  })  : _queryFn = queryFn,
        super._internal(
            key: key,
            state: QueryState<T>(timeCreated: DateTime.now()),
            ignoreCacheTime: ignoreCacheTime,
            ignoreStaleTime: ignoreStaleTime,
            staleTime: staleTime,
            cacheTime: cacheTime);

  /// get the current result of [_queryFn] either from cache or fetching
  @override
  Future<QueryState<T>> get result {
    // if the _gcTimer is running reset it
    _resetGC();
    // if there are no other listeners and result has been called schedule
    // garbage collection.
    if (_streamController?.hasListener != true && _gcTimer?.isActive != true) {
      _scheduleGC();
    }
    return getResult(forceRefetch: false);
  }

  /// returns the result of the [_queryFn], either from cache or calling directly
  Future<QueryState<T>> getResult({bool forceRefetch = false}) async {
    if (!_stale &&
        !forceRefetch &&
        _state.data != null &&
        (_ignoreStaleTime ||
            _state.timeCreated.add(_staleTime).isAfter(DateTime.now()))) {
      _streamController?.add(_state);
      return _state;
    }
    await _fetch();
    _stale = false;
    return _state;
  }

  /// [_fetch] de-duplicates request
  Future<void> _fetch() {
    if (_currentFuture != null) return _currentFuture!;
    _currentFuture = _fetchQuery();
    return _currentFuture!;
  }

  /// call the [_queryFn] and return the error or result
  Future<void> _fetchQuery() async {
    try {
      if (!_state.isFetching) {
        _state = _state.copyWith(status: QueryStatus.loading, isFetching: true);
        _streamController?.add(_state);
      }

      final res = await _queryFn();

      _state = _state.copyWith(
          data: res, timeCreated: DateTime.now(), status: QueryStatus.success);
      _streamController?.add(_state);
    } catch (e) {
      _state = _state.copyWith(status: QueryStatus.error);
      _streamController?.add(_state);
      rethrow;
    } finally {
      _currentFuture = null;
      _state = _state.copyWith(isFetching: false);
      _streamController?.add(_state);
    }
  }

  /// updates the current cached data.
  void update(T Function(T? oldData) updateFn) {
    final newData = updateFn(_state.data);
    _state = _state.copyWith(data: newData);
    _streamController?.add(_state);
  }
}

class Subscriber {}
