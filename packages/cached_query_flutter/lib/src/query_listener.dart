import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';

/// {@template queryListenerCallback}
/// Called on each state change.
///
/// Passes [QueryState].
/// {@endtemplate}
typedef QueryListenerCallback<T> = void Function(QueryState<T> state);

/// {@template queryListenerCondition}
/// This function is being called every time the query registered in the [QueryListener] receives new updates
/// and let's you control when the [QueryListenerCallback] should be called
/// {@endtemplate}
typedef QueryListenerCondition<T> = FutureOr<bool> Function(
  QueryState<T> oldState,
  QueryState<T> newState,
);

/// {@template queryListener}
/// Listen to changes in an [Query] and call the listener with the result.
/// {@endtemplate}
class QueryListener<T> extends StatefulWidget {
  /// The [Query] to used to update the listener.
  final Query<T>? query;

  /// {@macro queryListenerCallback}
  final QueryListenerCallback<T> listener;

  /// The key of the query to build.
  ///
  /// If a key is past the listener will look for the corresponding query in the
  /// cache. If no query is found it will through an error.
  final Object? queryKey;

  /// {@macro queryListenerCondition}
  final QueryListenerCondition<T>? listenWhen;

  /// The child widget to render
  final Widget child;

  /// {@macro queryListener}
  const QueryListener({
    Key? key,
    this.query,
    this.queryKey,
    this.listenWhen,
    required this.listener,
    required this.child,
  })  : assert(
          query != null || queryKey != null,
          "Query key or a query must be provided.",
        ),
        super(key: key);

  @override
  State<QueryListener<T>> createState() => _QueryListenerState<T>();
}

class _QueryListenerState<T> extends State<QueryListener<T>> {
  late Query<T> _query;
  late QueryState<T> _previousState;

  StreamSubscription<QueryState<T>>? _subscription;

  @override
  void initState() {
    super.initState();
    if (widget.queryKey != null) {
      final q = CachedQuery.instance.getQuery(widget.queryKey!);
      assert(
        q != null,
        "No query found with the key ${widget.queryKey}, have you created it yet?",
      );
      assert(q is Query<T>, "Query found is not of type $T");
      _query = q! as Query<T>;
    }
    if (widget.query != null) {
      _query = widget.query!;
    }
    _subscribe();
    _previousState = _query.state;
  }

  @override
  void didUpdateWidget(covariant QueryListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldQuery =
        oldWidget.query ?? CachedQuery.instance.getQuery(oldWidget.queryKey!);
    final currentQuery =
        widget.query ?? CachedQuery.instance.getQuery(widget.queryKey!);
    assert(currentQuery is Query<T>, "Query found is not of type $T");
    if (oldQuery != currentQuery) {
      if (_subscription != null) {
        _unsubscribe();
        _query = currentQuery as Query<T>;
        _previousState = _query.state;
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _previousState = _query.state;
    _subscription = _query.stream.listen((state) async {
      final listenWhen = widget.listenWhen;
      if (listenWhen != null) {
        final shouldListen =
            await Future.value(listenWhen(_previousState, state));
        if (!shouldListen) return;
      }
      widget.listener(state);
      _previousState = state;
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
