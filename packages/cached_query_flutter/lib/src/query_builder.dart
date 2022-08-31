import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

/// Called on each widget build.
///
/// Passes [BuildContext], [QueryState].
typedef QueryBuilderFunc<T> = Widget Function(
  BuildContext context,
  QueryState<T> state,
);

/// {@template queryBuilder}
/// Listen to changes in an [Query] and build the ui with the result.
/// {@endtemplate}
class QueryBuilder<T> extends StatefulWidget {
  /// The [Query] to used to update the ui.
  final Query<T> query;

  /// Called on each widget build.
  ///
  /// Passes [BuildContext], [QueryState].
  final QueryBuilderFunc<T> builder;

  /// {@macro queryBuilder}
  factory QueryBuilder({
    Key? key,
    required Object queryKey,
    required QueryBuilderFunc<T> builder,
  }) {
    final query = CachedQuery.instance.getQuery(queryKey);
    assert(query != null, "No Query found.");
    assert(
      query is Query<T>,
      "Query is not type $T, is the key an infinite query?",
    );
    return QueryBuilder.value(
      builder: builder,
      query: query as Query<T>,
    );
  }

  /// {@macro queryBuilder}
  ///
  /// The value constructor takes Query object
  const QueryBuilder.value({
    Key? key,
    required this.query,
    required this.builder,
  }) : super(key: key);

  @override
  State<QueryBuilder<T>> createState() => _QueryBuilderState<T>();
}

class _QueryBuilderState<T> extends State<QueryBuilder<T>> {
  late QueryState<T> _state;
  StreamSubscription<QueryState<T>>? _subscription;
  @override
  void initState() {
    super.initState();
    _state = widget.query.state;
    _subscription = widget.query.stream.listen((state) {
      setState(() {
        _state = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _state);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}
