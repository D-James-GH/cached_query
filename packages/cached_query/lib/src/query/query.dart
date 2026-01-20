part of '_query.dart';

/// The result of the [QueryFunc] will be cached.
typedef QueryFunc<T> = Future<T> Function();

///
class QueryFetchFunction<T> implements FetchFunction<T> {
  ///
  QueryFetchFunction({required this.queryFn});

  ///
  final Future<T> Function() queryFn;

  @override
  Future<T> call({required FetchOptions options, T? state}) {
    return queryFn();
  }
}

/// Creates an empty [Query] without a query function.
/// Used when cache.setQuery is called and no query is available.
Query<T> createEmptyQuery<T>({
  required Object key,
  required CachedQuery cache,
}) {
  final encodedKey = encodeKey(key);

  var config = QueryConfig<T>();
  config = config.mergeWithGlobal(cache.defaultConfig);

  final controller = QueryController<T>(
    cache: cache,
    key: encodedKey,
    unencodedKey: key,
    initialData: Option<T>.none(),
    onFetch: EmptyFetchFunction(),
    config: config,
  );

  final query = Query._internal(
    controller: controller,
    config: config,
  );
  cache.addQuery(query);
  return query;
}

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
    final existingQuery = cache.getQuery<Query<T>>(key);
    config ??= QueryConfig<T>();
    config = config.mergeWithGlobal(cache.defaultConfig);
    final encodedKey = encodeKey(key);

    final controller = existingQuery?._controller ??
        QueryController(
          cache: cache,
          key: encodedKey,
          unencodedKey: key,
          initialData:
              initialData == null ? Option<T>.none() : Option.some(initialData),
          onFetch: QueryFetchFunction(queryFn: queryFn),
          config: config,
        );

    final shouldUpdateController = controller.onFetch is EmptyFetchFunction<T>;

    if (existingQuery != null &&
        config == existingQuery.config &&
        !shouldUpdateController) {
      return existingQuery;
    }

    final query = Query<T>._internal(
      onError: onError,
      onSuccess: onSuccess,
      controller: controller,
      config: config,
    );

    cache.addQuery(query);

    if (controller._config != config) {
      controller.updateConfig(config: config);
    }

    if (shouldUpdateController) {
      controller.updateConfig(
        fetchFn: QueryFetchFunction(queryFn: queryFn),
      );
    }

    return query;
  }

  /// Build a query without adding it to the cache.
  @visibleForTesting
  factory Query.build(QueryController<T> controller, QueryConfig<T> config) {
    return Query._internal(
      controller: controller,
      config: config,
    );
  }

  Query._internal({
    OnQueryErrorCallback? onError,
    OnQuerySuccessCallback<T>? onSuccess,
    required QueryController<T> controller,
    required this.config,
  })  : _onError = onError,
        _onSuccess = onSuccess,
        _controller = controller {
    _stateSubject = BehaviorSubject.seeded(
      QueryInitial(
        timeCreated: controller.stateNotifier.value.timeCreated,
        data: controller.stateNotifier.value.data.valueOrNull,
      ),
      onListen: () {
        controller
          ..registerQuery(this)
          ..fetch();
      },
      onCancel: () {
        controller.removeRegisteredQuery(this);
      },
    );
    _init();
  }

  @override
  String get key => _controller.key;

  @override
  Object get unencodedKey => _controller.unencodedKey;

  /// The config for this specific query.
  @override
  final QueryConfig<T> config;

  @override
  QueryStatus<T> get state => _stateSubject.value;

  @override
  Stream<QueryStatus<T>> get stream => _stateSubject.stream;

  @override
  bool get stale {
    return _controller.isStaleOrInvalidated(config.staleDuration);
  }

  @override
  bool get hasListener => _stateSubject.hasListener;

  @override
  Future<QueryStatus<T>> fetch() async {
    if (!stale) {
      return state;
    }
    _controller.registerQuery(this);
    await _controller.fetch();
    if (!hasListener) {
      _controller.removeRegisteredQuery(this);
    }

    if (state case QueryError(:final stackTrace, :final error)
        when config.shouldRethrow) {
      Error.throwWithStackTrace(error as Object, stackTrace);
    }

    return state;
  }

  /// Fetch the query as a future.
  @Deprecated("Use fetch() instead.")
  Future<QueryStatus<T>> get result => fetch();

  @override
  Future<QueryStatus<T>> refetch() async {
    await _controller.invalidate(refetchInactive: true);
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

  void _setState(QueryStatus<T> state, {required bool notifyObservers}) {
    _stateSubject.add(state);

    if (notifyObservers) {
      final observers = _controller._cache.observers;
      for (final observer in observers) {
        observer.onChange(this, state);
        if (state case QueryError(:final stackTrace)) {
          observer.onError(this, stackTrace);
        }
      }
    }

    final newInterval = config.pollingInterval?.call(state);
    if (_pollingInterval != newInterval) {
      _pollingTimer?.cancel();
      _pollingInterval = newInterval;
      if (_pollingInterval != null) {
        _pollingTimer = _createPollingTimer(_pollingInterval!);
      }
    }
  }

  Timer? _pollingTimer;
  Duration? _pollingInterval;

  void _init() {
    _controller.stateNotifier.addListener(_handleAction);

    _pollingInterval = config.pollingInterval?.call(state);
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

  void _handleAction(Event<ControllerAction<T>> event) {
    final notifyObservers = event is DataEvent<ControllerAction<T>>;
    switch (event.action) {
      case Fetch(:final isInitialFetch):
        _setState(
          QueryStatus.loading(
            data: state.data,
            timeCreated: state.timeCreated,
            isRefetching: !isInitialFetch,
            isInitialFetch: isInitialFetch,
          ),
          notifyObservers: notifyObservers,
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
          case None():
            _setState(
              QueryStatus.initial(
                timeCreated: timeCreated,
                data: state.data,
              ),
              notifyObservers: notifyObservers,
            );
          case Some(:final value):
            _onSuccess?.call(value);
            _setState(
              QueryStatus.success(
                timeCreated: timeCreated,
                data: value,
              ),
              notifyObservers: notifyObservers,
            );
        }
    }
  }
}
