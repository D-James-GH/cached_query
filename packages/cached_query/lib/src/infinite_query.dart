part of 'cached_query.dart';

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
/// Set the initial page index with [initialIndex]. Defaults to 0.
/// {@endTemplate infiniteQuery}
class InfiniteQuery<T, A> extends QueryBase<T, InfiniteQueryState<T>> {
  final Future<T> Function(A arg) _queryFn;
  final GetNextArg<A, T> _getNextArg;
  final int _initialIndex;
  List<String> _queryKeys = [];
  int _currentIndex;
  Future<InfiniteQueryState<T>>? _currentNextPageFuture;
  Future<InfiniteQueryState<T>>? _currentFuture;

  InfiniteQuery._internal({
    required Future<T> Function(A arg) queryFn,
    required String key,
    required int initialIndex,
    required GetNextArg<A, T> getNextArg,
    bool ignoreRefetchDuration = false,
    bool ignoreCacheDuration = false,
    Serializer<T>? serializer,
    Duration? refetchDuration,
    Duration? cacheDuration,
  })  : _queryFn = queryFn,
        _initialIndex = initialIndex,
        _currentIndex = initialIndex,
        _getNextArg = getNextArg,
        _queryKeys = [],
        super._internal(
          key: key,
          ignoreRefetchDuration: ignoreRefetchDuration,
          ignoreCacheDuration: ignoreCacheDuration,
          serializer: serializer,
          state: InfiniteQueryState<T>(
            data: [],
            currentPage: initialIndex,
            timeCreated: DateTime.now(),
          ),
          refetchDuration: refetchDuration,
          cacheDuration: cacheDuration,
        );

  /// {@macro infiniteQuery}
  factory InfiniteQuery({
    required Object key,
    required Future<T> Function(A arg) queryFn,
    required GetNextArg<A, T> getNextArg,
    Serializer<T>? serializer,
    bool forceRefetch = false,
    Duration? cacheDuration,
    Duration? refetchDuration,
    int initialIndex = 0,
    List<A>? prefetchPages,
    bool ignoreRefetchDuration = false,
    bool ignoreCacheDuration = false,
  }) {
    final globalCache = CachedQuery.instance;
    final queryKey = encodeKey(key);
    InfiniteQuery<T, A>? infiniteQuery = globalCache.getInfiniteQuery(queryKey);

    if (infiniteQuery == null) {
      infiniteQuery = InfiniteQuery<T, A>._internal(
        queryFn: queryFn,
        ignoreRefetchDuration: ignoreRefetchDuration,
        ignoreCacheDuration: ignoreCacheDuration,
        serializer: serializer,
        getNextArg: getNextArg,
        refetchDuration: refetchDuration,
        cacheDuration: cacheDuration,
        key: queryKey,
        initialIndex: initialIndex,
      );
      globalCache._addInfiniteQuery(infiniteQuery);
    }

    if (prefetchPages != null) {
      infiniteQuery._preFetchPages(prefetchPages);
    }
    infiniteQuery._getResult(forceRefetch: forceRefetch);

    return infiniteQuery;
  }

  @override
  Future<InfiniteQueryState<T>> get result => _getResult();

  /// Get the last page in the [InfiniteQueryState.data]
  T? get lastPage => _state.lastPage;

  @override
  Future<InfiniteQueryState<T>> refetch() => _getResult(forceRefetch: true);

  Future<InfiniteQueryState<T>> _getResult({bool forceRefetch = false}) async {
    if (!_stale &&
        !forceRefetch &&
        _state.status != QueryStatus.error &&
        _state.data.isNotEmpty &&
        _state.timeCreated.add(_staleTime).isAfter(DateTime.now())) {
      _emit();
      return _state;
    }
    _currentFuture ??= _fetch();
    await _currentFuture;
    _stale = false;
    return _state;
  }

