part of 'cached_query.dart';

/// The result of the [InfiniteQueryFunc] will be cached.
typedef InfiniteQueryFunc<T, A> = Future<T> Function(A pageArgs);

/// Determines the parameters of the next page in an infinite query.
///
/// Return null if the last page has already been fetch and therefore trigger
/// [InfiniteQueryStatus.hasReachedMax] to equal `true`.
typedef GetNextArg<T, Arg> = Arg? Function(InfiniteQueryStatus<T, Arg> state);

/// The fetch direction of an infinite query.
enum InfiniteQueryDirection {
  ///
  forward,

  ///
  backward;

  /// Fetch forward
  bool get isForward => this == InfiniteQueryDirection.forward;

  /// Fetch backward
  bool get isBackward => this == InfiniteQueryDirection.backward;
}

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
class InfiniteQuery<T, Arg>
    extends QueryBase<List<T>, InfiniteQueryStatus<T, Arg>> {
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

  /// If the fist page has changed then revalidate all pages. Defaults to false. Otherwise replace current data with first page only.
  final bool revalidateAll;

  final List<T>? _initialData;

  @override
  Future<InfiniteQueryStatus<T, Arg>> get result => _getResult();

  /// Get the last page in the [InfiniteQueryStatus.data]
  T? get lastPage => state.lastPage;

  InfiniteQuery._internal({
    required InfiniteQueryFunc<T, Arg> queryFn,
    required super.key,
    required super.unencodedKey,
    required GetNextArg<T, Arg> getNextArg,
    required super.config,
    required List<T>? initialData,
    required this.forceRevalidateAll,
    required this.revalidateAll,
    required super.cache,
    OnQueryErrorCallback<T>? onError,
    OnQuerySuccessCallback<T>? onSuccess,
  })  : _getNextArg = getNextArg,
        _queryFn = queryFn,
        _onSuccess = onSuccess,
        _initialData = initialData,
        _onError = onError,
        super._internal(
          state: InfiniteQueryInitial<T, Arg>(
            data: initialData,
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
    CachedQuery? cache,
  }) {
    cache = cache ?? CachedQuery.instance;
    final queryKey = encodeKey(key);
    var query = cache.getQuery(queryKey);
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
        cache: cache,
      );
      cache.addQuery(query);
    }

    if (prefetchPages != null) {
      query._preFetchPages(prefetchPages);
    }

    return query;
  }

  /// Get the next page in an [InfiniteQuery] and cache the result.
  Future<InfiniteQueryStatus<T, Arg>?> getNextPage() async {
    final arg = _getNextArg(state);
    if (arg == null) return null;
    _currentFuture ??= _fetch(direction: InfiniteQueryDirection.forward);
    await _currentFuture;
    return state;
  }

  /// Refetch the query immediately.
  ///
  /// Returns the updated [StateBase] and will notify the [stream].
  @override
  Future<InfiniteQueryStatus<T, Arg>> refetch() async {
    _currentFuture ??= _fetch();
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
    final newState = _state.copyWithData(newData);

    _setState(newState);
    if (config.storeQuery) {
      // save to local storage if exists
      _saveToStorage();
    }
    _emit();
  }

  /// True if there are no more pages available to fetch.
  ///
  /// Calculated using [GetNextArg], if it has returned null then this is true.
  bool hasReachedMax() {
    return _getNextArg(_state) == null;
  }

  @override
  Future<InfiniteQueryStatus<T, Arg>> _getResult({
    bool forceRefetch = false,
  }) async {
    final hasData = _state.data != null && _state.data!.isNotEmpty;
    if (!stale && !forceRefetch && !_state.isError && hasData) {
      _emit();
      return _state;
    }

    final shouldRefetch = config.shouldRefetch?.call(this, false) ?? true;
    if (shouldRefetch || _state.isInitial) {
      _currentFuture ??= _fetch(
        initialArg: _state.isInitial ? _getInitialArg() : null,
      );
      await _currentFuture;
      _staleOverride = false;
    }
    return _state;
  }

  Future<void> _fetch({
    InfiniteQueryDirection? direction,
    Arg? initialArg,
  }) async {
    final getFromStorage = state.isInitial && config.storeQuery;

    _setState(
      InfiniteQueryLoading(
        isInitialFetch: state.isInitial,
        isFetchingNextPage: direction?.isForward ?? false,
        isRefetching: direction == null,
        data: _state.data,
        pageParams: _state.pageParams,
        timeCreated: _state.timeCreated,
      ),
    );

    if (getFromStorage) {
      try {
        final dataFromStorage = await _fetchFromStorage();
        if (dataFromStorage != null) {
          _setState(
            _state.copyWithData(dataFromStorage),
          );
          final shouldRefetch = config.shouldRefetch?.call(this, true) ?? true;
          if (!shouldRefetch) {
            _setState(
              InfiniteQuerySuccess(
                timeCreated: _state.timeCreated,
                data: _state.data,
                pageParams: _state.pageParams ?? [],
              ),
            );
            return;
          }
        }
      } catch (e, trace) {
        _setState(
          InfiniteQueryError(
            error: e,
            stackTrace: trace,
            timeCreated: _state.timeCreated,
            data: _state.data,
            pageParams: _state.pageParams,
          ),
        );
      }
    }
    try {
      if (direction == null) {
        final arg = _getInitialArg();
        if (arg == null) {
          return;
        }
        final firstPage = await _fetchPage(arg);

        // Check first page for changes.
        if (!forceRevalidateAll &&
            _state.data.isNotNullOrEmpty &&
            pageEquality(firstPage, _state.data![0])) {
          // As the first pages are equal assume data hasn't changed
          _onSuccess?.call(firstPage);
          _setState(
            InfiniteQuerySuccess(
              timeCreated: DateTime.now(),
              data: _state.data,
              pageParams: _state.pageParams ?? [],
            ),
          );
          return;
        }

        InfiniteQuerySuccess<T, Arg> newState = InfiniteQuerySuccess(
          pageParams: [arg],
          timeCreated: _state.timeCreated,
          data: [firstPage],
        );

        // Note: Removed re-fetching all pages if the first page has changed unless force revalidate is on.
        // this was taking too long and didn't seam worth it.
        if (forceRevalidateAll || revalidateAll) {
          for (int i = 1; i < (_state.data ?? []).length; i++) {
            final arg = _getNextArg(newState);
            if (arg == null) {
              break;
            }
            final res = await _queryFn(arg);
            newState = newState.copyWithData([...?newState.data, res]);
          }
        }

        _setState(
          InfiniteQuerySuccess(
            timeCreated: DateTime.now(),
            data: newState.data,
            pageParams: newState.pageParams,
          ),
        );
      } else {
        final arg =
            initialArg ?? (direction.isForward ? _getNextArg(_state) : null);
        if (arg == null) {
          return;
        }

        final res = await _fetchPage(arg);

        final (data, pageParams) = switch (direction) {
          InfiniteQueryDirection.forward => (
              [...?_state.data, res],
              [...?_state.pageParams, arg]
            ),
          InfiniteQueryDirection.backward => (
              [res, ...?_state.data],
              [arg, ...?_state.pageParams]
            ),
        };

        _setState(
          InfiniteQuerySuccess(
            timeCreated: DateTime.now(),
            data: data,
            pageParams: pageParams,
          ),
        );
      }

      if (config.storeQuery) {
        _saveToStorage();
      }
    } catch (e, trace) {
      _onError?.call(e);
      _setState(
        InfiniteQueryError(
          error: e,
          stackTrace: trace,
          timeCreated: _state.timeCreated,
          data: _state.data,
          pageParams: _state.pageParams,
        ),
      );
      if (CachedQuery.instance._config.shouldRethrow) {
        rethrow;
      }
    }
  }

  Future<T> _fetchPage(Arg arg) async {
    final res = await _queryFn(arg);
    if (_onSuccess != null) {
      _onSuccess!(res);
    }
    return res;
  }

  Arg? _getInitialArg() {
    return _getNextArg(
      InfiniteQueryInitial(
        timeCreated: DateTime.now(),
        data: this._initialData,
      ),
    );
  }

  void _preFetchPages(List<Arg> arguments) async {
    for (final arg in arguments) {
      await _fetch(
        initialArg: arg,
        direction: InfiniteQueryDirection.forward,
      );
    }
  }
}
