import 'dart:async';

/// The [Zone] key used to store the active [CancelToken] while a query function
/// is being executed.
///
/// This is an opaque [Object] to guarantee it cannot collide with any other
/// zone value used by the host application.
final Object cancelTokenZoneKey = Object();

/// {@template QueryCancelledException}
/// Thrown by [CancelToken.throwIfCancelled] to cooperatively abort pure-Dart
/// work when a query has been cancelled.
/// {@endtemplate}
class QueryCancelledException implements Exception {
  /// The optional reason the query was cancelled with.
  final Object? reason;

  /// {@macro QueryCancelledException}
  const QueryCancelledException([this.reason]);

  @override
  String toString() {
    if (reason == null) {
      return 'QueryCancelledException';
    }
    return 'QueryCancelledException: $reason';
  }
}

/// {@template CancelToken}
/// A client-agnostic cancellation signal handed to a query function while it is
/// being fetched.
///
/// A [CancelToken] is only a *signal* - completing it does not by itself stop a
/// Dart [Future]. To actually abort an in-flight request, wire [whenCancelled]
/// (or [isCancelled]) into an HTTP client that supports aborting, for example
/// `package:http` (>= 1.5.0) via `AbortableRequest.abortTrigger`, or
/// `package:dio` via its own `CancelToken`.
///
/// The active token is not passed as an argument. Instead it is read from
/// within the query function via `CachedQuery.instance.currentCancelToken`:
///
/// ```dart
/// Query<Post>(
///   key: 'post',
///   queryFn: () async {
///     final token = CachedQuery.instance.currentCancelToken;
///     final res = await client.send(
///       AbortableRequest(
///         'GET',
///         uri,
///         abortTrigger: token?.whenCancelled,
///       ),
///     );
///     return Post.fromResponse(res);
///   },
/// );
/// ```
/// {@endtemplate}
class CancelToken {
  final Completer<void> _completer = Completer<void>();
  Object? _reason;

  /// {@macro CancelToken}
  CancelToken();

  /// Whether cancellation has been requested for this token.
  bool get isCancelled => _completer.isCompleted;

  /// The reason the token was cancelled with, if any.
  Object? get reason => _reason;

  /// A [Future] that completes when cancellation is requested.
  ///
  /// This maps directly to `package:http`'s `AbortableRequest.abortTrigger`.
  Future<void> get whenCancelled => _completer.future;

  /// Throws a [QueryCancelledException] if the token has been cancelled.
  ///
  /// Use this as a cooperative cancellation point for pure-Dart work that does
  /// not go through an abortable HTTP client.
  void throwIfCancelled() {
    if (isCancelled) {
      throw QueryCancelledException(_reason);
    }
  }

  /// Requests cancellation, optionally with a [reason].
  ///
  /// This is called internally by cached_query when a query is cancelled. It is
  /// safe to call multiple times; only the first call has any effect.
  void cancel([Object? reason]) {
    if (isCancelled) return;
    _reason = reason;
    _completer.complete();
  }
}
