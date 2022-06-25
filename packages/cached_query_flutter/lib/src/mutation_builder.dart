import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';

/// {@template mutationBuilder}
/// Called on each widget build.
///
/// Passes [BuildContext], [MutationState], and a mutate function.
///
/// Calling [mutate] will start the mutation with the given arguments.
/// {@endTemplate}
typedef MutationBuilderCallback<T, A> = Widget Function(
  BuildContext context,
  MutationState<T> state,
  Future<T?> Function(A args) mutate,
);

// todo(Dan): add examples to docs.
/// {@template mutationBuilder}
/// Listen to changes in an [Mutation] and build the ui with the result.
/// {@endTemplate}
class MutationBuilder<T, A> extends StatefulWidget {
  /// The [Mutation] to used to update the ui.
  final Mutation<T, A> mutation;

  /// {@macro mutationBuilder}
  final MutationBuilderCallback<T, A> builder;

  /// {@macro mutationBuilder}
  const MutationBuilder({
    Key? key,
    required this.mutation,
    required this.builder,
  }) : super(key: key);

  @override
  State<MutationBuilder<T, A>> createState() => _MutationBuilderState<T, A>();
}

class _MutationBuilderState<T, A> extends State<MutationBuilder<T, A>> {
  late MutationState<T> _state;
  late StreamSubscription<MutationState<T>> _subscription;

  @override
  void initState() {
    super.initState();
    _state = widget.mutation.state;
    _subscription = widget.mutation.stream.listen((state) {
      setState(() {
        _state = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _state, widget.mutation.mutate);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
