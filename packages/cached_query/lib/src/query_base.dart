part of "cached_query.dart";

/// On success is called when the query function is executed successfully.
///
/// Passes the returned data.
typedef OnQuerySuccessCallback<T> = void Function(T data);

/// On success is called when the query function is executed successfully.
///
/// Passes the error through.
typedef OnQueryErrorCallback<T> = void Function(dynamic error);

/// {@template stateBase}
/// An Interface for both [QueryState] and [InfiniteQueryState].
/// {@endtemplate}
abstract class StateBase<T> {
  /// Current data of the query.
  T? get data;

  /// Timestamp of the query.
  ///
  /// Time is reset if new data is fetched.
  DateTime get timeCreated;

  /// Status of the previous fetch.
  QueryStatus get status;

  /// Current error for the query.
  ///
  /// Equal to null if there is no error.
  dynamic get error;
}

/// {@template queryBase}
/// An Interface for both [Query] and [InfiniteQuery].
/// {@endtemplate}
abstract class QueryBase<T, State extends QueryState<T>> {
  QueryBase._internal({
    required this.key,
    required this.unencodedKey,
    required State state,
    required QueryConfig? config,
    required CachedQuery cache,
    bool? staleOverride,
  })  : config = config ?? cache.defaultConfig,
        _cache = cache,
        _state = state,
        _staleOverride = staleOverride ?? true;

  /// The key used to store and access the query. Encoded using jsonEncode.
  ///
  /// This is created by calling jsonEncode on the passed dynamic key.
  final String key;

  /// The original key.
  final Object unencodedKey;

  /// The current state of the query.
  State get state => _state;

  /// Whether the current query is marked as stale and therefore requires a
  /// refetch.
  bool get stale {
    return _state.timeCreated
            .add(config.refetchDuration)
            .isBefore(DateTime.now()) ||
        _staleOverride;
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

  final CachedQuery _cache;
  Timer? _deleteQueryTimer;
  Future<void>? _f;

  Future<void>? get _currentFuture => _f;

  set _currentFuture(Future<void>? future) {
    _f = future?.whenComplete(() {
      _currentFuture = null;
    });
  }

// Initialise the query as stale so the first fetch is guaranteed to happen
  bool _staleOverride;
  State _state;

  /// Refetch the query immediately.
  ///
  /// Returns the updated [State] and will notify the [stream].
  Future<State> refetch();

  /// Update the current [Query] data.
  ///
  /// The [updateFn] passes the current query data and must return new data of
  /// the same type as the original query/infiniteQuery.
  void update(UpdateFunc<T> updateFn);

  /// Mark query as stale.
  ///
  /// Will force a fetch next time the query is accessed.
  void invalidateQuery() {
    _staleOverride = true;
  }

  /// Delete the query and query key from cache
  void deleteQuery({bool deleteStorage = false}) {
    _cache.deleteCache(key: key, deleteStorage: deleteStorage);
  }

  Future<State> _getResult();

  /// Sets the new state.
  void _setState(State newState, [StackTrace? stackTrace]) {
    for (final observer in _cache.observers) {
      observer.onChange(this, newState);
    }
    _state = newState;
    if (stackTrace != null) {
      for (final observer in _cache.observers) {
        observer.onError(this, stackTrace);
      }
    }
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
      _cache._storage!.put(storedQuery);
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
    if (config.serializer != null) {
      data = config.serializer!(storedData.data);
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
