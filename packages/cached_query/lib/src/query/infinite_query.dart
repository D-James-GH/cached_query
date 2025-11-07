part of '_query.dart';

/// The result of the [InfiniteQueryFunc] will be cached.
typedef InfiniteQueryFunc<T, A> = Future<T> Function(A pageArgs);

/// Determines the parameters of the next page in an infinite query.
///
/// Return null if the last page has already been fetch and therefore trigger
/// [InfiniteQueryStatus.hasReachedMax] to equal `true`.
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
final class InfiniteQuery<T, Arg>
    extends Cacheable<InfiniteQueryStatus<T, Arg>> {
  /// {@macro infiniteQuery}
  factory InfiniteQuery({
    required Object key,
    required Future<T> Function(Arg arg) queryFn,
    required GetNextArg<T, Arg> getNextArg,
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
    final existingQuery = cache.getQuery<InfiniteQuery<T, Arg>>(key);

    assert(
      existingQuery is InfiniteQuery<T, Arg> || existingQuery == null,
      "Query found with key $key is not an InfiniteQuery<$T, $Arg>",
    );

    config ??= QueryConfig<InfiniteQueryData<T, Arg>>();
    config = config.mergeWithGlobal(cache.defaultConfig);

    final encodedKey = encodeKey(key);

    final controller = existingQuery?._controller ??
        QueryController(
          cache: cache,
          key: encodedKey,
          unencodedKey: key,
          initialData: Option.fromNullable(initialData),
          onFetch: InfiniteFetch<T, Arg>(
            getNextArg: getNextArg,
            onPageRefetched: onPageRefetched,
            queryFn: queryFn,
            initialArg: getNextArg(initialData),
          ),
          config: config,
        );
    final query = InfiniteQuery<T, Arg>._internal(
      controller: controller,
      config: config,
      getNextArg: getNextArg,
      onError: onError,
      onSuccess: onSuccess,
    );

    if (existingQuery == null) {
      cache.addQuery(query);
    } else if (controller._config != config) {
      controller.updateConfig(config);
    }
    if (prefetchPages != null && controller.state.data.isNone) {
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
    OnQueryErrorCallback? onError,
    OnQuerySuccessCallback<InfiniteQueryData<T, Arg>>? onSuccess,
  })  : _getNextArg = getNextArg,
        _onSuccess = onSuccess,
        _onError = onError,
        _controller = controller {
    _state = InfiniteQueryStatus.initial(
      timeCreated: controller.state.timeCreated,
      data: controller.state.data.valueOrNull,
    );
    _stateSubject = BehaviorSubject.seeded(
      state,
      onListen: () {
        controller
          ..addListener(this)
          ..fetch(options: InfiniteFetchOptions());
      },
      onCancel: () {
        controller.removeListener(this);
      },
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

  @override
  Future<InfiniteQueryStatus<T, Arg>> fetch() async {
    if (!stale) {
      return state;
    }
    _controller.addListener(this);
    await _controller.fetch(options: InfiniteFetchOptions());
    if (!hasListener) {
      _controller.removeListener(this);
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
  bool hasReachedMax() {
    return _getNextArg(_stateSubject.valueOrNull?.data) == null;
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
    return state;
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

  void _setState(InfiniteQueryStatus<T, Arg> state) {
    final observers = _controller._cache.observers;
    for (final observer in observers) {
      observer.onChange(this, state);
      if (state case InfiniteQueryError(:final stackTrace)) {
        observer.onError(this, stackTrace);
      }
    }
    _state = state;
    _stateSubject.add(state);
  }

  void _init() {
    _controller.stream.listen((action) {
      switch (action) {
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
          );
        case StorageError(:final error):
          _onError?.call(error);
        case DataUpdated(:final data):
          _setState(state.copyWithData(data));
        case Success(:final data, :final timeCreated):
          switch (data) {
            case Some<InfiniteQueryData<T, Arg>>(:final value):
              _onSuccess?.call(value);
              _setState(
                InfiniteQueryStatus.success(
                  hasReachedMax: hasReachedMax(),
                  data: value,
                  timeCreated: timeCreated,
                ),
              );
            case None<InfiniteQueryData<T, Arg>>():
              _setState(
                InfiniteQueryStatus.initial(
                  timeCreated: timeCreated,
                  data: state.data,
                ),
              );
          }
      }
    });
  }
}
