import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';

import 'mutation_builder.dart';
import 'mutation_listener.dart';

/// {@template mutationListener}
/// Combination of [MutationBuilder] and [MutationListener] which allows listening to specific mutation changes
/// and also rebuilds on mutation changes.
/// {@endtemplate}
class MutationConsumer<T, A> extends StatelessWidget {
  /// The [Mutation] to used to update the listener.
  final Mutation<T, A> mutation;

  /// {@macro mutationListenerCallback}
  final MutationListenerCallback<T> listener;

  /// {@macro mutationListenerCondition}
  final MutationListenerCondition<T>? listenWhen;

  /// {@macro mutationBuilder}
  final MutationBuilderCallback<T, A> builder;

  /// {@macro mutationBuilderCondition}
  final MutationBuilderCondition<T>? buildWhen;

  /// {@macro MutationConsumer}
  const MutationConsumer({
    Key? key,
    required this.mutation,
    required this.listener,
    this.listenWhen,
    required this.builder,
    this.buildWhen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MutationListener(
      mutation: mutation,
      listener: listener,
      listenWhen: listenWhen,
      child: MutationBuilder(
        mutation: mutation,
        buildWhen: buildWhen,
        builder: builder,
      ),
    );
  }
}
