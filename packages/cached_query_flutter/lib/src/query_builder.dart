import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';

/// {@template queryBuilder}
/// Listen to changes in an [Mutation] and build the ui with the result.
/// {@endtemplate}
class QueryBuilder<T> extends StatefulWidget {
  /// The [Query] to used to update the ui.
  final Query<T> query;

  /// Called on each widget build.
  ///
  /// Passes [BuildContext], [QueryState].
  final Widget Function(BuildContext context, QueryState<T> state) builder;

  /// {@macro queryBuilder}
  const QueryBuilder({
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
    _subscription!.cancel();
    _subscription = null;
    super.dispose();
  }
}
