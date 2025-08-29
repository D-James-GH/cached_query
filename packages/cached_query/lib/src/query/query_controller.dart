// ignore_for_file: public_member_api_docs

part of "./_query.dart";

/// On success is called when the query function is executed successfully.
///
/// Passes the returned data.
typedef OnQuerySuccessCallback<T> = void Function(T data);

/// On success is called when the query function is executed successfully.
///
/// Passes the error through.
typedef OnQueryErrorCallback = void Function(dynamic error);

/// Base class for [QueryController] and [InfiniteQueryController].
class FetchOptions {
  /// Base class for [QueryController] and [InfiniteQueryController].
  const FetchOptions();
}

/// {@template controllerState}
/// Internal state for the query controller.
/// {@endtemplate}
class ControllerState<T> {
  /// The data of the query.
  final T? data;

  /// The time the query was last fetched.
  final DateTime timeCreated;

  /// {@macro controllerState}
  ControllerState({
    required this.data,
    required this.timeCreated,
  });
}

/// {@template QueryController}
/// The [QueryController] is the base class and logic for both [Query] and [InfiniteQuery].
/// {@endtemplate}
final class QueryController<T> {
  /// {@macro queryBase}
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

  /// The function that is called when the query is fetched.
  final Future<T> Function({
    required FetchOptions options,
    T? state,
  }) onFetch;

  /// The current state of the query.
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
    final currentTime = DateTime.now();
    final staleTime = state.timeCreated.add(config.staleDuration);
    return staleTime.isBefore(currentTime) ||
        state.data == null ||
        _invalidated;
  }

  /// The config for this specific query.
  late final QueryConfig<T> config;

  /// Fetches the query.
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
    return setData(newData);
  }

  void setData(T data) {
    _setState(
      ControllerState(
        data: data,
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
    FetchOptions options = const FetchOptions(),
  }) async {
    if ((_hasListener && refetchActive) || refetchInactive) {
      return fetch(forceRefetch: true, options: options);
    }

    markAsStale();
    return Future.value();
  }

  /// Delete the query and query key from cache
  void deleteQuery({bool deleteStorage = false}) {
    _cache.deleteCache(key: key, deleteStorage: deleteStorage);
  }

  /// Add a new query listener.
  void addListener() {
    _cancelDelete();
    _hasListener = true;
  }

  /// Removes a listener from the query.
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
    final data = state.data;
    if (_cache.storage != null && data != null) {
      final dataToStore = switch (config.storageSerializer) {
        null => data,
        _ => config.storageSerializer!(data),
      };
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

    assert(
      data is T,
      "The data type fetched from storage (${data.runtimeType}) does not match the query type ($T). Have you added a storageDeserializer?",
    );

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
