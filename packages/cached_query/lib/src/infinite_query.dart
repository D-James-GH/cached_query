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
/// Use [forceRevalidateAll] to force the infinite query to refetch all pages
/// when it becomes stale, rather than comparing the first page.
///
/// {@endtemplate infiniteQuery}
class InfiniteQuery<T, A> extends QueryBase<List<T>, InfiniteQueryState<T>> {
  final GetNextArg<T, A> _getNextArg;
  final InfiniteQueryFunc<T, A> _queryFn;
  final bool _forceRevalidateAll;

  @override
  Future<InfiniteQueryState<T>> get result => _getResult();

  /// Get the last page in the [InfiniteQueryState.data]
  T? get lastPage => state.lastPage;

  InfiniteQuery._internal({
    required InfiniteQueryFunc<T, A> queryFn,
    required String key,
    required GetNextArg<T, A> getNextArg,
    required QueryConfig? config,
    required List<T>? initialData,
    required bool forceRevalidateAll,
  })  : _getNextArg = getNextArg,
        _queryFn = queryFn,
        _forceRevalidateAll = forceRevalidateAll,
        super._internal(
          key: key,
          config: config,
          state: InfiniteQueryState<T>(
            data: initialData ?? [],
            timeCreated: DateTime.now(),
          ),
        );

  /// {@macro infiniteQuery}
  factory InfiniteQuery({
    required Object key,
    required Future<T> Function(A arg) queryFn,
    required GetNextArg<T, A> getNextArg,
    List<A>? prefetchPages,
    QueryConfig? config,
    List<T>? initialData,
    bool forceRevalidateAll = false,
  }) {
    final globalCache = CachedQuery.instance;
    final queryKey = encodeKey(key);
    var query = globalCache.getQuery(queryKey);
    if (query == null || query is! InfiniteQuery<T, A>) {
      query = InfiniteQuery<T, A>._internal(
        queryFn: queryFn,
        getNextArg: getNextArg,
        forceRevalidateAll: forceRevalidateAll,
        key: queryKey,
        initialData: initialData,
        config: config,
      );
      globalCache.addQuery(query);
    }

    if (prefetchPages != null) {
      query._preFetchPages(prefetchPages);
    }

    return query;
  }

  /// Get the next page in an [InfiniteQuery] and cache the result.
  Future<InfiniteQueryState<T>?> getNextPage() async {
    if (state.hasReachedMax) return null;
    _currentFuture ??= _fetchNextPage();
    await _currentFuture;
    return state;
  }

  /// Refetch the query immediately.
  ///
  /// Returns the updated [State] and will notify the [stream].
  @override
  Future<InfiniteQueryState<T>> refetch() async {
    _currentFuture ??= _refetch();
    await _currentFuture;
    return state;
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
    _currentFuture ??= _refetch();
    await _currentFuture;
    _stale = false;
    return _state;
  }

  Future<void> _refetch() async {
    if ((_state.data.isNullOrEmpty || _state.status == QueryStatus.initial) &&
        config.storeQuery) {
      // try to get any data from storage if the query has no data
      final dataFromStorage = await _fetchFromStorage() as List<dynamic>?;
      if (dataFromStorage != null) {
        _setState(
          _state.copyWith(
            data: dataFromStorage.cast<T>(),
            status: QueryStatus.success,
          ),
        );
        // Emit the data from storage
        _emit();
      }
    }
    if (state.data.isNullOrEmpty || _state.status == QueryStatus.initial) {
      return _fetchNextPage();
    }
    final previousState = _state.copyWith();
    _setState(_state.copyWith(status: QueryStatus.loading));
    _emit();
    try {
      final initialArg = _getNextArg(
        InfiniteQueryState(
          timeCreated: DateTime.now(),
          data: [],
        ),
      );

      if (initialArg == null) {
        _setState(
          state.copyWith(
            hasReachedMax: true,
            status: QueryStatus.success,
          ),
        );
        _emit();
        return;
      }
      final firstPage = await _queryFn(initialArg);

      // Check first page for changes.
      if (!_forceRevalidateAll &&
          _state.data.isNotNullOrEmpty &&
          pageEquality(firstPage, _state.data![0])) {
        // As the first pages are equal assume data hasn't changed
        _setState(_state.copyWith(status: QueryStatus.success));
        _emit();
        return;
      }

      var newState = _state.copyWith(data: [firstPage]);

      for (int i = 1; i < previousState.length; i++) {
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
      _currentFuture = null;
      _emit();
    }
  }

  Future<void> _fetchNextPage({A? arg}) async {
    final isInitial = state.status == QueryStatus.initial;
    _setState(_state.copyWith(status: QueryStatus.loading));
    _emit();
    try {
      final newSate = isInitial ? state.copyWith(data: []) : state.copyWith();
      // Set the initial arg before getting from storage. Otherwise the storage
      // data will effect the next arg.
      arg ??= _getNextArg(newSate);

      if (arg == null) {
        _setState(
          newSate.copyWith(
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
          data: [...?newSate.data, res],
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
      await _fetchNextPage(arg: arg);
    }
  }
}
