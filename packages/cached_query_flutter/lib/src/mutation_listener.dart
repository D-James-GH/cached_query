import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';

/// {@template mutationListenerCallback}
/// Called on each state change.
///
/// Passes [MutationState].
/// {@endtemplate}
typedef MutationListenerCallback<T> = void Function(MutationState<T> state);

/// {@template mutationListenerCondition}
/// This function is being called every time the mutation registered in the [MutationListener] receives new updates
/// and let's you control when the [MutationListenerCallback] should be called
/// {@endtemplate}
typedef MutationListenerCondition<T> = FutureOr<bool> Function(
  MutationState<T> oldState,
  MutationState<T> newState,
);

/// {@template mutationListener}
/// Listen to changes in an [Mutation] and call the listener with the result.
/// {@endtemplate}
class MutationListener<T, A> extends StatefulWidget {
  /// The [Mutation] to used to update the listener.
  final Mutation<T, A> mutation;

  /// {@macro mutationListenerCallback}
  final MutationListenerCallback<T> listener;

  /// {@macro mutationListenerCondition}
  final MutationListenerCondition<T>? listenWhen;

  /// The child widget to render
  final Widget child;

  /// {@macro mutationListener}
  const MutationListener({
    Key? key,
    required this.mutation,
    required this.listener,
    this.listenWhen,
    required this.child,
  }) : super(key: key);

  @override
  State<MutationListener<T, A>> createState() => _MutationListenerState<T, A>();
}

class _MutationListenerState<T, A> extends State<MutationListener<T, A>> {
  late MutationState<T> _previousState;
  late StreamSubscription<MutationState<T>> _subscription;

  @override
  void initState() {
    super.initState();
    _previousState = widget.mutation.state;
    _subscription = widget.mutation.stream.listen((state) async {
      final listenWhen = widget.listenWhen;
      if (listenWhen != null) {
        final shouldListen =
            await Future.value(listenWhen(_previousState, state));
        if (!shouldListen) return;
      }
      widget.listener(state);
      _previousState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
