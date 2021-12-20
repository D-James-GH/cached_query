import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';

///
class QueryBuilder<T> extends StatefulWidget {
  final Query<T> query;
  final Widget Function(BuildContext context, QueryState<T> state) builder;

  const QueryBuilder({
    Key? key,
    required this.query,
    required this.builder,
  }) : super(key: key);

  @override
  _QueryBuilderState<T> createState() => _QueryBuilderState<T>();
}

class _QueryBuilderState<T> extends State<QueryBuilder<T>> {
  late QueryState<T> _state;
  late StreamSubscription<QueryState<T>> _subscription;
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
    _subscription.cancel();
    super.dispose();
  }
}
