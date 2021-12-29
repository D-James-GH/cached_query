part of 'cached_query.dart';

/// [Query] is the controller for an individual query.
/// It is unique to the [key] and is stored in [GlobalCache]
class Query<T> extends QueryBase<T, QueryState<T>> {
  final Future<T> Function() _queryFn;

  /// holds the current fetching future for de-duping requests
  Future<void>? _currentFuture;

  Query._internal({
    required String key,
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
            ignoreCacheDuration: ignoreCacheTime,
            ignoreRefetchDuration: ignoreStaleTime,
            serializer: serializer,
            refetchDuration: refetchDuration,
            cacheDuration: cacheDuration);

  /// get the current result of [_queryFn] either from cache or fetching
  @override
  Future<QueryState<T>> get result {
    _resetDeleteTimer();
    // if there are no other listeners and result has been called schedule
    // a delete.
    if (_streamController?.hasListener != true &&
        _deleteQueryTimer?.isActive != true) {
      _scheduleDelete();
    }
    return _getResult(forceRefetch: false);
  }

  @override
  Future<QueryState<T>> refetch() => _getResult(forceRefetch: true);

  /// returns the result of the [_queryFn], either from cache or calling directly
  Future<QueryState<T>> _getResult({bool forceRefetch = false}) async {
    if (!_stale &&
        !forceRefetch &&
        _state.status != QueryStatus.error &&
        _state.data != null &&
        (_ignoreStaleTime ||
            _state.timeCreated.add(_staleTime).isAfter(DateTime.now()))) {
      _emit();
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
    _setState(_state.copyWith(
      status: QueryStatus.loading,
      isFetching: true,
    ));
    _emit();
    try {
      if (_state.data == null) {
        // try to get any data from storage if the query has no data
        final dynamic dataFromStorage = await _fetchFromStorage();
        if (dataFromStorage is T && dataFromStorage != null) {
          _setState(_state.copyWith(data: dataFromStorage));
          // Emit the data from storage
          _emit();
        }
      }

      final res = await _queryFn();
      if (res != null) {
        _setState(
          _state.copyWith(
            data: res,
            timeCreated: DateTime.now(),
            isFetching: false,
            status: QueryStatus.success,
          ),
        );
        // save to local storage if exists
        _saveToStorage();
        _setState(_state.copyWith(status: QueryStatus.success));
      }
    } catch (e) {
      _setState(_state.copyWith(
        status: QueryStatus.error,
        error: e,
      ));
    } finally {
      _currentFuture = null;
      _setState(_state.copyWith(isFetching: false));
      _emit();
    }
  }

  /// updates the current cached data.
  void update(T Function(T? oldData) updateFn) {
    final newData = updateFn(_state.data);
    _setState(_state.copyWith(data: newData));
    _emit();
  }
}

class Subscriber {}
