import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:cached_query/src/global_cache.dart';
import 'package:cached_query/src/models/infinite_query.dart';
import 'package:cached_query/src/query_manager.dart';

/// [InfiniteQueryManage] is a controller for infinite query's. It holds information
/// on which individual query's make up part of the infinite query.
class InfiniteQueryManager<T> {
  final String key;
  final GlobalCache _globalCache = GlobalCache.instance;
  final Future<List<T>> Function(int) queryFn;
  StreamController<InfiniteQuery<T>>? _streamController;
  final Duration staleTime;
  final Duration cacheTime;

  late InfiniteQuery<T> _state;
  List<String> queryKeys = [];
  List<Object> subscribers = [];
  int currentPage;
  Timer? _gcTimer;
  bool stale = false;
  InfiniteQuery<T> get state => _state;

  InfiniteQueryManager({
    required this.queryFn,
    required this.key,
    required int initialPage,
    required this.staleTime,
    required this.cacheTime,
  })  : currentPage = initialPage,
        queryKeys = [key + initialPage.toString()] {
    _state = InfiniteQuery(
      createStream: createStream,
      currentPage: initialPage,
      getNextPage: _getNextPage,
      timeCreated: DateTime.now(),
    );
  }

  /// returns the combined data of all the [QueryManager]'s in [queryKeys]
  FutureOr<InfiniteQuery<T>> getResult({bool forceRefetch = false}) async {
    if (!stale &&
        !forceRefetch &&
        _state.data != null &&
        _state.data!.isNotEmpty == true &&
        _state.timeCreated.add(staleTime).isAfter(DateTime.now())) {
      _streamController?.add(_state);
      return _state;
    }

    if (queryKeys.isEmpty) {
      // get initial page
      final initialQuery = await _getQuery().getResult();
      _state = _state.copyWith(data: initialQuery.data);
      _streamController?.add(_state);
      return _state;
    }
    await _getAllQueryResult();
    _streamController?.add(_state);
    return _state;
  }

  Stream<InfiniteQuery<T>> streamResult() async* {
    if (!stale &&
        _state.data != null &&
        _state.data!.isNotEmpty == true &&
        _state.timeCreated.add(staleTime).isAfter(DateTime.now())) {
      _streamController?.add(_state);
      yield _state;
    } else {
      var loadingState =
          _state.copyWith(status: QueryStatus.loading, isFetching: true);
      _streamController?.add(loadingState);
      yield loadingState;
      await _getAllQueryResult();
      _streamController?.add(_state);
      yield _state;
    }
  }

  /// Call this function to automatically increase the page number and fetch it
  Future<InfiniteQuery<T>> _getNextPage() async {
    // add one to current page number and get the query without passing in a key
    currentPage++;
    final newQuery = _getQuery();

    // use the new query to fetch the new data/page
    final Query<List<T>?> res = await newQuery.getResult();

    if (res.data == null || res.data?.isEmpty == true) {
      _state = _state.copyWith(hasReachedMax: true);
      return _state;
    }

    // copy the state with the new data appended
    _state = _state.copyWith(data: [...?_state.data, ...res.data!]);
    _streamController?.add(_state);
    return _state;
  }

  void preFetchPages(List<int> pages) {
    for (var page in pages) {
      final queryKey = key + currentPage.toString();
      final query = _globalCache.getQuery<List<T>>(
        key: queryKey,
        queryFn: () => queryFn(page),
        ignoreCacheTime: true,
        ignoreStaleTime: true,
      );
      query.fetch();
    }
  }

  /// get all queries in the query key list
  Future<void> _getAllQueryResult() async {
    final queries = queryKeys.map((k) => _getQuery(queryKey: k)).toList();

    final List<T> data = [];
    await Future.forEach(queries, (QueryManager<List<T>> query) async {
      final Query<List<T>?> result = await query.getResult(forceRefetch: true);
      if (result.data != null && result.data!.isNotEmpty) {
        data.addAll(result.data!);
      }
    });
    //TODO: add a try catch

    _state = _state.copyWith(
      data: data,
      timeCreated: DateTime.now(),
      isFetching: false,
      status: QueryStatus.success,
    );
  }

  /// [_getQuery] gets a single query from the global cache
  QueryManager<List<T>> _getQuery({String? queryKey}) {
    queryKey ??= key + currentPage.toString();
    var page = currentPage;
    final query = _globalCache.getQuery<List<T>>(
      key: queryKey,
      queryFn: () => queryFn(page),
      ignoreCacheTime: true,
      ignoreStaleTime: true,
    );
    if (!queryKeys.contains(queryKey)) {
      queryKeys.add(queryKey);
    }

    return query;
  }

  Stream<InfiniteQuery<T>> createStream() {
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

  void updateData(List<T> newData) {
    _state = _state.copyWith(data: newData);
    _streamController?.add(_state);
  }

  void Function() subscribe(subscriber) {
    if (!subscribers.contains(subscriber)) {
      subscribers.add(subscriber);
    }
    unScheduleGC();

    return () => unsubscribe(subscriber);
  }

  void unsubscribe(Subscriber subscriber) {
    subscribers = subscribers.where((e) => e != subscriber).toList();
    if (subscribers.isEmpty) {
      scheduleGC();
    }
  }

  /// After the [cacheTime] is up remove the query from the [GlobalCache]
  void scheduleGC() {
    _gcTimer = Timer(cacheTime, () => deleteQuery());
  }

  /// Cancel the garbage collection if another subscriber is added
  void unScheduleGC() {
    if (_gcTimer?.isActive == true) {
      _gcTimer!.cancel();
    }
  }

  /// invalidate all queries in the infinite query
  void invalidateQuery() {
    stale = true;
    for (final k in queryKeys) {
      _globalCache.invalidateCache(queryHash: k);
    }
  }

  void deleteQuery() {
    for (final k in queryKeys) {
      _globalCache.deleteCache(queryHash: k);
    }
    queryKeys = [];
  }
}
