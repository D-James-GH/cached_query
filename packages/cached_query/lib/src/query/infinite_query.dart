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
    MergeRefetchResult<T, Arg>? mergeRefetchResult,
  }) {
    assert(
      (prefetchPages ?? 0) >= 0,
      "Prefetch pages must be greater than or equal to 0",
    );
    cache = cache ?? CachedQuery.instance;
    var query = cache.getQuery<InfiniteQueryStatus<T, Arg>>(key);
    assert(
      query is InfiniteQuery<T, Arg> || query == null,
      "Query found with key $key is not an InfiniteQuery<$T, $Arg>",
    );
    query = query as InfiniteQuery<T, Arg>?;

    if (query == null) {
      final queryKey = encodeKey(key);

      final controller = QueryController(
        cache: cache,
        key: queryKey,
        unencodedKey: key,
        initialData: initialData,
        onFetch: infiniteFetch<T, Arg>(
          getNextArg: getNextArg,
          mergeRefetchResult: mergeRefetchResult,
          queryFn: queryFn,
          initialArg: getNextArg(initialData),
        ),
        config: config,
      );

      query = InfiniteQuery<T, Arg>._internal(
        controller: controller,
        getNextArg: getNextArg,
        onError: onError,
        onSuccess: onSuccess,
      );
      cache.addQuery(query);

      if (prefetchPages != null) {
        controller.fetch(
          options: InfiniteFetchOptions(prefetchPages: prefetchPages),
        );
      }
    }

    return query;
  }

  InfiniteQuery._internal({
    required GetNextArg<T, Arg> getNextArg,
    required QueryController<InfiniteQueryData<T, Arg>> controller,
    OnQueryErrorCallback? onError,
    OnQuerySuccessCallback<InfiniteQueryData<T, Arg>>? onSuccess,
  })  : _getNextArg = getNextArg,
        _onSuccess = onSuccess,
        _onError = onError,
        _controller = controller {
    _state = InfiniteQueryStatus.initial(
      timeCreated: controller.state.timeCreated,
      data: controller.state.data,
    );
    _stateSubject = BehaviorSubject.seeded(
      state,
      onListen: () {
        controller
          ..addListener()
          ..fetch(options: InfiniteFetchOptions());
      },
      onCancel: () {
        controller.removeListener();
      },
    );
    _init();
  }

  String get key => _controller.key;
  Object get unencodedKey => _controller.unencodedKey;
  QueryConfig<InfiniteQueryData<T, Arg>> get config => _controller.config;
  late InfiniteQueryStatus<T, Arg> _state;
  InfiniteQueryStatus<T, Arg> get state => _state;
  Stream<InfiniteQueryStatus<T, Arg>> get stream => _stateSubject.stream;
  bool get stale => _controller.stale;
  bool get hasListener => _stateSubject.hasListener;

  final OnQuerySuccessCallback<InfiniteQueryData<T, Arg>>? _onSuccess;
  final OnQueryErrorCallback? _onError;

  final QueryController<InfiniteQueryData<T, Arg>> _controller;
  late final BehaviorSubject<InfiniteQueryStatus<T, Arg>> _stateSubject;
  final GetNextArg<T, Arg> _getNextArg;

  Future<InfiniteQueryStatus<T, Arg>> fetch() async {
    await _controller.fetch(options: InfiniteFetchOptions());
    return _state;
  }

  @Deprecated("Use fetch() instead.")
  Future<InfiniteQueryStatus<T, Arg>> get result => fetch();

  /// True if there are no more pages available to fetch.
  ///
  /// Calculated using [GetNextArg], if it has returned null then this is true.
  bool hasReachedMax() {
    return _getNextArg(_stateSubject.valueOrNull?.data) == null;
  }

  void update(UpdateFunc<InfiniteQueryData<T, Arg>> updateFn) {
    _controller.update(updateFn);
  }

  void setData(InfiniteQueryData<T, Arg> data) {
    return _controller.setData(data);
  }

  Future<InfiniteQueryStatus<T, Arg>> refetch() async {
    await _controller.fetch(
      forceRefetch: true,
      options: InfiniteFetchOptions(),
    );
    return _state;
  }

  /// Get the next page in an [InfiniteQuery] and cache the result.
  Future<InfiniteQueryStatus<T, Arg>?> getNextPage() async {
    await _controller.fetch(
      forceRefetch: true,
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
        case StorageError(:final error, :final stackTrace):
          _onError?.call(error);
        case DataUpdated(:final data):
          _setState(state.copyWithData(data as InfiniteQueryData<T, Arg>));
        case Success(:final data, :final timeCreated):
          _onSuccess?.call(data as InfiniteQueryData<T, Arg>);
          _setState(
            InfiniteQueryStatus.success(
              data: data as InfiniteQueryData<T, Arg>,
              timeCreated: timeCreated,
            ),
          );
      }
    });
  }
}
