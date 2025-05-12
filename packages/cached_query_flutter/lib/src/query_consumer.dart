import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';

import 'query_builder.dart';
import 'query_listener.dart';

/// {@template queryListener}
/// Combination of [QueryBuilder] and [QueryListener] which allows listening to specific query changes
/// and also rebuilds on query changes.
/// {@endtemplate}
class QueryConsumer<T extends QueryState<dynamic>> extends StatelessWidget {
  /// The [Query] to used to update the listener.
  final Cacheable<dynamic, T> query;

  /// Whether the query should be called immediately.
  final bool enabled;

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
    super.key,
    this.enabled = true,
    required this.query,
    required this.listener,
    this.listenWhen,
    required this.builder,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return QueryListener(
      query: query,
      listener: listener,
      enabled: enabled,
      listenWhen: listenWhen,
      child: QueryBuilder<T>(
        query: query,
        enabled: enabled,
        buildWhen: buildWhen,
        builder: builder,
      ),
    );
  }
}
