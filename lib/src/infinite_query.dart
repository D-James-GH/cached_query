part of 'cached_query.dart';

/// [InfiniteQueryManage] is a controller for infinite query's. It holds information
/// on which individual query's make up part of the infinite query.
class InfiniteQuery<T> extends QueryBase<T, InfiniteQueryState<T>> {
  final Future<List<T>> Function(int) _queryFn;
  final int _initialPage;
  List<String> _queryKeys = [];
  int _currentPage;
  Future<InfiniteQueryState<T>>? _currentFuture;

  InfiniteQuery({
    required Future<List<T>> Function(int) queryFn,
    required dynamic key,
    required int initialPage,
    bool ignoreStaleTime = false,
    bool ignoreCacheTime = false,
    Serializer<List<T>>? serializer,
    required Duration staleTime,
    required Duration cacheTime,
  })  : _queryFn = queryFn,
        _initialPage = initialPage,
        _currentPage = initialPage,
        _queryKeys = [],
        super._internal(
          key: key,
          ignoreStaleTime: ignoreStaleTime,
          ignoreCacheTime: ignoreCacheTime,
          serializer: serializer,
          state: InfiniteQueryState<T>(
            currentPage: initialPage,
            timeCreated: DateTime.now(),
          ),
          refetchDuration: staleTime,
          cacheDuration: cacheTime,
        );

  @override
  Future<InfiniteQueryState<T>> get result => _getResult();

  /// returns the combined data of all the [Query]'s in [_queryKeys]
  Future<InfiniteQueryState<T>> _getResult({bool forceRefetch = false}) async {
    if (!_stale &&
        !forceRefetch &&
        _state.data != null &&
        _state.data!.isNotEmpty &&
        _state.timeCreated.add(_staleTime).isAfter(DateTime.now())) {
      _streamController?.add(_state);
      return _state;
    }

    if (_queryKeys.isEmpty) {
      // get initial page
      final initialQuery = await _getQuery().getResult();
      _setState(_state.copyWith(data: initialQuery.data));
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

  /// Private fetch function to help with de-duping next page requests.
  Future<InfiniteQueryState<T>> _fetchNextPage() async {
    // add one to the current page to check whether it has data
    final QueryState<List<T>?> res =
        await _getQuery(key: [key, _currentPage + 1]).getResult();
    if (res.data == null || res.data?.isEmpty == true) {
      _setState(_state.copyWith(hasReachedMax: true));
      return _state;
    }

    _currentPage++;
    _setState(_state.copyWith(data: [...?_state.data, ...res.data!]));
    _currentFuture = null;
    return _state;
  }

  void _preFetchPages(List<int> pages) {
    for (final page in pages) {
      final queryKey = key + _currentPage.toString();
      query(
        key: queryKey,
        queryFn: () => _queryFn(page),
        forceRefetch: true,
      );
    }
  }

  /// get all queries in the query key list
  Future<void> _refetchAllQueries() async {
    final queries = _queryKeys.map((k) => _getQuery(key: k)).toList();

    final List<T> data = [];
    await Future.forEach(queries, (Query<List<T>> query) async {
      final QueryState<List<T>?> result =
          await query.getResult(forceRefetch: true);
      if (result.data != null && result.data!.isNotEmpty) {
        data.addAll(result.data!);
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
  Query<List<T>> _getQuery({dynamic key}) {
    key ??= [this.key, _currentPage];
    var page = _currentPage;
    final q = query<List<T>>(
      key: key,
      serializer: _serializer as Serializer<List<T>>,
      queryFn: () => _queryFn(page),
    );
    if (!_queryKeys.contains(q._queryHash)) {
      _queryKeys.add(q._queryHash);
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
      _globalCache.invalidateCache(queryHash: k);
    }
  }

  @override
  void deleteQuery() {
    for (final k in _queryKeys) {
      _globalCache.deleteCache(queryHash: k);
    }
    _queryKeys = [];
    _currentPage = _initialPage;
  }
}
