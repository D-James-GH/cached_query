part of '_query.dart';

/// The result of the [QueryFunc] will be cached.
typedef QueryFunc<T> = Future<T> Function();

/// {@template query}
/// [Query] is will fetch and cache the response of the [queryFn].
///
/// The [queryFn] must be asynchronous and the result is cached.
///
/// [Query] takes a [key] to identify and store it in the global cache. The [key]
/// can be any serializable data. The [key] is converted to a [String] using
/// [jsonEncode].
///
/// Each [Query] can override the global defaults for [refetchDuration], [cacheDuration],
/// see [CachedQuery.config] for more info.
///
/// Use [forceRefetch] to force the query to be run again regardless of whether
/// the query is stale or not.
///
/// To run side effects if the query function is successful or not use [onSuccess] and
/// [onError].
///
/// {@endtemplate}
final class Query<T> extends Cacheable<QueryStatus<T>> {
  /// {@macro query}
  factory Query({
    required Object key,
    required Future<T> Function() queryFn,
    OnQueryErrorCallback? onError,
    OnQuerySuccessCallback<T>? onSuccess,
    T? initialData,
    QueryConfig<T>? config,
    CachedQuery? cache,
  }) {
    cache = cache ?? CachedQuery.instance;
    var query = cache.getQuery<Query<T>>(key);

    // if query is null check the storage
    if (query == null) {
      final encodedKey = encodeKey(key);
      final controller = QueryController(
        cache: cache,
        key: encodedKey,
        unencodedKey: key,
        initialData: initialData,
        onFetch: ({required options, state}) {
          return queryFn();
        },
        config: config,
      );

      query = Query<T>._internal(
        onError: onError,
        onSuccess: onSuccess,
        controller: controller,
      );
      cache.addQuery(query);
    }

    return query;
  }

  Query._internal({
    OnQueryErrorCallback? onError,
    OnQuerySuccessCallback<T>? onSuccess,
    required QueryController<T> controller,
  })  : _onError = onError,
        _onSuccess = onSuccess,
        _controller = controller {
    _state = QueryInitial(
      timeCreated: controller.state.timeCreated,
      data: controller.state.data,
    );
    _stateSubject = BehaviorSubject.seeded(
      state,
      onListen: () {
        controller
          ..addListener()
          ..fetch(options: FetchOptions());
      },
      onCancel: () {
        controller.removeListener();
      },
    );
    _init();
  }

  @override
  String get key => _controller.key;
  @override
  Object get unencodedKey => _controller.unencodedKey;

  /// The config for this specific query.
  QueryConfig<T> get config => _controller.config;

  late QueryStatus<T> _state;

  @override
  QueryStatus<T> get state => _state;

  @override
  Stream<QueryStatus<T>> get stream => _stateSubject.stream;

  @override
  bool get stale => _controller.stale;

  @override
  bool get hasListener => _stateSubject.hasListener;

  @override
  Future<QueryStatus<T>> fetch() async {
    await _controller.fetch();
    return state;
  }

  /// Fetch the query as a future.
  @Deprecated("Use fetch() instead.")
  Future<QueryStatus<T>> get result => fetch();

  @override
  Future<QueryStatus<T>> refetch() async {
    await _controller.fetch(forceRefetch: true);
    return state;
  }

  @override
  Future<void> invalidate({
    bool refetchActive = true,
    bool refetchInactive = false,
  }) {
    return _controller.invalidate(
      refetchActive: refetchActive,
      refetchInactive: refetchInactive,
    );
  }

  /// Update the current query data.
  void update(UpdateFunc<T> updateFn) {
    return _controller.update(updateFn);
  }

  /// Set the current query data.
  void setData(T data) {
    return _controller.setData(data);
  }

  @override
  void deleteQuery({bool deleteStorage = false}) {
    _controller.deleteQuery(deleteStorage: deleteStorage);
  }

  @override
  Future<void> dispose() async {
    await _controller.dispose();
    await _stateSubject.close();
  }

  late final BehaviorSubject<QueryStatus<T>> _stateSubject;
  final OnQuerySuccessCallback<T>? _onSuccess;
  final OnQueryErrorCallback? _onError;
  final QueryController<T> _controller;

  void _setState(QueryStatus<T> state) {
    final observers = _controller._cache.observers;
    for (final observer in observers) {
      observer.onChange(this, state);
      if (state case QueryError(:final stackTrace)) {
        observer.onError(this, stackTrace);
      }
    }

    _state = state;
    _stateSubject.add(state);
  }

  void _init() {
    _controller.stream.listen((action) {
      switch (action) {
        case Fetch(:final isInitialFetch):
          _setState(
            QueryStatus.loading(
              data: state.data,
              timeCreated: state.timeCreated,
              isRefetching: !isInitialFetch,
              isInitialFetch: isInitialFetch,
            ),
          );
        case FetchError(:final error, :final stackTrace):
          _onError?.call(error);
          _setState(
            QueryStatus.error(
              timeCreated: state.timeCreated,
              data: state.data,
              stackTrace: stackTrace,
              error: error,
            ),
          );
        case StorageError(:final error):
          _onError?.call(error);
        case DataUpdated(:final data, :final timeCreated):
          _setState(state.copyWithData(data as T, timeCreated));
        case Success(:final data, :final timeCreated):
          _onSuccess?.call(data as T);
          _setState(
            QueryStatus.success(
              timeCreated: timeCreated,
              data: data as T,
            ),
          );
      }
    });
  }
}
