part of '_query.dart';

/// The result of the [InfiniteQueryFunc] will be cached.
typedef InfiniteQueryFunc<T, A> = Future<T> Function(A pageArgs);

/// Determines the parameters of the next page in an infinite query.
///
/// Return null if the last page has already been fetch and therefore trigger
/// [InfiniteQueryStatus.hasNextPage] to equal `false`.
typedef GetNextArg<T, Arg> = Arg? Function(InfiniteQueryData<T, Arg>? state);

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
/// Each [InfiniteQuery] can override the global defaults for [staleDuration]
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
final class InfiniteQuery<T, Arg>
    extends Cacheable<InfiniteQueryStatus<T, Arg>> {
  /// {@macro infiniteQuery}
  factory InfiniteQuery({
    required Object key,
    required Future<T> Function(Arg arg) queryFn,
    required GetNextArg<T, Arg> getNextArg,
    GetNextArg<T, Arg>? getPrevArg,
    int? prefetchPages,
    QueryConfig<InfiniteQueryData<T, Arg>>? config,
    InfiniteQueryData<T, Arg>? initialData,
    OnQueryErrorCallback? onError,
    OnQuerySuccessCallback<InfiniteQueryData<T, Arg>>? onSuccess,
    CachedQuery? cache,
    OnPageRefetched<T, Arg>? onPageRefetched,
  }) {
    assert(
      (prefetchPages ?? 0) >= 0,
      "Prefetch pages must be greater than or equal to 0",
    );

    cache = cache ?? CachedQuery.instance;
    final existingCache = cache.getQuery(key);

    assert(
      existingCache == null ||
          existingCache is InfiniteQuery<T, Arg> ||
          existingCache is Query<InfiniteQueryData<T, Arg>>,
      "A query with the same key already exists with a different type: ${existingCache.runtimeType}",
    );

    config ??= QueryConfig<InfiniteQueryData<T, Arg>>();
    config = config.mergeWithGlobal(cache.defaultConfig);

    final encodedKey = encodeKey(key);

    // ignore: prefer_function_declarations_over_variables
    final createFetchFn = () => InfiniteFetch<T, Arg>(
          getNextArg: getNextArg,
          getPrevArg: getPrevArg,
          onPageRefetched: onPageRefetched,
          queryFn: queryFn,
          initialArg: getNextArg(initialData),
        );

    final controller = switch (existingCache) {
      InfiniteQuery<T, Arg>(:final _controller) => _controller,
      Query<InfiniteQueryData<T, Arg>>(:final _controller) => _controller,
      _ => QueryController<InfiniteQueryData<T, Arg>>(
          cache: cache,
          key: encodedKey,
          unencodedKey: key,
          initialData: Option.fromNullable(initialData),
          onFetch: createFetchFn(),
          config: config,
        ),
    };

    if (existingCache != null &&
        existingCache is InfiniteQuery<T, Arg> &&
        config == existingCache.config) {
      return existingCache;
    }

    final query = InfiniteQuery<T, Arg>._internal(
      controller: controller,
      config: config,
      getPrevArg: getPrevArg,
      getNextArg: getNextArg,
      onError: onError,
      onSuccess: onSuccess,
    );

    final shouldUpdateController =
        controller.onFetch is EmptyFetchFunction<InfiniteQueryData<T, Arg>>;

    cache.addQuery(query);

    if (shouldUpdateController) {
      controller.updateConfig(
        fetchFn: createFetchFn(),
      );
    }

    if (controller._config != config) {
      controller.updateConfig(config: config);
    }

    if (prefetchPages != null && controller.stateNotifier.value.data.isNone) {
      controller.fetch(
        ignoreStale: true,
        options: InfiniteFetchOptions(prefetchPages: prefetchPages),
      );
    }

    return query;
  }

  InfiniteQuery._internal({
    required GetNextArg<T, Arg> getNextArg,
    required QueryController<InfiniteQueryData<T, Arg>> controller,
    required this.config,
    required GetNextArg<T, Arg>? getPrevArg,
    OnQueryErrorCallback? onError,
    OnQuerySuccessCallback<InfiniteQueryData<T, Arg>>? onSuccess,
  })  : _getNextArg = getNextArg,
        _getPrevArg = getPrevArg,
        _onSuccess = onSuccess,
        _onError = onError,
        _controller = controller {
    _state = InfiniteQueryStatus.initial(
      timeCreated: controller.stateNotifier.value.timeCreated,
      data: controller.stateNotifier.value.data.valueOrNull,
    );
    _stateSubject = BehaviorSubject.seeded(
      state,
      onListen: () {
        controller
          ..registerQuery(this)
          ..fetch(options: InfiniteFetchOptions());
      },
      onCancel: () {
        controller.removeRegisteredQuery(this);
      },
      sync: true,
    );
    _init();
  }

  @override
  final QueryConfig<InfiniteQueryData<T, Arg>> config;

  @override
  String get key => _controller.key;

  @override
  Object get unencodedKey => _controller.unencodedKey;

  late InfiniteQueryStatus<T, Arg> _state;
  @override
  InfiniteQueryStatus<T, Arg> get state => _state;

  @override
  Stream<InfiniteQueryStatus<T, Arg>> get stream => _stateSubject.stream;

  @override
  bool get stale {
    return _controller.isStaleOrInvalidated(config.staleDuration);
  }

  @override
  bool get hasListener => _stateSubject.hasListener;

  final OnQuerySuccessCallback<InfiniteQueryData<T, Arg>>? _onSuccess;
  final OnQueryErrorCallback? _onError;

  final QueryController<InfiniteQueryData<T, Arg>> _controller;
  late final BehaviorSubject<InfiniteQueryStatus<T, Arg>> _stateSubject;
  final GetNextArg<T, Arg> _getNextArg;
  final GetNextArg<T, Arg>? _getPrevArg;

  @override
  Future<InfiniteQueryStatus<T, Arg>> fetch() async {
    if (!stale) {
      return state;
    }
    _controller.registerQuery(this);
    await _controller.fetch(options: InfiniteFetchOptions());
    if (!hasListener) {
      _controller.removeRegisteredQuery(this);
    }

    if (state case InfiniteQueryError(:final stackTrace, :final error)
        when config.shouldRethrow) {
      Error.throwWithStackTrace(error as Object, stackTrace);
    }

    return state;
  }

  /// Fetch the query as a future.
  @Deprecated("Use fetch() instead.")
  Future<InfiniteQueryStatus<T, Arg>> get result => fetch();

  /// True if there are no more pages available to fetch.
  ///
  /// Calculated using [GetNextArg], if it has returned null then this is true.
  @Deprecated(
    "Use hasNextPage() instead. Since adding previous page fetching, hasReachedMax is less clear.",
  )
  bool hasReachedMax() {
    return _getNextArg(_stateSubject.valueOrNull?.data) == null;
  }

  /// True if there is a next page available to fetch.
  bool hasNextPage() {
    return _getNextArg(_stateSubject.valueOrNull?.data) != null;
  }

  /// True if there is a previous page available to fetch.
  bool hasPreviousPage() {
    if (_getPrevArg == null) {
      return false;
    }
    return _getPrevArg!(_stateSubject.valueOrNull?.data) != null;
  }

  /// Update the current query data.
  void update(UpdateFunc<InfiniteQueryData<T, Arg>> updateFn) {
    _controller.update(updateFn);
  }

  /// Set the current query data.
  void setData(InfiniteQueryData<T, Arg> data) {
    return _controller.setData(data);
  }

  @override
  Future<InfiniteQueryStatus<T, Arg>> refetch() async {
    await invalidate(
      refetchInactive: true,
      // ignore: avoid_redundant_argument_values
      refetchActive: true,
    );
    return _state;
  }

  /// Get the next page in an [InfiniteQuery] and cache the result.
  Future<InfiniteQueryStatus<T, Arg>?> getNextPage() async {
    await _controller.fetch(
      ignoreStale: true,
      options: InfiniteFetchOptions(direction: InfiniteQueryDirection.forward),
    );
    return _state;
  }

  /// Get the previous page in an [InfiniteQuery] and cache the result.
  Future<InfiniteQueryStatus<T, Arg>?> getPreviousPage() async {
    assert(
      _getPrevArg != null,
      "getPreviousPage can only be used if getPrevArg is provided to the InfiniteQuery",
    );
    await _controller.fetch(
      ignoreStale: true,
      options: InfiniteFetchOptions(direction: InfiniteQueryDirection.backward),
    );
    return _state;
  }

  @override
  void deleteQuery({bool deleteStorage = false}) {
    _controller.deleteQuery(deleteStorage: deleteStorage);
  }

  @override
  Future<void> invalidate({
    bool refetchActive = true,
    bool refetchInactive = false,
  }) async {
    return _controller.invalidate(
      refetchActive: refetchActive,
      refetchInactive: refetchInactive,
      options: InfiniteFetchOptions(),
    );
  }

  @override
  Future<void> dispose() async {
    await _controller.dispose();
    await _stateSubject.close();
  }

  void _setState(
    InfiniteQueryStatus<T, Arg> state, {
    required bool notifyObservers,
  }) {
    if (notifyObservers) {
      final observers = _controller._cache.observers;
      for (final observer in observers) {
        observer.onChange(this, state);
        if (state case InfiniteQueryError(:final stackTrace)) {
          observer.onError(this, stackTrace);
        }
      }
    }
    _state = state;

    final newInterval = config.pollingInterval?.call(_state);
    if (_pollingInterval != newInterval) {
      _pollingTimer?.cancel();
      _pollingInterval = newInterval;
      if (_pollingInterval != null) {
        _pollingTimer = _createPollingTimer(_pollingInterval!);
      }
    }

    _stateSubject.add(state);
  }

  Timer? _pollingTimer;
  Duration? _pollingInterval;
  void _init() {
    _controller.stateNotifier.addListener(_handleAction);

    _pollingInterval = config.pollingInterval?.call(_state);
    if (_pollingInterval != null) {
      _pollingTimer = _createPollingTimer(_pollingInterval!);
    }
  }

  Timer _createPollingTimer(Duration interval) {
    return Timer.periodic(interval, (_) {
      if (hasListener || config.pollInactive) {
        fetch();
      }
    });
  }

  void _handleAction(
    Event<ControllerAction<InfiniteQueryData<T, Arg>>> event,
  ) {
    final notifyObservers =
        event is DataEvent<ControllerAction<InfiniteQueryData<T, Arg>>>;
    switch (event.action) {
      case Fetch(:final isInitialFetch, :final fetchOptions):
        _setState(
          InfiniteQueryStatus.loading(
            isInitialFetch: isInitialFetch,
            isFetchingNextPage: fetchOptions is InfiniteFetchOptions &&
                (fetchOptions.direction?.isForward ?? false),
            isRefetching: !isInitialFetch &&
                (fetchOptions is InfiniteFetchOptions &&
                    fetchOptions.direction == null),
            data: state.data,
            timeCreated: state.timeCreated,
          ),
          notifyObservers: notifyObservers,
        );
      case FetchError(:final error, :final stackTrace):
        _onError?.call(error);
        _setState(
          InfiniteQueryStatus.error(
            error: error,
            stackTrace: stackTrace,
            data: state.data,
            timeCreated: state.timeCreated,
          ),
          notifyObservers: notifyObservers,
        );
      case StorageError(:final error):
        _onError?.call(error);
      case DataUpdated(:final data, :final timeCreated):
        _setState(
          state.copyWithData(data, timeCreated),
          notifyObservers: notifyObservers,
        );
      case Success(:final data, :final timeCreated):
        switch (data) {
          case Some<InfiniteQueryData<T, Arg>>(:final value):
            _onSuccess?.call(value);
            final nextPage = hasNextPage();
            _setState(
              InfiniteQueryStatus.success(
                hasReachedMax: !nextPage,
                hasPreviousPage: hasPreviousPage(),
                hasNextPage: nextPage,
                data: value,
                timeCreated: timeCreated,
              ),
              notifyObservers: notifyObservers,
            );
          case None<InfiniteQueryData<T, Arg>>():
            _setState(
              InfiniteQueryStatus.initial(
                timeCreated: timeCreated,
                data: state.data,
              ),
              notifyObservers: notifyObservers,
            );
        }
    }
  }
}
