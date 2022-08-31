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

/// {@template infiniteQueryBuilder}
/// Listen to changed in an [InfiniteQuery] and build the ui with the result.
/// {@endtemplate}
class InfiniteQueryBuilder<T, A> extends StatefulWidget {
  /// The [InfiniteQuery] to watch.
  final InfiniteQuery<T, A> query;

  /// {@macro infiniteQueryBuilderFunc}
  final InfiniteQueryBuilderFunc<T, A> builder;

  /// {@macro infiniteQueryBuilder}
  ///
  /// The value constructor takes an infinite query rather than a key.
  const InfiniteQueryBuilder.value({
    Key? key,
    required this.query,
    required this.builder,
  }) : super(key: key);

  /// {@macro infiniteQueryBuilder}
  factory InfiniteQueryBuilder({
    Key? key,
    required Object queryKey,
    required InfiniteQueryBuilderFunc<T, A> builder,
  }) {
    final query = CachedQuery.instance.getQuery(queryKey);
    assert(query != null, "No Query found.");
    assert(
      query is InfiniteQuery<T, A>,
      "The found query is not type InfiniteQuery<$T, $A>. It is actually ${query.runtimeType}",
    );
    return InfiniteQueryBuilder.value(
      builder: builder,
      query: query as InfiniteQuery<T, A>,
    );
  }

  @override
  State<InfiniteQueryBuilder<T, A>> createState() =>
      _InfiniteQueryBuilderState<T, A>();
}

class _InfiniteQueryBuilderState<T, A>
    extends State<InfiniteQueryBuilder<T, A>> {
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
