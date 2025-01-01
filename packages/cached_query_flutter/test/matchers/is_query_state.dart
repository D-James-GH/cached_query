import 'package:cached_query/cached_query.dart';
import 'package:flutter_test/flutter_test.dart';

QueryStateMatcher<T> isQueryState<T>(QueryState<T> state) =>
    QueryStateMatcher<T>(state);

class QueryStateMatcher<T> extends TypeMatcher<QueryState<T>> {
  final QueryState<dynamic> state;

  QueryStateMatcher(this.state);

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) =>
      super.matches(item, matchState) &&
      typedMatches(item as QueryState<T>, matchState);

  bool typedMatches(QueryState<T> item, Map<dynamic, dynamic> matchState) {
    if (item.runtimeType != state.runtimeType) {
      return false;
    }
    return switch (item) {
      QueryError<T>(:final error, :final data) =>
        error == (state as QueryError).error && data == state.data,
      InfiniteQueryError(:final error, :final data) =>
        error == (state as InfiniteQueryError).error && data == state.data,
      _ => item.data == state.data,
    };
  }

  @override
  Description describe(Description description) {
    return description.add('matches ${state.toString()}');
  }
}
