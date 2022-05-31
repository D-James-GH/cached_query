part of "./cached_query.dart";

/// {@template stateBase}
/// An Interface for both [QueryState] and [InfiniteQueryState].
/// {@endTemplate}
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
/// {@endTemplate}
abstract class QueryBase<T, State extends QueryState<dynamic>> {
  /// The key used to store and access the query.
  ///
  /// This is created by calling jsonEncode on the passed dynamic key.
  final String key;

  /// Whether the query should be stored in persistent storage.
  ///
  /// Only effective when [CachedQuery] storage is set.
  final bool storeQuery;

  final Serializer<T>? _serializer;
  final CachedQuery _globalCache = CachedQuery.instance;
  Timer? _deleteQueryTimer;
  final Duration _refetchDuration;
  Future<void>? _currentFuture;
  // Initialise the query as stale so the first fetch is guaranteed to happen
  bool _stale = true;
  final Duration _cacheTime;
  final bool _ignoreRefetchDuration;
  final bool _ignoreCacheDuration;
  State _state;

  /// Broadcast stream controller that reacts to changes to the query state
  StreamController<State>? _streamController;

  /// The current state of the query.
  State get state => _state;

  /// Whether the current query is marked as stale and therefore requires a
  /// refetch.
  bool get stale => _stale;

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
  /// the delete timer. For full caching functionality see [stream].
  Future<State> get result {
    _resetDeleteTimer();
    // if there are no other listeners and result has been called schedule
    // a delete.
    if (_streamController?.hasListener != true &&
        _deleteQueryTimer?.isActive != true) {
      _scheduleDelete();
    }
    return _getResult();
  }

  QueryBase._internal({
    required this.key,
    required bool ignoreRefetchDuration,
    required bool ignoreCacheDuration,
    required this.storeQuery,
    Duration? refetchDuration,
    Duration? cacheDuration,
    required State state,
    Serializer<T>? serializer,
  })  : _ignoreRefetchDuration = ignoreRefetchDuration,
        _ignoreCacheDuration = ignoreCacheDuration,
        // _queryHash = jsonEncode(key),
        _refetchDuration =
            refetchDuration ?? CachedQuery.instance._refetchDuration,
        _cacheTime = cacheDuration ?? CachedQuery.instance._cacheDuration,
        _state = state,
        _serializer = serializer;

  /// Refetch the query immediately.
  ///
  /// Returns the updated [State] and will notify the [stream].
  Future<State> refetch();

  /// Mark query as stale.
  ///
  /// Will force a fetch next time the query is accessed.
  void invalidateQuery() {
    _stale = true;
  }

  /// Delete the query and query key from cache
  void deleteQuery() {
    _globalCache.deleteCache(key);
  }

  Future<State> _getResult();

  /// Sets the new state.
  void _setState(State newState) {
    _state = newState;
  }

  /// Emits the current state down the stream.
  void _emit() {
    _streamController?.add(_state);
  }

  void _saveToStorage() {
    if (_globalCache._storage != null && _state.data != null) {
      _globalCache._storage!.put<T>(key, item: _state.data! as T);
    }
  }

  Future<dynamic> _fetchFromStorage() async {
    if (_globalCache._storage != null) {
      final dynamic storedData = await _globalCache._storage?.get(key);
      if (storedData != null) {
        return _serializer == null ? storedData : _serializer!(storedData);
      }
    }
  }

  Stream<State> _getStream() {
    if (_streamController != null) {
      return _streamController!.stream;
    }
    _streamController = StreamController.broadcast(
      onListen: () {
        _emit();
        _cancelDelete();
      },
      onCancel: () {
        _streamController!.close();
        _streamController = null;
        _scheduleDelete();
      },
    );

    return _streamController!.stream;
  }

  /// After the [_cacheTime] is up remove the query from the global cache.
  void _scheduleDelete() {
    if (!_ignoreCacheDuration) {
      _deleteQueryTimer = Timer(_cacheTime, deleteQuery);
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
      _deleteQueryTimer = Timer(_cacheTime, deleteQuery);
    }
  }
}
