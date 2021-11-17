import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';

///
class QueryBuilder<T> extends StatefulWidget {
  final Future<T> Function() queryFn;
  final dynamic queryKey;
  final Widget Function(Query<T>? state) builder;

  const QueryBuilder(
    this.queryKey, {
    Key? key,
    required this.queryFn,
    required this.builder,
  }) : super(key: key);

  @override
  _QueryBuilderState<T> createState() => _QueryBuilderState<T>();
}

class _QueryBuilderState<T> extends State<QueryBuilder<T>> with CachedQuery {
  Query<T>? _state;
  @override
  void initState() {
    super.initState();
    query<T>(
        key: widget.queryKey,
        queryFn: widget.queryFn,
        listener: (Query<T> data) {
          setState(() {
            _state = data;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_state);
  }

  @override
  void dispose() {
    close();
    super.dispose();
  }
}
