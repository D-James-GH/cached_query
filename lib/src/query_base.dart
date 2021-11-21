part of "./cached_query.dart";

abstract class QueryBase<T, State> {
  final dynamic key;

  /// string encoded key
  final String _queryHash;

  /// global cache singleton
  final GlobalCache _globalCache = GlobalCache.instance;

  /// holds the current fetching future for de-duping requests
  Future<void>? _currentFuture;

  /// garbage collection timer
  Timer? _gcTimer;

  /// List of subscribers to the query
  List<Object> _subscribers = [];

  @visibleForTesting
  Timer? get gcTimer => _gcTimer;

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
    required bool ignoreStaleTime,
    required bool ignoreCacheTime,
    required Duration staleTime,
    required Duration cacheTime,
    required State state,
  })  : _ignoreStaleTime = ignoreStaleTime,
        _ignoreCacheTime = ignoreCacheTime,
        _queryHash = jsonEncode(key),
        _staleTime = staleTime,
        _cacheTime = cacheTime,
        _state = state;

  Future<State> get result;

  State get state => _state;

  Stream<State> get stream {
    if (_streamController != null) {
      return _streamController!.stream;
    }
    _streamController = StreamController.broadcast(
        onListen: () => _streamController!.add(_state),
        onCancel: () {
          _streamController!.close();
          _streamController = null;
        });
    return _streamController!.stream;
  }

  /// add a [Subscriber] to this query.
  void Function() _subscribe(subscriber) {
    if (!_subscribers.contains(subscriber)) {
      _subscribers.add(subscriber);
    }
    _unScheduleGC();

    return () => _unsubscribe(subscriber);
  }

  /// remove a [Subscriber] from this query. If removing the last subscriber schedule
  /// a garbage collection.
  void _unsubscribe(Subscriber subscriber) {
    _subscribers = _subscribers.where((e) => e != subscriber).toList();
    if (_subscribers.isEmpty) {
      _scheduleGC();
    }
  }

  /// After the [_cacheTime] is up remove the query from the [GlobalCache]
  void _scheduleGC() {
    if (!_ignoreCacheTime) {
      _gcTimer = Timer(_cacheTime, () => deleteQuery());
    }
  }

  /// Cancel the garbage collection if another subscriber is added
  void _unScheduleGC() {
    if (_gcTimer?.isActive == true) {
      _gcTimer!.cancel();
    }
  }

  /// mark as stale so will force a fetch next time the query is accessed
  void invalidateQuery() {
    _stale = true;
  }

  /// delete the query and query key from cache
  void deleteQuery() {
    _globalCache.deleteCache(queryHash: _queryHash);
  }
}
