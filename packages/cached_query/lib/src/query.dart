part of 'cached_query.dart';

/// The result of the [QueryFunc] will be cached.
typedef QueryFunc<T> = Future<T> Function();

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
/// {@endtemplate}
class Query<T> extends QueryBase<T, QueryState<T>> {
  final Function _queryFn;

  Query._internal({
    required String key,
    required QueryConfig? config,
    required Function queryFn,
    required T? initialData,
  })  : _queryFn = queryFn,
        super._internal(
          config: config,
          key: key,
          state: QueryState<T>(
            timeCreated: DateTime.now(),
            data: initialData,
          ),
        );

  /// {@macro query}
  factory Query({
    required Object key,
    required Future<T> Function() queryFn,
    T? initialData,
    bool forceRefetch = false,
    QueryConfig? config,
  }) {
    final globalCache = CachedQuery.instance;
    var query = globalCache.getQuery(key) as Query<T>?;

    // if query is null check the storage
    if (query == null) {
      query = Query<T>._internal(
        key: encodeKey(key),
        queryFn: queryFn,
        initialData: initialData,
        config: config,
      );
      globalCache.addQuery(query);
    }

    return query;
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

  @override
  Future<QueryState<T>> _getResult({bool forceRefetch = false}) async {
    if (!_stale &&
        !forceRefetch &&
        _state.status != QueryStatus.error &&
        _state.data != null &&
        (_state.timeCreated
            .add(config.refetchDuration)
            .isAfter(DateTime.now()))) {
      _emit();
      return _state;
    }
    _currentFuture ??= _fetch();
    await _currentFuture;
    _stale = false;
    return _state;
  }

  Future<void> _fetch() async {
    _setState(_state.copyWith(status: QueryStatus.loading));
    _emit();
    try {
      if (_state.data == null && config.storeQuery) {
        // try to get any data from storage if the query has no data
        final dynamic dataFromStorage = await _fetchFromStorage();
        if (dataFromStorage is T && dataFromStorage != null) {
          _setState(_state.copyWith(data: dataFromStorage));
          // Emit the data from storage
          _emit();
        }
      }

      final res = await (_queryFn() as Future<T>);
      _setState(
        _state.copyWith(
          data: res,
          timeCreated: DateTime.now(),
          status: QueryStatus.success,
        ),
      );
      if (config.storeQuery) {
        // save to local storage if exists
        _saveToStorage<T>();
      }
    } catch (e) {
      _setState(
        _state.copyWith(
          status: QueryStatus.error,
          error: e,
        ),
      );
      if (config.shouldRethrow) {
        rethrow;
      }
    } finally {
      _currentFuture = null;
      _emit();
    }
  }
}
