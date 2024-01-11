part of 'cached_query.dart';

/// On success is called when the query function is executed successfully.
///
/// Passes the returned data.
typedef OnInfiniteQuerySuccessCallback<T> = void Function(T);

/// On success is called when the query function is executed successfully.
///
/// Passes the error through.
typedef OnInfiniteQueryErrorCallback<T> = void Function(dynamic);

/// The result of the [InfiniteQueryFunc] will be cached.
typedef InfiniteQueryFunc<T, A> = Future<T> Function(A);

/// Determines the parameters of the next page in an infinite query.
///
/// Return null if the last page has already been fetch and therefore trigger
/// [InfiniteQueryState.hasReachedMax] to equal `true`.
typedef GetNextArg<T, Arg> = Arg? Function(InfiniteQueryState<T>);

/// {@template infiniteQuery}
///
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
/// Use [revalidateAll] to sequentially refetch all cached pages if the first two
/// pages are not equal.
///
/// Use [forceRevalidateAll] to force the infinite query to refetch all pages
/// when it becomes stale, rather than comparing the first page.
///
/// To run side effects if the query function is successful or not use [onSuccess] and
/// [onError].
///
/// {@endtemplate}
class InfiniteQuery<T, Arg> extends QueryBase<List<T>, InfiniteQueryState<T>> {
  /// On success is called when the query function is executed successfully.
  ///
  /// Passes the returned data.
  final OnQuerySuccessCallback<T>? _onSuccess;

  /// On success is called when the query function is executed successfully.
  ///
  /// Passes the error through.
  final OnQueryErrorCallback<T>? _onError;

  final GetNextArg<T, Arg> _getNextArg;
  final InfiniteQueryFunc<T, Arg> _queryFn;

  /// Whether the Query should always refetch all pages, not just check the first
  /// for changes.
  final bool forceRevalidateAll;

  /// If the fist page has changed then revalidate all pages. Defaults to false.
  final bool revalidateAll;

  @override
  Future<InfiniteQueryState<T>> get result => _getResult();

  /// Get the last page in the [InfiniteQueryState.data]
  T? get lastPage => state.lastPage;

  InfiniteQuery._internal({
    required InfiniteQueryFunc<T, Arg> queryFn,
    required String key,
    required Object unencodedKey,
    required GetNextArg<T, Arg> getNextArg,
    required QueryConfig? config,
    required List<T>? initialData,
    required this.forceRevalidateAll,
    required this.revalidateAll,
    OnQueryErrorCallback<T>? onError,
    OnQuerySuccessCallback<T>? onSuccess,
  })  : _getNextArg = getNextArg,
        _queryFn = queryFn,
        _onSuccess = onSuccess,
        _onError = onError,
        super._internal(
          key: key,
          unencodedKey: unencodedKey,
          config: config,
          state: InfiniteQueryState<T>(
            data: initialData ?? [],
            timeCreated: DateTime.now(),
          ),
        );

  /// {@macro infiniteQuery}
  factory InfiniteQuery({
    required Object key,
    required Future<T> Function(Arg arg) queryFn,
    required GetNextArg<T, Arg> getNextArg,
    List<Arg>? prefetchPages,
    QueryConfig? config,
    List<T>? initialData,
    bool forceRevalidateAll = false,
    bool revalidateAll = false,
    OnQueryErrorCallback<T>? onError,
    OnQuerySuccessCallback<T>? onSuccess,
  }) {
    final globalCache = CachedQuery.instance;
    final queryKey = encodeKey(key);
    var query = globalCache.getQuery(queryKey);
    if (query == null || query is! InfiniteQuery<T, Arg>) {
      query = InfiniteQuery<T, Arg>._internal(
        queryFn: queryFn,
        unencodedKey: key,
        getNextArg: getNextArg,
        forceRevalidateAll: forceRevalidateAll,
        revalidateAll: revalidateAll,
        onError: onError,
        onSuccess: onSuccess,
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
  @override
  void update(UpdateFunc<List<T>> updateFn) {
    final newData = updateFn(_state.data);
    _setState(_state.copyWith(data: newData));
    _emit();
  }

  @override
  Future<InfiniteQueryState<T>> _getResult({bool forceRefetch = false}) async {
    if (!stale &&
        !forceRefetch &&
        _state.status != QueryStatus.error &&
        _state.data != null &&
        _state.data!.isNotEmpty) {
      _emit();
      return _state;
    }

    final shouldRefetch = config.shouldRefetch?.call(this, false) ?? true;
    if (shouldRefetch || _state.status == QueryStatus.initial) {
      _currentFuture ??= _refetch();
      await _currentFuture;
      _staleOverride = false;
    }
    return _state;
  }

  Future<void> _refetch() async {
    if ((_state.data.isNullOrEmpty || _state.status == QueryStatus.initial) &&
        config.storeQuery) {
      // try to get any data from storage if the query has no data
      final dataFromStorage = await _fetchFromStorage();
      if (dataFromStorage != null) {
        _setState(
          _state.copyWith(
            data: dataFromStorage,
            status: QueryStatus.success,
          ),
        );
        _emit();
        final shouldRefetch = config.shouldRefetch?.call(this, true) ?? true;
        if (!shouldRefetch) {
          return;
        }
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
      if (!forceRevalidateAll &&
          _state.data.isNotNullOrEmpty &&
          pageEquality(firstPage, _state.data![0])) {
        // As the first pages are equal assume data hasn't changed
        if (_onSuccess != null) {
          _onSuccess!(firstPage);
        }
        _setState(
          _state.copyWith(
            status: QueryStatus.success,
            timeCreated: DateTime.now(),
          ),
        );
        _emit();
        return;
      }

      var newState = _state.copyWith(
        data: [firstPage],
        lastPage: firstPage,
      );

      // Note: Removed re-fetching all pages if the first page has changed unless force revalidate is on.
      // this was taking too long and didn't seam worth it.
      if (forceRevalidateAll || revalidateAll) {
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
      }

      _setState(
        newState.copyWith(
          status: QueryStatus.success,
          timeCreated: DateTime.now(),
        ),
      );
      if (config.storeQuery) {
        // save to local storage if exists
        _saveToStorage();
      }
    } catch (e, trace) {
      if (_onError != null) {
        _onError!(e);
      }
      // if failed return the previous state
      _setState(
        previousState.copyWith(
          status: QueryStatus.error,
          error: e,
        ),
        trace,
      );
      if (CachedQuery.instance._config.shouldRethrow) {
        rethrow;
      }
    } finally {
      _currentFuture = null;
      _emit();
    }
  }

  Future<void> _fetchNextPage({Arg? arg}) async {
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
      if (_onSuccess != null) {
        _onSuccess!(res);
      }
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
        _saveToStorage();
      }
    } catch (e, trace) {
      if (_onError != null) {
        _onError!(e);
      }
      _setState(
        _state.copyWith(
          status: QueryStatus.error,
          error: e,
        ),
        trace,
      );
      if (CachedQuery.instance._config.shouldRethrow) {
        rethrow;
      }
    } finally {
      _currentFuture = null;
      _emit();
    }
  }

  void _preFetchPages(List<Arg> arguments) async {
    for (final arg in arguments) {
      await _fetchNextPage(arg: arg);
    }
  }
}
