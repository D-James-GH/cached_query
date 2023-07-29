import 'dart:async';

import 'package:cached_query/src/util/encode_key.dart';

import '../cached_query.dart';
import 'mutation_cache.dart';

/// Called when the [queryFn] as completed with no error.
typedef OnSuccessCallback<T, Arg> = FutureOr<void> Function(T res, Arg arg);

/// Called when the [queryFn] as completed with an error.
typedef OnErrorCallback<Arg> = FutureOr<void> Function(
  Arg arg,
  Object error,
  Object? fallback,
);

/// Called when [Mutation] has started.
typedef OnStartMutateCallback<Arg> = FutureOr<dynamic> Function(Arg arg);

/// The asynchronous query function.
typedef MutationQueryCallback<ReturnType, Arg> = Future<ReturnType> Function(
  Arg arg,
);

/// {@template mutation}
/// Mutation is used to create, update and delete data from an asynchronous
/// source.
///
/// Add a [key] for referencing the mutation. Useful to listen to the state of the
/// mutation in multiple places in the app. If null no mutation cache will be
/// set. [key] must be a serializable value.
///
/// The mutation is an asynchronous [queryFn]. It should return a [Future] of
/// type [ReturnType] and takes any argument of type [Arg].
///
/// The mutation takes multiple lifecycle callbacks:
/// - [onStartMutation] is called before the mutation [_queryFn] is run.
/// - [onSuccess] is called after the [_queryFn] has completed with no error.
/// - [onError] is called if the [queryFn] throws and error.
///
/// After a mutation it is common to [invalidateQueries]. Pass a list of query
/// keys to [invalidateQueries] and next time they are called they will be fetched.
/// Alternatively for more control of when invalidation happens use
/// [invalidateQuery] at any time.
///
/// To invalidate and refetch a query use [refetchQueries]
/// {@endtemplate mutation}
class Mutation<ReturnType, Arg> {
  /// A stringified key to reference the mutation.
  final String? key;

  final OnStartMutateCallback<Arg>? _onStartMutation;
  final OnSuccessCallback<ReturnType, Arg>? _onSuccess;
  final OnErrorCallback<Arg>? _onError;
  final MutationQueryCallback<ReturnType, Arg> _queryFn;
  final List<Object>? _invalidateQueries;
  final List<Object>? _refetchQueries;
  MutationState<ReturnType> _state;
  StreamController<MutationState<ReturnType>>? _streamController;
  final _cache = MutationCache.instance;

  /// Current [MutationState] of the mutation.
  MutationState<ReturnType> get state => _state;

  /// Stream the state of the query.
  ///
  /// When the state is updated either by a mutation or a new query [stream]
  /// will be notified.
  Stream<MutationState<ReturnType>> get stream => _createStream();

  Mutation._internal({
    this.key,
    OnStartMutateCallback<Arg>? onStartMutation,
    OnSuccessCallback<ReturnType, Arg>? onSuccess,
    OnErrorCallback<Arg>? onError,
    required MutationQueryCallback<ReturnType, Arg> queryFn,
    List<Object>? invalidateQueries,
    List<Object>? refetchQueries,
  })  : _queryFn = queryFn,
        _invalidateQueries = invalidateQueries,
        _onError = onError,
        _onStartMutation = onStartMutation,
        _onSuccess = onSuccess,
        _refetchQueries = refetchQueries,
        _state = MutationState<ReturnType>() {
    if (key != null) {
      _cache.addMutation(this);
    }
  }

  /// {@macro mutation}
  factory Mutation({
    Object? key,
    OnStartMutateCallback<Arg>? onStartMutation,
    OnSuccessCallback<ReturnType, Arg>? onSuccess,
    OnErrorCallback<Arg>? onError,
    required MutationQueryCallback<ReturnType, Arg> queryFn,
    List<Object>? invalidateQueries,
    List<Object>? refetchQueries,
  }) {
    String? stringKey;
    if (key != null) {
      stringKey = encodeKey(key);
      final mutationFromCache =
          MutationCache.instance.getMutation<ReturnType, Arg>(stringKey);
      if (mutationFromCache != null) {
        CachedQuery.instance.observer.onMutationCreation(mutationFromCache);
        return mutationFromCache;
      }
    }
    final mutation = Mutation._internal(
      key: stringKey,
      onStartMutation: onStartMutation,
      onSuccess: onSuccess,
      onError: onError,
      invalidateQueries: invalidateQueries,
      refetchQueries: refetchQueries,
      queryFn: queryFn,
    );
    CachedQuery.instance.observer.onMutationCreation(mutation);
    return mutation;
  }

  /// Starts the mutation with the given [arg].
  Future<ReturnType?> mutate([Arg? arg]) async {
    // type cast so that void doesn't require an argument
    arg = arg as Arg;
    return _fetch(arg);
  }

  Stream<MutationState<ReturnType>> _createStream() {
    if (_streamController != null) {
      return _streamController!.stream;
    }
    _streamController = StreamController.broadcast(
      onListen: _emit,
      onCancel: () {
        _streamController!.close();
        _streamController = null;
        if (key != null) {
          _cache.deleteMutation(key!);
        }
      },
    );

    return _streamController!.stream;
  }

  Future<ReturnType?> _fetch(Arg arg) async {
    _setState(_state.copyWith(status: QueryStatus.loading));
    _emit();
    dynamic startMutationResponse;
    if (_onStartMutation != null) {
      startMutationResponse = await _onStartMutation!(arg);
    }
    // call query fn
    try {
      final res = await _queryFn(arg);
      if (_onSuccess != null) {
        await _onSuccess!(res, arg);
      }
      _setState(_state.copyWith(status: QueryStatus.success, data: res));
      if (_invalidateQueries != null) {
        for (final k in _invalidateQueries!) {
          CachedQuery.instance.invalidateCache(key: k);
        }
      }
      if (_refetchQueries != null) {
        CachedQuery.instance.refetchQueries(keys: _refetchQueries!);
      }
      return res;
    } catch (e, trace) {
      if (_onError != null) {
        await _onError!(arg, e, startMutationResponse);
      }
      _setState(
        _state.copyWith(status: QueryStatus.error, error: e),
        trace,
      );

      return null;
    } finally {
      _emit();
    }
  }

  void _setState(MutationState<ReturnType> newState, [StackTrace? stackTrace]) {
    CachedQuery.instance.observer.onMutationChange(this, newState);
    _state = newState;
    if (stackTrace != null) {
      CachedQuery.instance.observer.onMutationError(this, stackTrace);
    }
  }

  void _emit() {
    _streamController?.add(_state);
  }
}

/// {@template mutationState}
/// [MutationState] holds the current state of an [InfiniteQuery].
///
/// Should not be instantiated manually. Instead should be read from [Mutation].
/// {@endtemplate}
class MutationState<ReturnType> {
  /// Response of the [MutationQueryCallback].
  final ReturnType? data;

  /// Status of the [MutationQueryCallback].
  final QueryStatus status;

  /// Current error of the [MutationQueryCallback].
  final dynamic error;

  /// {@macro mutationState}
  const MutationState({
    this.data,
    this.status = QueryStatus.initial,
    this.error,
  });

  /// Creates a copy of the current [MutationState] with the given filed
  /// replaced.
  MutationState<ReturnType> copyWith({
    ReturnType? data,
    QueryStatus? status,
    dynamic error,
  }) {
    return MutationState(
      data: data ?? this.data,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MutationState &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          status == other.status &&
          error == other.error;

  @override
  int get hashCode => data.hashCode ^ status.hashCode ^ error.hashCode;
}
