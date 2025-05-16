import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';

/// {@template queryBuilderCallback}
/// Called on each widget build.
///
/// Passes [BuildContext], [QueryState].
/// {@endtemplate}
typedef QueryBuilderCallback<T extends QueryState<dynamic>> = Widget Function(
  BuildContext context,
  T state,
);

/// {@template queryBuilderCondition}
/// This function is being called everytime the query registered in the [QueryBuilder] receives new updates
/// and let's you control when the [_QueryBuilderState.build] method should be called
/// {@endtemplate}
typedef QueryBuilderCondition<T extends QueryState<dynamic>> = FutureOr<bool>
    Function(
  T oldState,
  T newState,
);

/// {@template queryBuilder}
/// Listen to changes in an [Mutation] and build the ui with the result.
/// {@endtemplate}
class QueryBuilder<T extends QueryState<dynamic>> extends StatefulWidget {
  /// The [Query] to used to update the ui.
  final Cacheable<T>? query;

  /// Optional cache used for the query.
  final CachedQuery? cache;

  /// Whether the query should be called immediately.
  final bool enabled;

  /// {@macro queryBuilderCallback}
  final QueryBuilderCallback<T> builder;

  /// The key of the query to build.
  ///
  /// If a key is past the builder will look for the corresponding query in the
  /// cache. If no query is found it will through an error.
  final Object? queryKey;

  /// {@macro queryBuilderCondition}
  final QueryBuilderCondition<T>? buildWhen;

  /// {@macro queryBuilder}
  const QueryBuilder({
    super.key,
    this.query,
    this.cache,
    this.enabled = true,
    this.queryKey,
    this.buildWhen,
    required this.builder,
  }) : assert(
          query != null || queryKey != null,
          "Query key or a query must be provided.",
        );

  @override
  State<QueryBuilder<T>> createState() => _QueryBuilderState<T>();
}

class _QueryBuilderState<T extends QueryState<dynamic>>
    extends State<QueryBuilder<T>> {
  late Cacheable<T> _query;
  late T _state;
  late final CachedQuery _cache;

  StreamSubscription<QueryState<dynamic>>? _subscription;

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
      _query = q!;
    }
    if (widget.query != null) {
      _query = widget.query!;
    }
    _subscribe();

    _state = _query.state;
  }

  @override
  void didUpdateWidget(covariant QueryBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldQuery = oldWidget.query ?? _cache.getQuery(oldWidget.queryKey!);
    final currentQuery = widget.query ?? _cache.getQuery(widget.queryKey!);
    assert(
      currentQuery is Cacheable<T>,
      "Query found is not of type $T",
    );
    assert(
      currentQuery != null,
      "No query found with the key ${widget.queryKey}, have you created it yet?",
    );
    if (oldQuery != currentQuery) {
      if (_subscription != null) {
        _unsubscribe();
        _query = currentQuery!;
        _state = _query.state;
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
    return widget.builder(context, _state);
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _state = _query.state;
    if (!widget.enabled) {
      if (_subscription != null) {
        _unsubscribe();
      }
      return;
    }
    _subscription = _query.stream.listen((state) async {
      if (widget.buildWhen != null) {
        final shouldRebuild = await Future.value(
          widget.buildWhen!.call(_state, state),
        );
        if (!shouldRebuild) return;
      }
      setState(() => _state = state);
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
