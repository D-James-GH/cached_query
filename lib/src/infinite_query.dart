part of 'cached_query.dart';

/// [InfiniteQueryManage] is a controller for infinite query's. It holds information
/// on which individual query's make up part of the infinite query.
class InfiniteQuery<T> extends QueryBase<T, InfiniteQueryState<T>> {
  final Future<List<T>> Function(int) queryFn;

  List<String> queryKeys = [];
  List<Object> subscribers = [];
  int currentPage;

  InfiniteQuery({
    required this.queryFn,
    required dynamic key,
    required int initialPage,
    bool ignoreStaleTime = false,
    bool ignoreCacheTime = false,
    required Duration staleTime,
    required Duration cacheTime,
  })  : currentPage = initialPage,
        queryKeys = [key + initialPage.toString()],
        super._internal(
          key: key,
          ignoreStaleTime: ignoreStaleTime,
          ignoreCacheTime: ignoreCacheTime,
          state: InfiniteQueryState<T>(
            currentPage: initialPage,
            timeCreated: DateTime.now(),
          ),
          staleTime: staleTime,
          cacheTime: cacheTime,
        );

  @override
  Future<InfiniteQueryState<T>> get result => _getResult();

  /// returns the combined data of all the [Query]'s in [queryKeys]
  Future<InfiniteQueryState<T>> _getResult({bool forceRefetch = false}) async {
    if (!_stale &&
        !forceRefetch &&
        _state.data != null &&
        _state.data!.isNotEmpty == true &&
        _state.timeCreated.add(_staleTime).isAfter(DateTime.now())) {
      _streamController?.add(_state);
      return _state;
    }

    if (queryKeys.isEmpty) {
      // get initial page
      final initialQuery = await _getQuery().getResult();
      _state = _state.copyWith(data: initialQuery.data);
      _streamController?.add(_state);
      return _state;
    }
    await _getAllQueryResult();
    _streamController?.add(_state);
    return _state;
  }

  Stream<InfiniteQueryState<T>> streamResult() async* {
    if (!_stale &&
        _state.data != null &&
        _state.data!.isNotEmpty == true &&
        _state.timeCreated.add(_staleTime).isAfter(DateTime.now())) {
      _streamController?.add(_state);
      yield _state;
    } else {
      var loadingState =
          _state.copyWith(status: QueryStatus.loading, isFetching: true);
      _streamController?.add(loadingState);
      yield loadingState;
      await _getAllQueryResult();
      _streamController?.add(_state);
      yield _state;
    }
  }

  /// Call this function to automatically increase the page number and fetch it
  Future<InfiniteQueryState<T>> getNextPage() async {
    // add one to current page number and get the query without passing in a key
    currentPage++;
    final newQuery = _getQuery();

    // use the new query to fetch the new data/page
    final QueryState<List<T>?> res = await newQuery.getResult();

    if (res.data == null || res.data?.isEmpty == true) {
      _state = _state.copyWith(hasReachedMax: true);
      return _state;
    }

    // copy the state with the new data appended
    _state = _state.copyWith(data: [...?_state.data, ...res.data!]);
    _streamController?.add(_state);
    return _state;
  }

  void preFetchPages(List<int> pages) {
    for (var page in pages) {
      final queryKey = key + currentPage.toString();
      final query = _globalCache.getQuery<List<T>>(
        key: queryKey,
        queryFn: () => queryFn(page),
        ignoreCacheTime: true,
        ignoreStaleTime: true,
      );
      query._fetch();
    }
  }

  /// get all queries in the query key list
  Future<void> _getAllQueryResult() async {
    final queries = queryKeys.map((k) => _getQuery(queryKey: k)).toList();

    final List<T> data = [];
    await Future.forEach(queries, (Query<List<T>> query) async {
      final QueryState<List<T>?> result =
          await query.getResult(forceRefetch: true);
      if (result.data != null && result.data!.isNotEmpty) {
        data.addAll(result.data!);
      }
    });
    //TODO: add a try catch

    _state = _state.copyWith(
      data: data,
      timeCreated: DateTime.now(),
      isFetching: false,
      status: QueryStatus.success,
    );
  }

  /// [_getQuery] gets a single query from the global cache
  Query<List<T>> _getQuery({String? queryKey}) {
    queryKey ??= key + currentPage.toString();
    var page = currentPage;
    final query = _globalCache.getQuery<List<T>>(
      key: queryKey,
      queryFn: () => queryFn(page),
      ignoreCacheTime: true,
      ignoreStaleTime: true,
    );
    if (!queryKeys.contains(queryKey)) {
      queryKeys.add(queryKey!);
    }

    return query;
  }

  void updateData(List<T> newData) {
    _state = _state.copyWith(data: newData);
    _streamController?.add(_state);
  }

  /// invalidate all queries in the infinite query
  @override
  void invalidateQuery() {
    _stale = true;
    for (final k in queryKeys) {
      _globalCache.invalidateCache(queryHash: k);
    }
  }

  @override
  void deleteQuery() {
    for (final k in queryKeys) {
      _globalCache.deleteCache(queryHash: k);
    }
    queryKeys = [];
  }
}
