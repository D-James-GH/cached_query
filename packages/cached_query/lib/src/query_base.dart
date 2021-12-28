part of "./cached_query.dart";

abstract class StateBase {
  Object? get data;
  const StateBase();
}

abstract class QueryBase<T, State extends StateBase> {
  final String key;
  final Serializer<dynamic>? _serializer;

  /// string encoded key
  // final String _queryHash;

  /// global cache singleton
  final GlobalCache _globalCache = GlobalCache.instance;

  /// garbage collection timer
  Timer? _deleteQueryTimer;

  /// time before the query should be re-fetched
  final Duration _staleTime;

  /// [_stale] marks the query as needing to refetch
  bool _stale = false;

  /// Time after there are 0 subscribes before the query is deleted from cache
  final Duration _cacheTime;

  /// if [_ignoreStaleTime] is true the data will never be re-fetched, unless forced to
  final bool _ignoreStaleTime;

  /// if [_ignoreCacheTime] is true the cache will never be deleted during the session
  final bool _ignoreCacheTime;

  /// current state of the query
  State _state;

  /// broadcast stream that reacts to changes to the query state
  StreamController<State>? _streamController;

  QueryBase._internal({
    required this.key,
    required bool ignoreRefetchDuration,
    required bool ignoreCacheDuration,
    Duration? refetchDuration,
    Duration? cacheDuration,
    required State state,
    Serializer<dynamic>? serializer,
  })  : _ignoreStaleTime = ignoreRefetchDuration,
        _ignoreCacheTime = ignoreCacheDuration,
        // _queryHash = jsonEncode(key),
        _staleTime = refetchDuration ?? GlobalCache.instance.refetchDuration,
        _cacheTime = cacheDuration ?? GlobalCache.instance.cacheDuration,
        _state = state,
        _serializer = serializer;

  State get state => _state;
  bool get stale => _stale;

  Future<State> get result;
  Future<State> refetch();

  /// sets the new state and adds the new state to the query stream
  void _setState(State newState) {
    _streamController?.add(newState);
    _state = newState;
  }

  void _saveToStorage() {
    if (_globalCache.storage != null && _state.data != null) {
      _globalCache.storage!.put<T>(key, item: _state.data! as T);
    }
  }

  Future<dynamic> _fetchFromStorage() async {
    if (_globalCache.storage != null) {
      final storedData = await _globalCache.storage?.get<T>(key);
      if (storedData != null) {
        return _serializer == null ? storedData : _serializer!(storedData);
      }
    }
  }

  Stream<State> get stream {
    if (_streamController != null) {
      return _streamController!.stream;
    }
    _streamController = StreamController.broadcast(
      onListen: () {
        // _streamController!.add(_state);
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

  /// After the [_cacheTime] is up remove the query from the [GlobalCache]
  void _scheduleDelete() {
    if (!_ignoreCacheTime) {
      _deleteQueryTimer = Timer(_cacheTime, () => deleteQuery());
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
      _deleteQueryTimer = Timer(_cacheTime, () => deleteQuery());
    }
  }

  /// mark as stale so will force a fetch next time the query is accessed
  void invalidateQuery() {
    _stale = true;
  }

  /// delete the query and query key from cache
  void deleteQuery() {
    _globalCache.deleteCache(key: key);
  }
}
