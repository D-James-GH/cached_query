import 'package:cached_query/cached_query.dart';
import 'package:flutter_test/flutter_test.dart';

QueryStateMatcher<T> isQueryState<T>({
  QueryStatus? status,
  T? data,
  Object? error,
}) =>
    QueryStateMatcher<T>(
      status: status,
      data: data,
      error: error,
    );

class QueryStateMatcher<T> extends TypeMatcher<QueryState<T>> {
  final QueryStatus? _status;
  final T? _data;
  final Object? _error;

  QueryStateMatcher({QueryStatus? status, T? data, Object? error})
      : _status = status,
        _data = data,
        _error = error;

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) =>
      super.matches(item, matchState) &&
      typedMatches(item as QueryState<T>, matchState);

  bool typedMatches(QueryState<T> item, Map<dynamic, dynamic> matchState) {
    var matches = true;
    if (_status != null && _status != item.status) {
      matches = false;
    }
    if (_data != null && _data != item.data) {
      matches = false;
    }
    if (_error != null && _error != item.error) {
      matches = false;
    }
    return matches;
  }

  @override
  Description describe(Description description) {
    final parts = <String>[];
    if (_status != null) {
      parts.add('status: $_status');
    }
    if (_data != null) {
      parts.add('data: $_data');
    }
    if (_error != null) {
      parts.add('error: $_error');
    }
    return description.add('matches QueryState<$T>(${parts.join(', ')})');
  }
}
