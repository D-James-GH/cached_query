part of "cached_query.dart";

/// On success is called when the query function is executed successfully.
///
/// Passes the returned data.
typedef OnQuerySuccessCallback<T> = void Function(T);

/// On success is called when the query function is executed successfully.
///
/// Passes the error through.
typedef OnQueryErrorCallback<T> = void Function(dynamic);

/// {@template stateBase}
/// An Interface for both [QueryState] and [InfiniteQueryState].
/// {@endtemplate}
abstract class StateBase {
  /// Current data of the query.
  dynamic get data;

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
abstract class QueryBase<T, State extends QueryState<dynamic>> {
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
  bool get stale => _stale;

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

  final CachedQuery _globalCache = CachedQuery.instance;
  Timer? _deleteQueryTimer;
  Future<void>? _currentFuture;
  // Initialise the query as stale so the first fetch is guaranteed to happen
  bool _stale = true;
  State _state;

  QueryBase._internal({
    required this.key,
    required this.unencodedKey,
    required State state,
    required QueryConfig? config,
  })  : config = config ?? CachedQuery.instance.defaultConfig,
        _state = state;

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
    _stale = true;
  }

  /// Delete the query and query key from cache
  void deleteQuery({bool deleteStorage = false}) {
    _globalCache.deleteCache(key: key, deleteStorage: deleteStorage);
  }

  Future<State> _getResult();

  /// Sets the new state.
  void _setState(State newState, [StackTrace? stackTrace]) {
    CachedQuery.instance.observer.onChange(this, newState);
    _state = newState;
    if (stackTrace != null) {
      CachedQuery.instance.observer.onError(this, stackTrace);
    }
  }

  /// Emits the current state down the stream.
  void _emit() {
    _streamController?.add(_state);
  }

  void _saveToStorage<StorageType>() {
    if (_globalCache.storage != null && _state.data != null) {
      _globalCache._storage!
          .put<StorageType>(key, item: _state.data! as StorageType);
    }
  }

  Future<dynamic> _fetchFromStorage() async {
    if (_globalCache.storage != null) {
      final dynamic storedData = await _globalCache.storage?.get(key);
      if (storedData != null) {
        return config.serializer == null
            ? storedData
            : config.serializer!(storedData);
      }
    }
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
