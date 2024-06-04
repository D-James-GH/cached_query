import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';

import 'query_builder.dart';
import 'query_listener.dart';

/// {@template queryListener}
/// Combination of [QueryBuilder] and [QueryListener] which allows listening to specific query changes
/// and also rebuilds on query changes.
/// {@endtemplate}
class QueryConsumer<T> extends StatelessWidget {
  /// The [Query] to used to update the listener.
  final Query<T> query;

  /// {@macro queryListenerCallback}
  final QueryListenerCallback<T> listener;

  /// {@macro queryListenerCondition}
  final QueryListenerCondition<T>? listenWhen;

  /// {@macro queryBuilder}
  final QueryBuilderCallback<T> builder;

  /// {@macro queryBuilderCondition}
  final QueryBuilderCondition<T>? buildWhen;

  /// {@macro QueryConsumer}
  const QueryConsumer({
    Key? key,
    required this.query,
    required this.listener,
    this.listenWhen,
    required this.builder,
    this.buildWhen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryListener(
      query: query,
      listener: listener,
      listenWhen: listenWhen,
      child: QueryBuilder(
        query: query,
        buildWhen: buildWhen,
        builder: builder,
      ),
    );
  }
}
