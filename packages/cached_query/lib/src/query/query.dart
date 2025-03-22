part of '_query.dart';

/// The result of the [QueryFunc] will be cached.
typedef QueryFunc<T> = Future<T> Function();

/// {@template query}
/// [Query] is will fetch and cache the response of the [queryFn].
///
/// The [queryFn] must be asynchronous and the result is cached.
///
/// [Query] takes a [key] to identify and store it in the global cache. The [key]
/// can be any serializable data. The [key] is converted to a [String] using
/// [jsonEncode].
///
/// Each [Query] can override the global defaults for [refetchDuration], [cacheDuration],
/// see [CachedQuery.config] for more info.
///
/// Use [forceRefetch] to force the query to be run again regardless of whether
/// the query is stale or not.
///
/// To run side effects if the query function is successful or not use [onSuccess] and
/// [onError].
///
/// {@endtemplate}
final class Query<T> extends QueryController<T, QueryStatus<T>>
    implements QueryBase {
  Query._internal({
    OnQueryErrorCallback<T>? onError,
    OnQuerySuccessCallback<T>? onSuccess,
    required super.cache,
    required super.key,
    required super.unencodedKey,
    required super.config,
    required Future<T> Function() queryFn,
    required T? initialData,
  })  : _queryFn = queryFn,
        _onError = onError,
        _onSuccess = onSuccess,
        super._internal(
          state: QueryInitial(
            timeCreated: DateTime.now(),
            data: initialData,
          ),
        );

  /// {@macro query}
  factory Query({
    required Object key,
    required Future<T> Function() queryFn,
    OnQueryErrorCallback<T>? onError,
    OnQuerySuccessCallback<T>? onSuccess,
    T? initialData,
    QueryConfig? config,
    CachedQuery? cache,
  }) {
    cache = cache ?? CachedQuery.instance;
    var query = cache.getQuery(key) as Query<T>?;

    // if query is null check the storage
    if (query == null) {
      query = Query<T>._internal(
        cache: cache,
        key: encodeKey(key),
        unencodedKey: key,
        queryFn: queryFn,
        onError: onError,
        onSuccess: onSuccess,
        initialData: initialData,
        config: config,
      );
      cache.addQuery(query);
    }

    return query;
  }

  final Future<T> Function() _queryFn;

  /// On success is called when the query function is executed successfully.
  ///
  /// Passes the returned data.
  final OnQuerySuccessCallback<T>? _onSuccess;

  /// On success is called when the query function is executed successfully.
  ///
  /// Passes the error through.
  final OnQueryErrorCallback<T>? _onError;

  Future<void> _fetch({required bool initialFetch}) async {
    _setState(
      QueryLoading(
        isInitialFetch: initialFetch,
        timeCreated: _state.timeCreated,
        isRefetching: !initialFetch,
        data: _state.data,
      ),
    );
    try {
      if (_state.data == null && config.storeQuery) {
        // try to get any data from storage if the query has no data
        final storedData = await _fetchFromStorage();
        if (storedData != null) {
          _setState(_state.copyWithData(storedData));
          final shouldRefetch = config.shouldRefetch?.call(this, true) ?? true;
          if (!shouldRefetch) {
            return;
          }
        }
      }

      final res = await _queryFn();
      if (_onSuccess != null) {
        _onSuccess!(res);
      }
      _setState(QuerySuccess(timeCreated: DateTime.now(), data: res));
      if (config.storeQuery) {
        _saveToStorage();
      }
    } catch (e, trace) {
      if (_onError != null) {
        _onError!(e);
      }
      _setState(
        QueryError(
          error: e,
          data: _state.data,
          stackTrace: trace,
          timeCreated: _state.timeCreated,
        ),
      );
      if (config.shouldRethrow) {
        rethrow;
      }
    }
  }
}
