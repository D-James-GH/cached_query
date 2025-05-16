import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';

/// {@template queryListenerCallback}
/// Called on each state change.
///
/// Passes [QueryState].
/// {@endtemplate}
typedef QueryListenerCallback<T extends QueryState<dynamic>> = void Function(
  T state,
);

/// {@template queryListenerCondition}
/// This function is being called every time the query registered in the [QueryListener] receives new updates
/// and let's you control when the [QueryListenerCallback] should be called
/// {@endtemplate}
typedef QueryListenerCondition<T extends QueryState<dynamic>> = FutureOr<bool>
    Function(
  T oldState,
  T newState,
);

/// {@template queryListener}
/// Listen to changes in an [Query] and call the listener with the result.
/// {@endtemplate}
class QueryListener<T extends QueryState<dynamic>> extends StatefulWidget {
  /// The [Query] to used to update the listener.
  final Cacheable<T>? query;

  /// Whether the query should be called immediately.
  final bool enabled;

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

  /// Optional cache used for the query.
  final CachedQuery? cache;

  /// {@macro queryListener}
  const QueryListener({
    super.key,
    this.enabled = true,
    this.cache,
    this.query,
    this.queryKey,
    this.listenWhen,
    required this.listener,
    required this.child,
  }) : assert(
          query != null || queryKey != null,
          "Query key or a query must be provided.",
        );

  @override
  State<QueryListener<T>> createState() => _QueryListenerState<T>();
}

class _QueryListenerState<T extends QueryState<dynamic>>
    extends State<QueryListener<T>> {
  late Cacheable<T> _query;
  late T _previousState;
  late final CachedQuery _cache;

  StreamSubscription<T>? _subscription;

  @override
  void initState() {
    super.initState();
    _cache = widget.cache ?? CachedQuery.instance;

    if (widget.queryKey != null) {
      final q = _cache.getQuery<T>(widget.queryKey!);
      assert(
        q != null,
        "No query found with the key ${widget.queryKey}, have you created it yet?",
      );
      assert(
        q is Cacheable<T>,
        "Query found is not of type QueryBase<dynamic, $T>",
      );
      _query = q!;
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
    final oldQuery = oldWidget.query ?? _cache.getQuery(oldWidget.queryKey!);
    final currentQuery = widget.query ?? _cache.getQuery(widget.queryKey!);
    assert(
      currentQuery is Cacheable<T>,
      "Query found is not of type $T",
    );
    if (oldQuery != currentQuery) {
      if (_subscription != null) {
        _unsubscribe();
        _query = currentQuery!;
        _previousState = _query.state;
      }
      if (widget.enabled) {
        _subscribe();
        return;
      }
    }

    if (oldWidget.enabled != widget.enabled) {
      if (widget.enabled) {
        _subscribe();
      } else {
        _unsubscribe();
      }
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
    if (!widget.enabled) {
      if (_subscription != null) {
        _unsubscribe();
      }
      return;
    }
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
