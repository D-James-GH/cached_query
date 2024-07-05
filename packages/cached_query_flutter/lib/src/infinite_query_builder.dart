import 'dart:async';

import 'package:flutter/material.dart';

import '../cached_query_flutter.dart';

/// {@template infiniteQueryBuilderFunc}
/// The builder function is called on each widget build.
///
/// Passes [BuildContext], [InfiniteQueryState] and [InfiniteQuery].
/// {@endtemplate}
typedef InfiniteQueryBuilderFunc<T, A> = Widget Function(
  BuildContext context,
  InfiniteQueryState<T> state,
  InfiniteQuery<T, A> query,
);

/// {@template infiniteQueryBuilderCondition}
/// This function is being called everytime the query registered in the [InfiniteQueryBuilder] receives new updates
/// and let's you control when the [_InfiniteQueryBuilderState.build] method should be called
/// {@endtemplate}
typedef InfiniteQueryBuilderCondition<T> = FutureOr<bool> Function(
  InfiniteQueryState<T> oldState,
  InfiniteQueryState<T> newState,
);

/// {@template infiniteQueryBuilder}
/// Listen to changed in an [InfiniteQuery] and build the ui with the result.
/// {@endtemplate}
class InfiniteQueryBuilder<T, A> extends StatefulWidget {
  /// The [InfiniteQuery] to watch.
  final InfiniteQuery<T, A>? query;

  /// Whether the query should be called immediately.
  final bool enabled;

  /// Get a query by the queryKey.
  final Object? queryKey;

  /// {@macro infiniteQueryBuilderFunc}
  final InfiniteQueryBuilderFunc<T, A> builder;

  /// {@macro infiniteQueryBuilderCondition}
  final InfiniteQueryBuilderCondition<T>? buildWhen;

  /// {@macro infiniteQueryBuilder}
  ///
  /// The value constructor takes an infinite query rather than a key.
  const InfiniteQueryBuilder({
    super.key,
    this.query,
    this.enabled = true,
    this.queryKey,
    this.buildWhen,
    required this.builder,
  }) : assert(
          query != null || queryKey != null,
          "Query key or a infinite query must be provided.",
        );

  @override
  State<InfiniteQueryBuilder<T, A>> createState() =>
      _InfiniteQueryBuilderState<T, A>();
}

class _InfiniteQueryBuilderState<T, A>
    extends State<InfiniteQueryBuilder<T, A>> {
  late InfiniteQuery<T, A> _query;
  late InfiniteQueryState<T> _state;

  StreamSubscription<InfiniteQueryState<T>>? _subscription;

  @override
  void initState() {
    super.initState();
    if (widget.queryKey != null) {
      final q = CachedQuery.instance.getQuery(widget.queryKey!);
      assert(q != null, "No query found with the key ${widget.queryKey}");
      assert(q is InfiniteQuery<T, A>, "Query found is not of type $T");
      _query = q! as InfiniteQuery<T, A>;
    }
    if (widget.query != null) {
      _query = widget.query!;
    }
    _subscribe();
    _state = _query.state;
  }

  @override
  void didUpdateWidget(covariant InfiniteQueryBuilder<T, A> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldQuery =
        oldWidget.query ?? CachedQuery.instance.getQuery(oldWidget.queryKey!);
    final currentQuery =
        widget.query ?? CachedQuery.instance.getQuery(widget.queryKey!);
    assert(
      currentQuery is InfiniteQuery<T, A>,
      "Query found is not of type InfiniteQuery<$T, $A>",
    );
    if (oldQuery != currentQuery) {
      if (_subscription != null) {
        _unsubscribe();
        _query = currentQuery as InfiniteQuery<T, A>;
        _state = _query.state;
      }
      if (widget.enabled) {
        _subscribe();
        return;
      }
    }

    if (oldWidget.enabled != widget.enabled) {
      if (widget.enabled) {
        _subscribe();
      } else {
        _unsubscribe();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _state, _query);
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _state = _query.state;
    if (!widget.enabled) {
      if (_subscription != null) {
        _unsubscribe();
      }
      return;
    }
    _subscription = _query.stream.listen((state) async {
      if (widget.buildWhen != null) {
        final shouldRebuild = await Future.value(
          widget.buildWhen!.call(_state, state),
        );
        if (!shouldRebuild) return;
      }
      setState(() {
        _state = state;
      });
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
