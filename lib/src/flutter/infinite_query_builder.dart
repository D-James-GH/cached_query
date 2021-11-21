import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';

class InfiniteQueryBuilder<T> extends StatefulWidget {
  final InfiniteQuery<T> query;
  final Widget Function(BuildContext context, InfiniteQueryState<T> state,
      InfiniteQuery<T> query) builder;
  const InfiniteQueryBuilder(
      {Key? key, required this.query, required this.builder})
      : super(key: key);

  @override
  _InfiniteQueryBuilderState<T> createState() =>
      _InfiniteQueryBuilderState<T>();
}

class _InfiniteQueryBuilderState<T> extends State<InfiniteQueryBuilder<T>> {
  late InfiniteQueryState<T> _state;
  late StreamSubscription<InfiniteQueryState<T>> _subscription;

  @override
  void initState() {
    super.initState();
    _state = widget.query.state;
    _subscription = widget.query.stream.listen((event) {
      setState(() {
        _state = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _state, widget.query);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
