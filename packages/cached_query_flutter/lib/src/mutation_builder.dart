import 'dart:async';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

typedef MutationBuilderCallback<T, A> = Widget Function(
  BuildContext context,
  MutationState<T> state,
  Future<T?> Function(A args) mutate,
);

class MutationBuilder<T, A> extends StatefulWidget {
  final Mutation<T, A> mutation;
  final MutationBuilderCallback<T, A> builder;
  const MutationBuilder({
    Key? key,
    required this.mutation,
    required this.builder,
  }) : super(key: key);

  @override
  _MutationBuilderState<T, A> createState() => _MutationBuilderState<T, A>();
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
