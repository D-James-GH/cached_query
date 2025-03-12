part of "./_query.dart";

/// On success is called when the query function is executed successfully.
///
/// Passes the returned data.
typedef OnQuerySuccessCallback<T> = void Function(T data);

/// On success is called when the query function is executed successfully.
///
/// Passes the error through.
typedef OnQueryErrorCallback<T> = void Function(dynamic error);

/// {@template queryBase}
/// An Interface for both [Query] and [InfiniteQuery].
/// {@endtemplate}
abstract final class QueryController<T, State extends QueryState<T>> {
  QueryController._internal({
    required this.key,
    required this.unencodedKey,
    required State state,
    required QueryConfig? config,
    required CachedQuery cache,
  })  : config = config ?? cache.defaultConfig,
        _cache = cache,
        _state = state;

  /// The key used to store and access the query. Encoded using jsonEncode.
  ///
  /// This is created by calling jsonEncode on the passed dynamic key.
  final String key;

  /// The original key.
  final Object unencodedKey;

  /// The current state of the query.
  State get state => _state;

  bool _invalidated = false;

  /// Whether the current query is marked as stale and therefore requires a
  /// refetch.
  bool get stale {
    return _state.timeCreated
            .add(config.refetchDuration)
            .isBefore(DateTime.now()) ||
        _invalidated;
  }

  /// The config for this specific query.
  final QueryConfig config;

  /// Weather the query stream has any listeners.
  bool get hasListener => _streamController?.hasListener ?? false;

  /// Stream the state of the query.
  ///
  /// When the state is updated either by a mutation or a new query [stream]
  /// will be notified.
  Stream<State> get stream => _getStream();

  /// Get the result of calling the queryFn.
  ///
  /// If [result] is used when the [stream] has no listeners [result] will start
  /// the delete timer once complete. For full caching functionality see [stream].
  Future<State> get result {
    _resetDeleteTimer();
    // if there are no other listeners and result has been called schedule
    // a delete.
    if (!(_streamController?.hasListener ?? false) &&
        !(_deleteQueryTimer?.isActive ?? false)) {
      _scheduleDelete();
    }
    return _getResult();
  }

  /// Broadcast stream controller that reacts to changes to the query state
  BehaviorSubject<State>? _streamController;
  State _state;

  final CachedQuery _cache;
  Timer? _deleteQueryTimer;
  Future<void>? _f;

  Future<void>? get _currentFuture => _f;

  set _currentFuture(Future<void>? future) {
    _f = future?.whenComplete(() {
      _currentFuture = null;
      _invalidated = false;
    });
  }

  /// Refetch the query immediately.
  ///
  /// Returns the updated [State] and will notify the [stream].
  Future<State> refetch() => _getResult(forceRefetch: true);

  /// Update the current query data.
  ///
  /// The [updateFn] passes the current query data and must return new data of
  /// the same type as the original query/infiniteQuery.
  void update(UpdateFunc<T> updateFn) {
    final newData = updateFn(_state.data);
    final newState = _state.copyWithData(newData);

    _setState(newState as State);
    if (config.storeQuery) {
      _saveToStorage();
    }
    _emit();
  }

  /// Invalidate the query. Deprecated use [invalidate] instead.
  @Deprecated("Use invalidate instead.")
  Future<void> invalidateQuery({
    bool refetchActive = true,
    bool refetchInactive = false,
  }) {
    return invalidate(
      refetchActive: refetchActive,
      refetchInactive: refetchInactive,
    );
  }

  /// Mark query as stale.
  ///
  /// Pass [refetchActive] as true (default) to refetch the query if it has listeners.
  ///
  /// Pass [refetchInactive] as true (default = false) to refetch the query even if it has no listeners.
  ///
  /// Will force a fetch next time the query is accessed.
  Future<void> invalidate({
    bool refetchActive = true,
    bool refetchInactive = false,
  }) {
    if ((hasListener && refetchActive) || refetchInactive) {
      return refetch();
    }
    _invalidated = true;
    return Future.value();
  }

  /// Delete the query and query key from cache
  void deleteQuery({bool deleteStorage = false}) {
    _cache.deleteCache(key: key, deleteStorage: deleteStorage);
  }

  Future<State> _getResult({bool forceRefetch = false}) async {
    final hasData = _state.data != null;
    if (!stale &&
        !forceRefetch &&
        !_state.isError &&
        hasData &&
        !state.isInitial) {
      _emit();
      return _state;
    }

    final shouldRefetch =
        (config.shouldRefetch?.call(this as QueryBase, false) ?? true) ||
            forceRefetch;
    if (shouldRefetch || _state.isInitial) {
      _currentFuture ??= _fetch(initialFetch: _state.isInitial);
      await _currentFuture;
    }
    return _state;
  }

  Future<void> _fetch({required bool initialFetch});

  /// Sets the new state.
  void _setState(State newState) {
    for (final observer in _cache.observers) {
      observer.onChange(this as QueryBase, newState);
    }
    _state = newState;
    switch (_state) {
      case InfiniteQueryError(:final stackTrace) ||
            QueryError(:final stackTrace):
        for (final observer in _cache.observers) {
          observer.onError(this as QueryBase, stackTrace);
        }
      default:
        break;
    }
    _emit();
  }

  /// Emits the current state down the stream.
  void _emit() {
    _streamController?.add(_state);
  }

  void _saveToStorage() {
    if (_cache.storage != null && _state.data != null) {
      dynamic dataToStore = _state.data;
      if (config.storageSerializer != null) {
        dataToStore = config.storageSerializer!(dataToStore);
      }
      final storedQuery = StoredQuery(
        key: key,
        data: dataToStore,
        createdAt: _state.timeCreated,
        storageDuration: config.storageDuration,
      );
      _cache.storage!.put(storedQuery);
    }
  }

  /// If the data is expired this will return null.
  Future<T?> _fetchFromStorage() async {
    if (_cache.storage == null) {
      return null;
    }

    final storedData = await _cache.storage?.get(key);

    // In-case the developer changes the storage duration in the code.
    final expiryHasChanged =
        storedData?.storageDuration != config.storageDuration;

    if (storedData == null ||
        storedData.isExpired ||
        storedData.data == null ||
        expiryHasChanged) {
      return null;
    }

    dynamic data = storedData.data;

    if (config.storageDeserializer != null) {
      data = config.storageDeserializer!(storedData.data);
    }

    if (data is T) {
      return data;
    }

    return null;
  }

  Stream<State> _getStream() {
    if (_streamController != null) {
      _getResult();
      return _streamController!.stream;
    }
    _streamController = BehaviorSubject.seeded(
      _state,
      onListen: _cancelDelete,
      onCancel: () {
        _streamController!.close();
        _streamController = null;
        _scheduleDelete();
      },
    );
    _getResult();

    return _streamController!.stream;
  }

  /// After the [_cacheTime] is up remove the query from the global cache.
  void _scheduleDelete() {
    if (!config.ignoreCacheDuration) {
      _deleteQueryTimer = Timer(config.cacheDuration, deleteQuery);
    }
  }

  void _cancelDelete() {
    if (_deleteQueryTimer?.isActive ?? false) {
      _deleteQueryTimer!.cancel();
    }
  }

  void _resetDeleteTimer() {
    if (_deleteQueryTimer?.isActive ?? false) {
      _deleteQueryTimer!.cancel();
      _deleteQueryTimer = Timer(config.cacheDuration, deleteQuery);
    }
  }

  /// Closes the stream and therefore starts the delete timer.
  Future<void> close() async {
    await _streamController?.close();
    _streamController = null;
  }
}
