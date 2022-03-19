part of "./cached_query.dart";

/// {@template stateBase}
/// An Interface for both [QueryState] and [InfiniteQueryState].
/// {@endTemplate}
abstract class StateBase {
  /// Current data of the query.
  Object? get data;

  /// {@macro stateBase}
  const StateBase();
}

/// {@template queryBase}
/// An Interface for both [Query] and [InfiniteQuery].
/// {@endTemplate}
abstract class QueryBase<T, State extends StateBase> {
  /// The key used to store and access the query.
  ///
  /// This is created by calling jsonEncode on the passed dynamic key.
  final String key;

  final Serializer<T>? _serializer;
  final CachedQuery _globalCache = CachedQuery.instance;
  Timer? _deleteQueryTimer;
  final Duration _staleTime;

  bool _stale = false;
  final Duration _cacheTime;
  final bool _ignoreRefetchDuration;
  final bool _ignoreCacheDuration;
  State _state;

  /// Broadcast stream controller that reacts to changes to the query state
  StreamController<State>? _streamController;

  QueryBase._internal({
    required this.key,
    required bool ignoreRefetchDuration,
    required bool ignoreCacheDuration,
    Duration? refetchDuration,
    Duration? cacheDuration,
    required State state,
    Serializer<T>? serializer,
  })  : _ignoreRefetchDuration = ignoreRefetchDuration,
        _ignoreCacheDuration = ignoreCacheDuration,
        // _queryHash = jsonEncode(key),
        _staleTime = refetchDuration ?? CachedQuery.instance._refetchDuration,
        _cacheTime = cacheDuration ?? CachedQuery.instance._cacheDuration,
        _state = state,
        _serializer = serializer;

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
  Future<State> get result;

  /// Refetch the query immediately.
  ///
  /// Returns the updated [State] and will notify the [stream].
  Future<State> refetch();

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
}
