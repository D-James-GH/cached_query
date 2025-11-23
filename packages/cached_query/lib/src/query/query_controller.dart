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

abstract interface class FetchFunction<T> {
  Future<T> call({
    required FetchOptions options,
    T? state,
  });
}

class EmptyFetchFunction<T> implements FetchFunction<T> {
  @override
  Future<T> call({
    required FetchOptions options,
    T? state,
  }) {
    throw UnimplementedError(
      "No fetch function has been provided for this query. This is likely because the query has been created through 'update'",
    );
  }
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
    required Option<T>? initialData,
    required ControllerOptions<T> config,
    required CachedQuery cache,
  })  : _cache = cache,
        _config = config,
        stateNotifier = QueryStateNotifier(
          ControllerState(
            timeCreated: DateTime.now(),
            data: initialData ?? Option.none(),
          ),
        );

  ControllerOptions<T> _config;
  ControllerOptions<T> get config => _config;
  final List<Cacheable<QueryState<T>>> _listeners = [];

  /// The function that is called when the query is fetched.
  FetchFunction<T> onFetch;

  /// The key used to store and access the query. Encoded using jsonEncode.
  ///
  /// This is created by calling jsonEncode on the passed dynamic key.
  final String key;

  /// The original key.
  final Object unencodedKey;

  bool _invalidated = false;

  bool isInvalidated() {
    return _invalidated || stateNotifier.value.data.isNone;
  }

  bool isStaleOrInvalidated(Duration duration) {
    return isInvalidated() || isStaleFromDuration(duration);
  }

  bool isStaleFromDuration(Duration duration) {
    final currentTime = DateTime.now();
    final staleTime = stateNotifier.value.timeCreated.add(duration);
    return staleTime.isBefore(currentTime);
  }

  bool _isStale() {
    if (isInvalidated()) {
      return true;
    }
    return _listeners.any((q) {
      return q.stale;
    });
  }

  final QueryStateNotifier<T> stateNotifier;

  ///
  bool get isActive => _listeners.any((q) => q.hasListener);
  bool get hasListeners => _listeners.isNotEmpty;

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

  /// Fetches the query.
  Future<void> fetch({
    bool ignoreStale = false,
    FetchOptions options = const FetchOptions(),
  }) async {
    _resetDeleteTimer();

    _currentFuture ??= _createResult(
      ignoreStale: ignoreStale,
      options: options,
    );
    await _currentFuture;
  }

  /// Update the current query data.
  ///
  /// The [updateFn] passes the current query data and must return new data of
  /// the same type as the original query/infiniteQuery.
  void update(UpdateFunc<T> updateFn) {
    final newData = updateFn(stateNotifier.value.data.valueOrNull);
    return setData(newData);
  }

  void updateConfig({ControllerOptions<T>? config, FetchFunction<T>? fetchFn}) {
    if (config != null) {
      _config = config;
    }
    if (fetchFn != null) {
      onFetch = fetchFn;
    }
  }

  void setData(T data) {
    final newData = Some(data);
    stateNotifier.add(
      DataUpdated(
        data: newData.value,
        timeCreated: stateNotifier.value.timeCreated,
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
    markAsStale();
    if ((isActive && refetchActive) || refetchInactive) {
      return fetch(options: options);
    }

    return Future.value();
  }

  /// Delete the query and query key from cache
  void deleteQuery({bool deleteStorage = false}) {
    _cache.deleteCache(key: key, deleteStorage: deleteStorage);
  }

  /// Add a new query listener.
  void registerQuery(Cacheable<QueryState<T>> query) {
    if (!_listeners.contains(query)) {
      _listeners.add(query);
    }
    _cancelDelete();
  }

  /// Removes a listener from the query.
  void removeRegisteredQuery(Cacheable<QueryState<T>> query) {
    _listeners.remove(query);
    if (_listeners.isEmpty) {
      scheduleDelete();
    }
  }

  Future<void> _createResult({
    required bool ignoreStale,
    required FetchOptions options,
  }) async {
    final shouldFetch = _listeners.every(
      (q) {
        final config = q.config as QueryConfig<T>;
        return config.shouldFetch(
          key,
          stateNotifier.value.data.valueOrNull,
          stateNotifier.value.timeCreated,
        );
      },
    );
    if (!shouldFetch) {
      return;
    }
    stateNotifier.add(
      Fetch(
        fetchOptions: options,
        isInitialFetch: stateNotifier.value.data.isNone,
      ),
    );
    final getFromStorage =
        stateNotifier.value.data.isNone && _config.storeQuery;
    if (getFromStorage) {
      try {
        final storedData = await _fetchFromStorage();
        if (storedData != null) {
          final newData = Some(storedData.data);
          stateNotifier.add(
            DataUpdated(
              data: newData.value,
              timeCreated: storedData.createdAt,
            ),
          );
        }
      } catch (e, s) {
        stateNotifier.add(StorageError(error: e, stackTrace: s));
      }
    }

    final shouldContinue = _listeners.every(
      (q) {
        final config = q.config as QueryConfig<T>;
        return config.shouldFetch(
          key,
          stateNotifier.value.data.valueOrNull,
          stateNotifier.value.timeCreated,
        );
      },
    );

    // Data from storage may be considered fresh, so we need to check if the query is stale.
    final stale = _isStale();

    if ((stale || ignoreStale) && shouldContinue) {
      try {
        final res = await onFetch(
          options: options,
          state: stateNotifier.value.data.valueOrNull,
        );
        final newData = Some(res);
        stateNotifier.add(
          Success(data: newData, timeCreated: DateTime.now()),
        );
        _saveToStorage();
        scheduleDelete();
      } catch (e, s) {
        stateNotifier.add(FetchError(error: e, stackTrace: s));
        scheduleDelete();
      }
    } else {
      stateNotifier.add(
        // Nothing has failed but the data might be missing.
        Success(
          data: stateNotifier.value.data,
          timeCreated: stateNotifier.value.timeCreated,
        ),
      );
    }
  }

  void _saveToStorage() {
    if (!_config.storeQuery) return;
    final data = stateNotifier.value.data;
    if (_cache.storage == null) return;

    if (data case Some(:final value)) {
      final dataToStore = switch (_config.storageSerializer) {
        null => value,
        _ => _config.storageSerializer!(value)
      };
      final storedQuery = StoredQuery(
        key: key,
        data: dataToStore,
        createdAt: stateNotifier.value.timeCreated,
        storageDuration: _config.storageDuration,
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
        storedData?.storageDuration != _config.storageDuration;

    if (storedData == null ||
        storedData.isExpired ||
        storedData.data == null ||
        expiryHasChanged) {
      return null;
    }

    dynamic data = storedData.data;

    if (_config.storageDeserializer != null) {
      data = _config.storageDeserializer!(storedData.data);
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
  void scheduleDelete() {
    if (!isActive) {
      if (!_config.ignoreCacheDuration) {
        _deleteQueryTimer = Timer(_config.cacheDuration, deleteQuery);
      }
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
      _deleteQueryTimer = Timer(_config.cacheDuration, deleteQuery);
    }
  }

  /// Closes the stream and therefore starts the delete timer.
  Future<void> close() async {
    stateNotifier.close();
    _listeners.clear();
  }

  Future<void> dispose() async {
    if (_deleteQueryTimer?.isActive ?? false) {
      _deleteQueryTimer!.cancel();
      _deleteQueryTimer = null;
    }
    await close();
    deleteQuery();
  }
}
