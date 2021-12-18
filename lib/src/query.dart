part of 'cached_query.dart';

/// [Query] is the controller for an individual query.
/// It is unique to the [key] and is stored in [GlobalCache]
class Query<T> extends QueryBase<T, QueryState<T>> {
  final Future<T> Function() _queryFn;

  /// holds the current fetching future for de-duping requests
  Future<void>? _currentFuture;

  Query._internal({
    required dynamic key,
    required Future<T> Function() queryFn,
    bool ignoreStaleTime = false,
    bool ignoreCacheTime = false,
    Serializer<T>? serializer,
    Duration? refetchDuration,
    Duration? cacheDuration,
  })  : _queryFn = queryFn,
        super._internal(
            key: key,
            state: QueryState<T>(timeCreated: DateTime.now()),
            ignoreCacheTime: ignoreCacheTime,
            ignoreStaleTime: ignoreStaleTime,
            serializer: serializer,
            refetchDuration: refetchDuration,
            cacheDuration: cacheDuration);

  /// get the current result of [_queryFn] either from cache or fetching
  @override
  Future<QueryState<T>> get result {
    _resetDeleteTimer();
    // if there are no other listeners and result has been called schedule
    // garbage collection.
    if (_streamController?.hasListener != true &&
        _deleteTimer?.isActive != true) {
      _scheduleDelete();
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
      if (_state.data == null) {
        // try to get any data from storage if the query has no data
        final dataFromStorage = await _fetchFromStorage();
        _setState(_state.copyWith(
            data: dataFromStorage,
            status: QueryStatus.loading,
            isFetching: true));
      }
      if (!_state.isFetching) {
        _setState(
            _state.copyWith(status: QueryStatus.loading, isFetching: true));
      }

      final res = await _queryFn();

      _setState(
        _state.copyWith(
            data: res,
            timeCreated: DateTime.now(),
            status: QueryStatus.success),
      );
      // save to local storage if exists
      _saveToStorage();
    } catch (e) {
      _setState(_state.copyWith(status: QueryStatus.error, error: e));
    } finally {
      _currentFuture = null;
      _setState(_state.copyWith(isFetching: false));
    }
  }

  /// updates the current cached data.
  void update(T Function(T? oldData) updateFn) {
    final newData = updateFn(_state.data);
    _setState(_state.copyWith(data: newData));
  }
}

class Subscriber {}
