part of 'cached_query.dart';

/// {@template query}
/// [Query] is will fetch and cache the response of the [queryFn].
///
/// The [queryFn] must be asynchronous and the result is cached.
///
/// [Query] takes a [key] to identify and store it in the global cache. The [key]
/// can be any serializable data. The [key] is converted to a [String] using
/// [jsonEncode].
///
/// Each [Query] can override the global defaults for [refetchDuration], [cacheDuration],
/// see [CachedQuery.config] for more info.
///
/// Use [forceRefetch] to force the query to be run again regardless of whether
/// the query is stale or not.
///
/// {@endTemplate}
class Query<T> extends QueryBase<T, QueryState<T>> {
  final Future<T> Function() _queryFn;
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
          cacheDuration: cacheDuration,
        );

  /// {@macro query}
  factory Query({
    required Object key,
    required Future<T> Function() queryFn,
    Serializer<T>? serializer,
    Duration? refetchDuration,
    Duration? cacheDuration,
    bool forceRefetch = false,
    bool ignoreRefetchDuration = false,
    bool ignoreCacheDuration = false,
  }) {
    final globalCache = CachedQuery.instance;
    var query = globalCache.getQuery<T>(key);

    // if query is null check the storage
    if (query == null) {
      query = Query<T>._internal(
        key: encodeKey(key),
        refetchDuration: refetchDuration,
        cacheDuration: cacheDuration,
        queryFn: queryFn,
        serializer: serializer,
        ignoreStaleTime: ignoreRefetchDuration,
        ignoreCacheTime: ignoreCacheDuration,
      );
      globalCache._addQuery(query);
    }

    // start the fetching process
    query._getResult(forceRefetch: forceRefetch);

    return query;
  }

  /// Get the result of calling the queryFn.
  ///
  /// If [result] is used when the [stream] has no listeners [result] will start
  /// the delete timer. For full caching functionality see [stream].
  @override
  Future<QueryState<T>> get result {
    _resetDeleteTimer();
    // if there are no other listeners and result has been called schedule
    // a delete.
    if (_streamController?.hasListener != true &&
        _deleteQueryTimer?.isActive != true) {
      _scheduleDelete();
    }
    return _getResult();
  }

  /// Refetch the query immediately.
  ///
  /// Returns the updated [QueryState] and will notify the [stream].
  @override
  Future<QueryState<T>> refetch() => _getResult(forceRefetch: true);

  /// Update the current [Query] data.
  ///
  /// The [updateFn] passes the current query data and must return new data of
  /// type [T]
  void update(UpdateFunc<T> updateFn) {
    final newData = updateFn(_state.data);
    _setState(_state.copyWith(data: newData));
    _emit();
  }

  Future<QueryState<T>> _getResult({bool forceRefetch = false}) async {
    if (!_stale &&
        !forceRefetch &&
        _state.status != QueryStatus.error &&
        _state.data != null &&
        (_ignoreRefetchDuration ||
            _state.timeCreated.add(_staleTime).isAfter(DateTime.now()))) {
      _emit();
      return _state;
    }
    _currentFuture ??= _fetch();
    await _currentFuture;
    _stale = false;
    return _state;
  }

  Future<void> _fetch() async {
    _setState(
      _state.copyWith(
        status: QueryStatus.loading,
        isFetching: true,
      ),
    );
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
    } catch (e) {
      _setState(
        _state.copyWith(
          status: QueryStatus.error,
          isFetching: false,
          error: e,
        ),
      );
    } finally {
      _currentFuture = null;
      _setState(_state.copyWith(isFetching: false));
      _emit();
    }
  }
}
