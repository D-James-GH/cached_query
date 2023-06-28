import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';

/// {@template queryBuilder}
/// Listen to changes in an [Mutation] and build the ui with the result.
/// {@endtemplate}
class QueryBuilder<T> extends StatefulWidget {
  /// The [Query] to used to update the ui.
  final Query<T>? query;

  /// Called on each widget build.
  ///
  /// Passes [BuildContext], [QueryState].
  final Widget Function(BuildContext context, QueryState<T> state) builder;

  /// The key of the query to build.
  ///
  /// If a key is past the builder will look for the corresponding query in the
  /// cache. If no query is found it will through an error.
  final Object? queryKey;

  /// This function is being called everytime the query registered in the [QueryBuilder] receives new updates
  /// and let's you control when the [_QueryBuilderState.build] method should be called
  final FutureOr<bool> Function(
    QueryState<T> oldState,
    QueryState<T> newState,
  )? buildWhen;

  /// {@macro queryBuilder}
  const QueryBuilder({
    Key? key,
    this.query,
    this.queryKey,
    this.buildWhen,
    required this.builder,
  })  : assert(
          query != null || queryKey != null,
          "Query key or a query must be provided.",
        ),
        super(key: key);

  @override
  State<QueryBuilder<T>> createState() => _QueryBuilderState<T>();
}

class _QueryBuilderState<T> extends State<QueryBuilder<T>> {
  late Query<T> _query;
  late QueryState<T> _state;

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
    _state = _query.state;
  }

  @override
  void didUpdateWidget(covariant QueryBuilder<T> oldWidget) {
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
        _state = _query.state;
      }
      _subscribe();
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
