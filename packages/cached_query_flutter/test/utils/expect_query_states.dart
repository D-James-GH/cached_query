import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:flutter_test/flutter_test.dart';

import '../matchers/is_query_state.dart';

Sink<QueryState<T>> expectQueryStates<T>(
  Iterable<QueryStateMatcher<T>> matchers,
) {
  final controller = StreamController<QueryState<T>>();
  expect(controller.stream, emitsInOrder(matchers));
  return controller.sink;
}
