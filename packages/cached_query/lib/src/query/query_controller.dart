part of "./_query.dart";

/// On success is called when the query function is executed successfully.
///
/// Passes the returned data.
typedef OnQuerySuccessCallback<T> = void Function(T data);

/// On success is called when the query function is executed successfully.
///
/// Passes the error through.
typedef OnQueryErrorCallback = void Function(dynamic error);

class FetchOptions {
  const FetchOptions();
}

class ControllerState<T> {
  final T? data;
  final DateTime timeCreated;
  ControllerState({
    required this.data,
    required this.timeCreated,
  });
}

/// {@template queryBase}
/// An Interface for both [Query] and [InfiniteQuery].
/// {@endtemplate}
final class QueryController<T> {
  QueryController({
    required this.key,
    required this.unencodedKey,
    required this.onFetch,
    required T? initialData,
    required QueryConfig<T>? config,
    required CachedQuery cache,
  })  : _cache = cache,
        state = ControllerState(
          timeCreated: DateTime.now(),
          data: initialData,
        ) {
    config ??= QueryConfig<T>();
    this.config = config.mergeWithGlobal(cache.defaultConfig);
  }

  final Future<T> Function({
    required FetchOptions options,
    T? state,
  }) onFetch;

  ControllerState<T> state;

  /// The key used to store and access the query. Encoded using jsonEncode.
  ///
  /// This is created by calling jsonEncode on the passed dynamic key.
  final String key;

  /// The original key.
  final Object unencodedKey;

  bool _invalidated = false;

  /// Whether the current query is marked as stale and therefore requires a
  /// refetch.
  bool get stale {
    return state.timeCreated
            .add(config.refetchDuration)
            .isBefore(DateTime.now()) ||
        state.data == null ||
        _invalidated;
  }

  /// The config for this specific query.
  late final QueryConfig<T> config;

  Future<void> fetch({
    bool forceRefetch = false,
    FetchOptions options = const FetchOptions(),
  }) async {
    _resetDeleteTimer();

    _currentFuture ??= _createResult(
      forceRefetch: forceRefetch,
      options: options,
    );
    await _currentFuture;
  }

  /// Broadcast stream controller that reacts to changes to the query state
  final StreamController<ControllerAction> _streamController =
      StreamController(sync: true);

  bool _hasListener = false;

  Stream<ControllerAction> get stream => _streamController.stream;

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

  /// Update the current query data.
  ///
  /// The [updateFn] passes the current query data and must return new data of
  /// the same type as the original query/infiniteQuery.
  void update(UpdateFunc<T> updateFn) {
    final newData = updateFn(state.data);

    _setState(
      ControllerState(
        data: newData,
        timeCreated: state.timeCreated,
      ),
    );
    _saveToStorage();
  }

  void markAsStale() {
    _invalidated = true;
  }

  Future<void> invalidate({
    bool refetchActive = true,
    bool refetchInactive = false,
  }) async {
    if ((_hasListener && refetchActive) || refetchInactive) {
      return fetch(forceRefetch: true);
    }

    markAsStale();
    return Future.value();
  }

  /// Delete the query and query key from cache
  void deleteQuery({bool deleteStorage = false}) {
    _cache.deleteCache(key: key, deleteStorage: deleteStorage);
  }

  void addListener() {
    _cancelDelete();
    _hasListener = true;
  }

  void removeListener() {
    _hasListener = false;
    _scheduleDelete();
  }

  Future<void> _createResult({
    required bool forceRefetch,
    required FetchOptions options,
  }) async {
    if ((!stale && !forceRefetch) ||
        !config.shouldFetch(key, state.data, state.timeCreated)) {
      return;
    }
    _streamController.add(
      Fetch(fetchOptions: options, isInitialFetch: state.data == null),
    );
    final getFromStorage = state.data == null && config.storeQuery;
    if (getFromStorage) {
      try {
        final storedData = await _fetchFromStorage();
        if (storedData != null) {
          state = ControllerState(
            data: storedData.data,
            timeCreated: storedData.createdAt,
          );
          _streamController.add(DataUpdated(data: state.data));
        }
      } catch (e, s) {
        _streamController.add(StorageError(error: e, stackTrace: s));
      }
    }

    final shouldContinue =
        config.shouldFetch(key, state.data, state.timeCreated);

    if ((stale || forceRefetch) && shouldContinue) {
      try {
        final res = await onFetch(options: options, state: state.data);
        state = ControllerState(data: res, timeCreated: DateTime.now());
        _streamController.add(
          Success(data: state.data, timeCreated: state.timeCreated),
        );
        _saveToStorage();
        if (!_hasListener) {
          _scheduleDelete();
        }
      } catch (e, s) {
        _streamController.add(FetchError(error: e, stackTrace: s));
        if (!_hasListener) {
          _scheduleDelete();
        }
        if (config.shouldRethrow) {
          rethrow;
        }
      }
    } else {
      _streamController.add(
        Success(data: state.data, timeCreated: state.timeCreated),
      );
    }
  }

  /// Sets the new state.
  void _setState(ControllerState<T> newState) {
    state = newState;
    _streamController
        .add(Success(data: state.data, timeCreated: state.timeCreated));
    // for (final observer in _cache.observers) {
    //   observer.onChange(this as QueryBase, newState);
    // }
    // _state = newState;
    // switch (_state) {
    //   case InfiniteQueryError(:final stackTrace) ||
    //         QueryError(:final stackTrace):
    //     for (final observer in _cache.observers) {
    //       observer.onError(this as QueryBase, stackTrace);
    //     }
    //   default:
    //     break;
    // }
    // _emit();
  }

  /// Emits the current state down the stream.
  // void _emit() {
  //   _streamController?.add(_state);
  // }

  void _saveToStorage() {
    if (!config.storeQuery) return;
    if (_cache.storage != null && state.data != null) {
      dynamic dataToStore = state.data;
      if (config.storageSerializer != null) {
        dataToStore = config.storageSerializer!(dataToStore);
      }
      final storedQuery = StoredQuery(
        key: key,
        data: dataToStore,
        createdAt: state.timeCreated,
        storageDuration: config.storageDuration,
      );
      _cache.storage!.put(storedQuery);
    }
  }

  /// If the data is expired this will return null.
  Future<({T data, DateTime createdAt})?> _fetchFromStorage() async {
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
      return (data: data, createdAt: storedData.createdAt);
    }

    return null;
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
    await _streamController.close();
  }
}