  Future<InfiniteQueryState<T>> _fetch() async {
    _setState(_state.copyWith(status: QueryStatus.loading, isFetching: true));
    _emit();
    // if the query is the first page
    if (_queryKeys.isEmpty) {
      final pageParam = _getNextArg(_currentIndex, null);
      if (pageParam != null) {
        // get initial page
        final initialQuery =
            await _getQuery(arg: pageParam)._getResult(forceRefetch: true);
        _setState(
          _state.copyWith(
            data: initialQuery.data != null ? [initialQuery.data!] : [],
            status: initialQuery.status == QueryStatus.error
                ? QueryStatus.error
                : QueryStatus.success,
            isFetching: false,
            timeCreated: DateTime.now(),
            error: initialQuery.error,
          ),
        );
        _stale = false;
        _emit();
        _currentFuture = null;
        return _state;
      }

      // initial param was null, indicating there are no more pages, which is an error
      _setState(
        _state.copyWith(
          error: "Initial argument was null",
          status: QueryStatus.error,
          isFetching: false,
        ),
      );
      _emit();
      _currentFuture = null;
      return _state;
    }

    // not the first time this infinite query has been called
    await _refetchAllQueries();
    _emit();
    _currentFuture = null;
    return _state;
  }

  /// Get the next page in an [InfiniteQuery] and cache the result.
  Future<InfiniteQueryState<T>> getNextPage() {
    if (_currentNextPageFuture != null) return _currentNextPageFuture!;
    _currentNextPageFuture = _fetchNextPage();
    return _currentNextPageFuture!;
  }

  // TODO(Dan): might be unnecessary to de-dupe
  /// Private fetch function to help with de-duping next page requests.
  Future<InfiniteQueryState<T>> _fetchNextPage() async {
    if (_state.hasReachedMax) {
      _emit();
      return _state;
    }
    _setState(_state.copyWith(status: QueryStatus.loading));
    final nextArg = _getNextArg(_currentIndex, lastPage);
    if (nextArg == null) {
      _setState(
        _state.copyWith(
          hasReachedMax: true,
          status: QueryStatus.success,
        ),
      );
      _emit();
      return _state;
    }
    _setState(_state.copyWith(isFetching: true));
    _emit();
    _currentIndex++;
    // add one to the current page to check whether it has data
    final QueryState<T> query = await _getQuery(
      key: key + (_currentIndex + 1).toString(),
      arg: nextArg,
    )._getResult();
    _setState(
      _state.copyWith(
        data: [..._state.data, if (query.data != null) query.data!],
        status: QueryStatus.success,
        isFetching: false,
      ),
    );

    _currentNextPageFuture = null;
    _emit();
    return _state;
  }

  void _preFetchPages(List<A> arguments) {
    for (final arg in arguments) {
      final queryKey = key + _currentIndex.toString();
      Query(
        key: queryKey,
        queryFn: () => _queryFn(arg),
        forceRefetch: true,
      );
    }
  }

  /// get all queries in the query key list
  Future<void> _refetchAllQueries() async {
    final List<Query<T>> queries = [];
    for (final k in _queryKeys) {
      final q = _globalCache.getQuery<T>(k);
      if (q != null) {
        queries.add(q);
      }
    }

    final List<T> data = [];
    var hasError = false;
    await Future.forEach<Query<T>>(queries, (query) async {
      final QueryState<T?> result = await query._getResult(forceRefetch: true);
      if (result.status == QueryStatus.error) {
        hasError = true;
      }
      if (result.data != null) {
        data.add(result.data!);
      }
    });
    _setState(
      _state.copyWith(
        data: data,
        timeCreated: DateTime.now(),
        isFetching: false,
        status: hasError ? QueryStatus.error : QueryStatus.success,
      ),
    );
  }

  /// [_getQuery] gets a single query from the global cache
  Query<T> _getQuery({String? key, required A arg}) {
    key ??= this.key + _currentIndex.toString();
    final q = Query<T>(
      key: key,
      serializer: _serializer,
      queryFn: () => _queryFn(arg),
    );
    if (!_queryKeys.contains(q.key)) {
      _queryKeys.add(q.key);
    }

    return q;
  }

  /// Update the current [InfiniteQuery] data.
  ///
  /// The [updateFn] passes the current query data and must return new data of
  /// type [List<T>]
  void update(List<T> Function(List<T>? oldData) updateFn) {
    final newData = updateFn(_state.data);
    _setState(_state.copyWith(data: newData));
    _emit();
  }

  /// invalidate all queries in the infinite query
  @override
  void invalidateQuery() {
    _stale = true;
    for (final k in _queryKeys) {
      _globalCache.invalidateCache(k);
    }
  }

  @override
  void deleteQuery() {
    for (final k in _queryKeys) {
      _globalCache.deleteCache(k);
    }
    _globalCache.deleteCache(key);
    _queryKeys = [];
    _currentIndex = _initialIndex;
  }
}
