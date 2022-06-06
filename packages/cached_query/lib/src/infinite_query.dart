part of 'cached_query.dart';

/// The result of the [InfiniteQueryFunc] will be cached.
typedef InfiniteQueryFunc<T, A> = Future<T> Function(A);

/// Determines the parameters of the next page in an infinite query.
///
/// Return null if the last page has already been fetch and therefore trigger
/// [InfiniteQueryState.hasReachedMax] to equal `true`.
typedef GetNextArg<T, A> = A? Function(InfiniteQueryState<T>);

/// {@template infiniteQuery}
/// [InfiniteQuery] caches a series of [Query]'s for use in an infinite list.
///
/// The [queryFn] must be asynchronous and the result is cached.
///
/// [InfiniteQuery] takes a [key] to identify and store it in the global cache.
/// The [key] can be any serializable data. The [key] is converted to a [String]
/// using [jsonEncode].
///
/// Each [InfiniteQuery] can override the global defaults for [refetchDuration]
/// and [cacheDuration], see [CachedQuery.config] for more info.
///
/// Use [forceRefetch] to force the query to be run again regardless of whether
/// the query is stale or not.
///
/// Use [prefetchPages] to fetch multiple pages on first call and use
/// [initialIndex] to set the initial page of the query.
///
/// {@endtemplate infiniteQuery}
class InfiniteQuery<T, A> extends QueryBase<List<T>, InfiniteQueryState<T>> {
  final GetNextArg<T, A> _getNextArg;
  final InfiniteQueryFunc<T, A> _queryFn;
  Future<void>? _refetchFuture;

  @override
  Future<InfiniteQueryState<T>> get result => _getResult();

  /// Get the last page in the [InfiniteQueryState.data]
  T? get lastPage => state.lastPage;

  InfiniteQuery._internal({
    required InfiniteQueryFunc<T, A> queryFn,
    required super.key,
    required GetNextArg<T, A> getNextArg,
    super.config,
  })  : _getNextArg = getNextArg,
        _queryFn = queryFn,
        super._internal(
          state: InfiniteQueryState<T>(
            data: [],
            timeCreated: DateTime.now(),
          ),
        );

  /// {@macro infiniteQuery}
  factory InfiniteQuery({
    required Object key,
    required Future<T> Function(A arg) queryFn,
    required GetNextArg<T, A> getNextArg,
    bool forceRefetch = false,
    List<A>? prefetchPages,
    QueryConfig? config,
  }) {
    final globalCache = CachedQuery.instance;
    final queryKey = encodeKey(key);
    var query = globalCache.getQuery(queryKey);
    if (query == null || query is! InfiniteQuery<T, A>) {
      query = InfiniteQuery<T, A>._internal(
        queryFn: queryFn,
        getNextArg: getNextArg,
        key: queryKey,
        config: config,
      );
      globalCache._addQuery(query);
      query._getResult(forceRefetch: forceRefetch);
    }

    if (prefetchPages != null) {
      query._preFetchPages(prefetchPages);
    }

    return query;
  }

  /// Get the next page in an [InfiniteQuery] and cache the result.
  Future<InfiniteQueryState<T>?> getNextPage() async {
    if (state.hasReachedMax) return null;
    _currentFuture ??= _fetch();
    await _currentFuture;
    return state;
  }

  /// Refetch the query immediately.
  ///
  /// Returns the updated [State] and will notify the [stream].
  @override
  Future<InfiniteQueryState<T>> refetch() async {
    _refetchFuture ??= _fetchAll();
    await _refetchFuture;
    return state;
  }

  /// Delete the query and query key from cache
  @override
  void deleteQuery() {
    _globalCache.deleteCache(key);
  }

  /// Update the current [InfiniteQuery] data.
  ///
  /// The [updateFn] passes the current query data and must return new data of
  /// type [T]
  void update(List<T> Function(List<T>?) updateFn) {
    final newData = updateFn(_state.data);
    _setState(_state.copyWith(data: newData));
    _emit();
  }

  @override
  Future<InfiniteQueryState<T>> _getResult({bool forceRefetch = false}) async {
    if (!_stale &&
        !forceRefetch &&
        _state.status != QueryStatus.error &&
        _state.data != null &&
        _state.data!.isNotEmpty &&
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

  Future<void> _fetchAll() async {
    final previousState = _state.copyWith();
    _setState(_state.copyWith(status: QueryStatus.loading));
    _emit();
    try {
      var newState = _state.copyWith(data: []);
      for (int i = 0; i < previousState.length; i++) {
        final arg = _getNextArg(newState);
        if (arg == null) {
          newState = newState.copyWith(hasReachedMax: true);
          break;
        }
        final res = await _queryFn(arg);
        newState = newState.copyWith(
          data: res != null ? [...?newState.data, res] : newState.data,
          lastPage: res,
        );
      }
      _setState(
        newState.copyWith(
          status: QueryStatus.success,
          timeCreated: DateTime.now(),
        ),
      );
      if (config.storeQuery) {
        // save to local storage if exists
        _saveToStorage<List<T>>();
      }
    } catch (e) {
      // if failed return the previous state
      _setState(
        previousState.copyWith(
          status: QueryStatus.error,
          error: e,
        ),
      );
      if (CachedQuery.instance._config.shouldRethrow) {
        rethrow;
      }
    } finally {
      _refetchFuture = null;
      _emit();
    }
  }

  Future<void> _fetch({A? arg}) async {
    _setState(_state.copyWith(status: QueryStatus.loading));
    _emit();
    try {
      if (_state.data.isNullOrEmpty && config.storeQuery) {
        // try to get any data from storage if the query has no data
        final dynamic dataFromStorage = await _fetchFromStorage();
        if (dataFromStorage != null) {
          _setState(_state.copyWith(data: dataFromStorage as List<T>));
          // Emit the data from storage
          _emit();
        }
      }

      arg ??= _getNextArg(state);
      if (arg == null) {
        _setState(
          state.copyWith(
            hasReachedMax: true,
            status: QueryStatus.success,
          ),
        );
        _emit();
        return;
      }

      final res = await _queryFn(arg);
      _setState(
        _state.copyWith(
          data: [...?state.data, res],
          lastPage: res,
          timeCreated: DateTime.now(),
          status: QueryStatus.success,
        ),
      );
      if (config.storeQuery) {
        // save to local storage if exists
        _saveToStorage<List<T>>();
      }
    } catch (e) {
      _setState(
        _state.copyWith(
          status: QueryStatus.error,
          error: e,
        ),
      );
      if (CachedQuery.instance._config.shouldRethrow) {
        rethrow;
      }
    } finally {
      _currentFuture = null;
      _emit();
    }
  }

  void _preFetchPages(List<A> arguments) async {
    for (final arg in arguments) {
      await _fetch(arg: arg);
    }
  }
}
