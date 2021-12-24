part of 'cached_query.dart';

/// [InfiniteQuery] is a controller for infinite query's. It holds information
/// on which individual query's make up part of the infinite query.
class InfiniteQuery<T, A> extends QueryBase<T, InfiniteQueryState<T>> {
  final Future<T> Function(A arg) _queryFn;
  final GetNextArg<A, T> _getNextArg;
  final int _initialIndex;
  List<String> _queryKeys = [];
  int _currentIndex;
  Future<InfiniteQueryState<T>>? _currentFuture;

  InfiniteQuery({
    required Future<T> Function(A arg) queryFn,
    required String key,
    required int initialIndex,
    required GetNextArg<A, T> getNextArg,
    bool ignoreRefetchDuration = false,
    bool ignoreCacheDuration = false,
    Serializer<T>? serializer,
    required Duration refetchDuration,
    required Duration cacheDuration,
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

  @override
  Future<InfiniteQueryState<T>> get result => _getResult();

  T? get lastPage {
    if (_state.data.isEmpty) return null;
    return _state.data[_state.data.length - 1];
  }

  Future<InfiniteQueryState<T>> refetch() => _getResult(forceRefetch: true);

  /// returns the combined data of all the [Query]'s in [_queryKeys]
  Future<InfiniteQueryState<T>> _getResult({bool forceRefetch = false}) async {
    if (!_stale &&
        !forceRefetch &&
        _state.data.isNotEmpty &&
        _state.timeCreated.add(_staleTime).isAfter(DateTime.now())) {
      _streamController?.add(_state);
      return _state;
    }

    if (_queryKeys.isEmpty) {
      final pageParam = _getNextArg(_currentIndex, null);
      if (pageParam != null) {
        // get initial page
        final initialQuery = await _getQuery(arg: pageParam)._getResult();
        if (initialQuery.data != null) {
          _setState(_state.copyWith(data: [initialQuery.data!]));
        }
        return _state;
      }

      // initial param was null, indicating there are no more pages, which is an error
      _setState(_state.copyWith(
          error: "Initial argument was null", status: QueryStatus.error));
      return _state;
    }

    await _refetchAllQueries();
    return _state;
  }

  /// Get the next page in an [InfiniteQuery] and cache the result.
  Future<InfiniteQueryState<T>> getNextPage() {
    if (_currentFuture != null) return _currentFuture!;
    _currentFuture = _fetchNextPage();
    return _currentFuture!;
  }

  //TODO: might be unnecessary to de-dupe
  /// Private fetch function to help with de-duping next page requests.
  Future<InfiniteQueryState<T>> _fetchNextPage() async {
    if (_state.hasReachedMax) return _state;
    final nextArg = _getNextArg(_currentIndex, lastPage);
    if (nextArg == null) {
      _setState(_state.copyWith(hasReachedMax: true));
      return _state;
    }
    _currentIndex++;
    // add one to the current page to check whether it has data
    final QueryState<T> query = await _getQuery(
      key: key + (_currentIndex + 1).toString(),
      arg: nextArg,
    )._getResult();
    if (query.data != null) {
      _setState(_state.copyWith(data: [..._state.data, query.data!]));
      _currentFuture = null;
    }

    return _state;
  }

  void _preFetchPages(List<A> arguments) {
    for (final arg in arguments) {
      final queryKey = key + _currentIndex.toString();
      query(
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
    await Future.forEach(queries, (Query<T> query) async {
      final QueryState<T?> result = await query._getResult(forceRefetch: true);
      if (result.data != null) {
        data.add(result.data!);
      }
    });
    _setState(_state.copyWith(
      data: data,
      timeCreated: DateTime.now(),
      isFetching: false,
      status: QueryStatus.success,
    ));
  }

  /// [_getQuery] gets a single query from the global cache
  Query<T> _getQuery({String? key, required A arg}) {
    key ??= this.key + _currentIndex.toString();
    final q = query<T>(
      key: key,
      serializer: _serializer as Serializer<T>?,
      queryFn: () => _queryFn(arg),
    );
    if (!_queryKeys.contains(q.key)) {
      _queryKeys.add(q.key);
    }

    return q;
  }

  /// updates the current cached data.
  void update(List<T> Function(List<T>? oldData) updateFn) {
    final newData = updateFn(_state.data);
    _setState(_state.copyWith(data: newData));
  }

  /// invalidate all queries in the infinite query
  @override
  void invalidateQuery() {
    _stale = true;
    for (final k in _queryKeys) {
      _globalCache.invalidateCache(key: k);
    }
  }

  @override
  void deleteQuery() {
    for (final k in _queryKeys) {
      _globalCache.deleteCache(key: k);
    }
    _globalCache.deleteCache(key: this.key);
    _queryKeys = [];
    _currentIndex = _initialIndex;
  }
}
