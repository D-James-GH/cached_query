import 'dart:async';
import 'dart:convert';

import 'package:cached_query/cached_query.dart';
import './global_cache.dart';
import 'package:cached_query/src/util/encode_key.dart';

typedef OnSuccessCallback<T, A> = void Function(T res, A arg);
typedef OnErrorCallback<A> = void Function(A arg, Object error);
typedef OnStartMutateCallback<A> = void Function(A arg);
typedef MutationCallback<T, A> = Future<T> Function(A arg);

/// {@template mutation}
/// Mutation is normally used to create, update and delete data from an asynchronous
/// source.
/// Add a [key] for referencing the mutation. Useful to listen to the state of the
/// mutation in multiple places in the app. If null no mutation cache will be
/// set. [key] must be a serializable value.
///
/// The mutation is an asynchronous [queryFn]. It should return a [Future] of
/// type [T] and takes any argument of type [A].
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
class Mutation<T, A> {
  /// A stringified key to reference the mutation
  final String? key;

  /// This is called is before the mutation [_queryFn] is run.
  final OnStartMutateCallback<A>? _onStartMutation;

  /// This is called after the [_queryFn] has completed with no error.
  final OnSuccessCallback<T, A>? _onSuccess;

  /// [_onError] is called if the [queryFn] throws and error.
  final OnErrorCallback<A>? _onError;
  final MutationCallback<T, A> _queryFn;
  final List<Object>? _invalidateQueries;
  final List<Object>? _refetchQueries;

  /// current state of the mutation
  MutationState<T> _state = MutationState();

  /// broadcast stream that reacts to changes to the mutation state
  StreamController<MutationState<T>>? _streamController;
  Future<T?>? _currentFuture;

  Mutation._internal({
    this.key,
    OnStartMutateCallback<A>? onStartMutation,
    OnSuccessCallback<T, A>? onSuccess,
    OnErrorCallback<A>? onError,
    required MutationCallback<T, A> queryFn,
    List<Object>? invalidateQueries,
    List<Object>? refetchQueries,
  })  : _queryFn = queryFn,
        _invalidateQueries = invalidateQueries,
        _onError = onError,
        _onStartMutation = onStartMutation,
        _onSuccess = onSuccess,
        _refetchQueries = refetchQueries {
    if (key != null) {
      GlobalCache.instance.addMutation(this);
    }
  }

  /// {@macro mutation}
  factory Mutation({
    Object? key,
    OnStartMutateCallback<A>? onStartMutation,
    OnSuccessCallback<T, A>? onSuccess,
    OnErrorCallback<A>? onError,
    required MutationCallback<T, A> queryFn,
    List<Object>? invalidateQueries,
    List<Object>? refetchQueries,
  }) {
    String? stringKey;
    if (key != null) {
      stringKey = encodeKey(key);
      final mutationFromCache =
          GlobalCache.instance.getMutation<T, A>(stringKey);
      if (mutationFromCache != null) {
        return mutationFromCache;
      }
    }
    return Mutation._internal(
      key: stringKey,
      onStartMutation: onStartMutation,
      onSuccess: onSuccess,
      onError: onError,
      invalidateQueries: invalidateQueries,
      refetchQueries: refetchQueries,
      queryFn: queryFn,
    );
  }

  /// {@macro mutation}
  ///
  /// The mutate factory will call [mutate] with the given [arg] immediately.
  ///
  /// If [Mutation.mutate] is given a key it will always override anything in the
  /// mutation cache.
  factory Mutation.mutate({
    Object? key,
    required A arg,
    OnStartMutateCallback<A>? onStartMutation,
    OnSuccessCallback<T, A>? onSuccess,
    OnErrorCallback<A>? onError,
    required MutationCallback<T, A> queryFn,
    List<Object>? invalidateQueries,
    List<Object>? refetchQueries,
  }) {
    final mutation = Mutation._internal(
      queryFn: queryFn,
      onSuccess: onSuccess,
      onStartMutation: onStartMutation,
      onError: onError,
      invalidateQueries: invalidateQueries,
      refetchQueries: refetchQueries,
    )..mutate(arg);
    return mutation;
  }

  MutationState<T> get state => _state;

  Stream<MutationState<T>> get stream {
    if (_streamController != null) {
      return _streamController!.stream;
    }
    _streamController = StreamController.broadcast(
      onListen: _emit,
      onCancel: () {
        _streamController!.close();
        _streamController = null;
        if (key != null) {
          GlobalCache.instance.deleteMutation(key!);
        }
      },
    );

    return _streamController!.stream;
  }

  /// Starts the mutation with the [arg].
  ///
  /// The [mutate] is de-duplicated if called again while the future is completing.
  /// After that [mutate] may be called again with different [arg]'s.
  Future<T?> mutate(A arg) async {
    if (_currentFuture != null) {
      return _currentFuture!;
    }
    _currentFuture = _fetch(arg);
    return _currentFuture!;
  }

  Future<T?> _fetch(A arg) async {
    _setState(_state.copyWith(status: QueryStatus.loading, isFetching: true));
    _emit();
    if (_onStartMutation != null) {
      _onStartMutation!(arg);
    }
    // call query fn
    try {
      final res = await _queryFn(arg);
      if (_onSuccess != null) {
        _onSuccess!(res, arg);
      }
      _setState(_state.copyWith(status: QueryStatus.success, data: res));
      if (_invalidateQueries != null) {
        for (final k in _invalidateQueries!) {
          GlobalCache.instance.invalidateCache(key: encodeKey(k));
        }
      }
      if (_refetchQueries != null) {
        refetchQueries(_refetchQueries!.map(jsonEncode).toList());
      }
      return res;
    } catch (e) {
      if (_onError != null) {
        _onError!(arg, e);
      }
      _setState(_state.copyWith(status: QueryStatus.error));
      rethrow;
    } finally {
      _currentFuture = null;
      _setState(_state.copyWith(isFetching: false));
      _emit();
    }
  }

  void _setState(MutationState<T> newState) {
    _state = newState;
  }

  void _emit() {
    _streamController?.add(_state);
  }
}

class MutationState<T> {
  final T? data;
  final QueryStatus status;
  final bool isFetching;
  final dynamic error;

  const MutationState({
    this.data,
    this.status = QueryStatus.initial,
    this.isFetching = false,
    this.error = null,
  });

  MutationState<T> copyWith({
    T? data,
    QueryStatus? status,
    bool? isFetching,
    dynamic error,
  }) {
    return MutationState(
      data: data ?? this.data,
      status: status ?? this.status,
      isFetching: isFetching ?? this.isFetching,
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
          isFetching == other.isFetching &&
          error == other.error;

  @override
  int get hashCode =>
      data.hashCode ^ status.hashCode ^ isFetching.hashCode ^ error.hashCode;
}
